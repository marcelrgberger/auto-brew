import Foundation
import os

/// Triggers `BrewManager.runFullUpdate()` in either idle or scheduled mode.
/// Also watches sleep/wake to catch up on runs missed during sleep. Doesn't
/// react to settings changes on its own — callers invoke `restartScheduling()`.
@Observable
@MainActor
final class SchedulerService {
    static let shared = SchedulerService()

    private(set) var state: SchedulerState = .idle

    private let settings = SettingsStore.shared
    private let brewManager = BrewManager.shared
    private let sleepWakeObserver = SleepWakeObserver()
    private let notificationManager = NotificationManager.shared
    private let pendingStore = PendingUpdatesStore.shared
    private let ledgerStore = UpdateLedgerStore()
    private let historyStore = UpgradeHistoryStore.shared
    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "Scheduler")

    private var pollingTask: Task<Void, Never>?
    private var scheduledTask: Task<Void, Never>?
    private var retryTask: Task<Void, Never>?

    /// How often the retry-pass wakes up to check the history for
    /// retry-due failed entries. 30 minutes is the granularity we
    /// promise — finer than that costs idle CPU; coarser than that
    /// makes the 1 h initial backoff feel sluggish.
    static let retryCheckInterval: TimeInterval = 30 * 60

    /// Scheduler-level reentrancy guard. `BrewManager.isRunning` toggles per
    /// stage so it can't tell us "a whole pipeline is in flight" — between
    /// `runUpdate` and `runUpgrade` the flag is briefly false and a second
    /// trigger could slip in. This bool covers the whole sequence.
    private var pipelineInProgress = false

    var lastRunDate: Date? { settings.lastRunDate }
    var isRunning: Bool { brewManager.isRunning }
    var currentStage: BrewStage? { brewManager.currentStage }

    func start() {
        logger.info("Scheduler starting with mode: \(self.settings.triggerMode.rawValue)")

        sleepWakeObserver.onWakeWithMissedRun = { [weak self] in
            self?.handleMissedRun()
        }
        sleepWakeObserver.startObserving()

        notificationManager.onRunNowRequested = { [weak self] in
            Task { @MainActor in
                await self?.triggerManualRun()
            }
        }

        notificationManager.onRollbackRequested = { [weak self] entryID in
            Task { @MainActor in
                await self?.rollbackUpgrade(forEntryID: entryID)
            }
        }

        restartScheduling()
    }

    func restartScheduling() {
        pollingTask?.cancel()
        scheduledTask?.cancel()
        retryTask?.cancel()

        switch settings.triggerMode {
        case .idle:
            state = .waitingForIdle
            startIdlePolling()
        case .scheduled:
            state = .waitingForSchedule
            startScheduledTimer()
        }
        startRetryPolling()
    }

    func triggerManualRun() async {
        await runBrewUpdate()
    }

    // MARK: - Idle Mode

    /// 60-second polling is plenty — the user won't notice 30 seconds either
    /// way, and we avoid waking the CPU every second.
    private func startIdlePolling() {
        pollingTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                guard !Task.isCancelled else { break }
                await self?.checkIdleAndRun()
            }
        }
    }

    private func checkIdleAndRun() async {
        guard !settings.didRunToday, !brewManager.isRunning else { return }

        guard let idleSeconds = IdleDetector.systemIdleTime() else {
            logger.warning("Could not read idle time")
            return
        }

        let requiredSeconds = TimeInterval(settings.idleMinutes * 60)
        if idleSeconds >= requiredSeconds {
            logger.info("Idle threshold reached (\(Int(idleSeconds))s >= \(Int(requiredSeconds))s)")
            await runBrewUpdate()
        }
    }

    // MARK: - Scheduled Mode

    private func startScheduledTimer() {
        scheduledTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { break }
                guard let delay = self.secondsUntilNextRun() else {
                    try? await Task.sleep(for: .seconds(60))
                    continue
                }

                self.logger.info("Next scheduled run in \(Int(delay)) seconds")

                if delay > 0 {
                    try? await Task.sleep(for: .seconds(delay))
                }
                guard !Task.isCancelled else { break }

                if !self.settings.didRunToday {
                    await self.runBrewUpdate()
                }

                // One-hour cooldown — otherwise the loop would immediately
                // compute `secondsUntilNextRun` for tomorrow and spin needlessly.
                try? await Task.sleep(for: .seconds(3600))
            }
        }
    }

    private func secondsUntilNextRun() -> TimeInterval? {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = settings.scheduledHour
        components.minute = settings.scheduledMinute

        guard var target = calendar.date(from: components) else { return nil }

        if target <= now {
            guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: target) else { return nil }
            target = tomorrow
        }

        return target.timeIntervalSince(now)
    }

    // MARK: - Brew Execution

    private func runBrewUpdate() async {
        guard !pipelineInProgress else {
            logger.info("Brew run skipped — pipeline already in progress")
            return
        }

        guard brewManager.isHomebrewInstalled else {
            state = .failed("Homebrew not installed")
            logger.warning("Brew update skipped — Homebrew not installed")
            return
        }

        pipelineInProgress = true
        defer { pipelineInProgress = false }

        var upgradeError: Error?

        do {
            // 1. brew update — refresh the index so fetchOutdated sees latest.
            state = .running(.updating)
            try await brewManager.runUpdate()

            // 2. Pull the outdated list and route each entry through the
            //    update policy. Stuff that's auto-installable goes into the
            //    upgrade call; anything needing approval lands in the
            //    pending store.
            await brewManager.fetchOutdated()
            let outdated = brewManager.outdatedPackages
            let now = Date()

            let evaluator = UpdateEvaluator(
                defaults: settings.policyDefaults,
                overrides: settings.packageOverrides,
                existingPending: pendingStore.updates
            )
            let bundle = evaluator.evaluate(outdated, ledger: ledgerStore.ledger, now: now)

            // Persist firstSeen + housekeeping on the ledger so the cool-off
            // window is measured from the first sighting next run too.
            for package in outdated {
                let kind: PackageKind = package.isCask ? .cask : .formula
                _ = ledgerStore.touch(kind: kind, token: package.name, version: package.newVersion, now: now)
            }
            let activeKeys = Set(outdated.map { package -> String in
                let kind: PackageKind = package.isCask ? .cask : .formula
                return UpdateLedger.key(kind: kind, token: package.name, version: package.newVersion)
            })
            ledgerStore.purge(keeping: activeKeys)

            // Carry the user's prior decisions forward and surface anything
            // new that needs a verdict.
            let priorPendingCount = pendingStore.pendingCount
            pendingStore.replace(with: bundle.needsApproval)
            let newPendingCount = pendingStore.pendingCount

            // 3. Pick everything that's allowed to install right now.
            let formulaeToUpgrade = bundle.autoInstall.filter { !$0.isCask }.map(\.name)
            let casksToUpgrade = bundle.autoInstall.filter { $0.isCask }
            let casksToUpgradeNames = casksToUpgrade.map(\.name)
            let approvedTokens = Set(pendingStore.approvedTokens)

            // Before brew rewrites the .app, capture user data per cask so
            // the History view can offer a one-click rollback. Failures are
            // swallowed — never block an upgrade because a snapshot didn't
            // take.
            var preSnapshots: [String: PreUpgradeContext] = [:]
            if !casksToUpgrade.isEmpty {
                preSnapshots = await capturePreUpgradeSnapshots(forCasks: casksToUpgrade)
            }

            if formulaeToUpgrade.isEmpty && casksToUpgradeNames.isEmpty {
                logger.info("Nothing to upgrade — \(bundle.waitingForCooldown.count) waiting, \(bundle.needsApproval.count) pending approval")
            } else {
                do {
                    let outcomes = try await brewManager.runUpgrade(formulae: formulaeToUpgrade, casks: casksToUpgradeNames)
                    // Only drop approved entries from the pending list after
                    // the upgrade actually went through — a failure should
                    // leave them queued so the next run retries.
                    pendingStore.remove(tokens: approvedTokens)
                    recordUpgradeHistory(for: casksToUpgrade, preSnapshots: preSnapshots, outcomes: outcomes, runThrew: false)
                } catch {
                    // Swallow here so cleanup still runs; rethrow shape is
                    // preserved via `upgradeError` below.
                    upgradeError = error
                    recordUpgradeHistory(for: casksToUpgrade, preSnapshots: preSnapshots, outcomes: [:], runThrew: true)
                }
            }

            // 4. cleanup — disk hygiene regardless of upgrade outcome.
            do {
                try await brewManager.runCleanup()
            } catch {
                // If the upgrade succeeded but cleanup failed, surface that;
                // otherwise the upgrade failure takes precedence.
                if upgradeError == nil { upgradeError = error }
            }

            if let upgradeError {
                throw upgradeError
            }

            settings.lastRunDate = Date()
            if settings.autoCleanupSnapshots {
                do {
                    try SnapshotService.shared.cleanup(olderThanDays: settings.snapshotRetentionDays)
                } catch {
                    logger.error("Snapshot cleanup failed: \(error.localizedDescription)")
                }
            }

            if let stage = brewManager.currentStage {
                state = .running(stage)
            }
            state = .completed(Date())
            sleepWakeObserver.clearMissedRun()
            // Refresh even when nothing mutated this run — keeps the
            // widget's "Updated <relative>" footer honest.
            WidgetStateWriter.refresh()

            // Notification policy:
            //   - completion notification: always (when notifications are on)
            //   - pending-approval notification: only when *new* entries
            //     showed up since the last run, so the user isn't pinged
            //     about the same list over and over.
            if settings.showNotifications {
                notificationManager.showCompletionNotification(success: true)
                if newPendingCount > priorPendingCount {
                    let preview = pendingStore.updates
                        .filter { $0.decision.isPending }
                        .prefix(3)
                        .map(\.displayName)
                    notificationManager.showPendingApprovals(count: newPendingCount, sampleNames: Array(preview))
                }
            }
            logger.info("Brew run done — \(bundle.autoInstall.count) upgraded, \(bundle.waitingForCooldown.count) waiting, \(newPendingCount) pending")
        } catch {
            state = .failed(error.localizedDescription)
            if settings.showNotifications {
                let rollbackTarget = findRollbackTarget()
                notificationManager.showCompletionNotification(
                    success: false,
                    detail: error.localizedDescription,
                    rollbackEntryID: rollbackTarget?.id,
                    rollbackTargetName: rollbackTarget?.displayName
                )
            }
            logger.error("Brew update failed: \(error.localizedDescription)")
        }
    }

    /// Run from the widget's Roll Back link / external triggers that do
    /// not carry a specific history entry. Falls back to the same
    /// newest-failed-with-live-snapshot lookup the notification builder
    /// uses, then delegates to the per-entry rollback path.
    func rollbackMostRecentFailedUpgrade() async {
        guard let entry = findRollbackTarget() else {
            logger.warning("Widget/external rollback skipped — no candidate with live snapshot")
            return
        }
        await rollbackUpgrade(forEntryID: entry.id)
    }

    /// Newest failed history entry whose pre-upgrade snapshot is still on
    /// disk — the candidate the Roll Back notification action would
    /// restore. Nil when nothing to roll back to, in which case the
    /// notification stays a plain completion banner.
    private func findRollbackTarget() -> UpgradeHistoryEntry? {
        let snapshots = (try? SnapshotService.shared.listSnapshots()) ?? []
        let liveIDs = Set(snapshots.map(\.id))
        return historyStore.entries.first { entry in
            entry.outcome == .failed &&
            entry.snapshotID.map(liveIDs.contains) == true
        }
    }

    /// Run from the notification's `ROLL_BACK` action. Resolves the history
    /// entry to a live snapshot and fires the same transactional restore
    /// the History view would. Failures are logged; a second failure
    /// notification would be more noise than signal.
    private func rollbackUpgrade(forEntryID entryID: UUID) async {
        guard let entry = historyStore.entries.first(where: { $0.id == entryID }),
              let snapshotID = entry.snapshotID else {
            logger.warning("Rollback skipped — history entry \(entryID) has no snapshot")
            return
        }
        let snapshots = (try? SnapshotService.shared.listSnapshots()) ?? []
        guard let snapshot = snapshots.first(where: { $0.id == snapshotID }) else {
            logger.warning("Rollback skipped — snapshot \(snapshotID) no longer on disk")
            return
        }
        do {
            try await SnapshotService.shared.restoreSnapshot(snapshot, terminateApp: true)
            logger.info("Rollback complete for \(entry.token, privacy: .public)")
        } catch {
            logger.error("Rollback failed for \(entry.token, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Missed Run

    // MARK: - Retry pass

    /// Poll the history every `retryCheckInterval` for failed
    /// upgrades whose backoff window has elapsed. Runs independently
    /// of idle/scheduled triggers so a single user's daily-run skip
    /// doesn't block 1 h-after-failure retries.
    private func startRetryPolling() {
        retryTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Self.retryCheckInterval))
                guard !Task.isCancelled else { break }
                await self?.runRetryDuePass()
            }
        }
    }

    /// Picks every history row whose outcome is `.failed`,
    /// `nextRetryAt <= now`, and whose retry budget is not yet
    /// exhausted, and re-runs only those casks through
    /// `brewManager.runUpgrade`. The daily-run flag is intentionally
    /// not touched — a retry is not a fresh user-facing run.
    private func runRetryDuePass() async {
        guard !pipelineInProgress, brewManager.isHomebrewInstalled else { return }
        let now = Date()
        let candidates = historyStore.entries.filter { entry in
            guard entry.outcome == .failed,
                  let nextRetryAt = entry.nextRetryAt,
                  nextRetryAt <= now,
                  entry.retryCount < UpgradeHistoryEntry.maxRetries else { return false }
            return true
        }
        guard !candidates.isEmpty else { return }

        // Deduplicate by token — only the newest entry per token is
        // the source of truth for this retry pass.
        var seen = Set<String>()
        let uniqueCandidates = candidates.filter { entry in
            seen.insert(entry.token).inserted
        }
        let tokens = uniqueCandidates.map(\.token)

        logger.info("Retry pass: \(tokens.count) failed cask(s) due — \(tokens.joined(separator: ", "), privacy: .public)")

        pipelineInProgress = true
        defer { pipelineInProgress = false }

        let snapshotMap = await capturePreUpgradeSnapshots(forCasks: uniqueCandidates.map { entry in
            OutdatedPackage(
                name: entry.token,
                currentVersion: entry.fromVersion,
                newVersion: entry.toVersion,
                isCask: true
            )
        })

        do {
            let outcomes = try await brewManager.runUpgrade(formulae: [], casks: tokens)
            recordRetryHistory(for: uniqueCandidates, preSnapshots: snapshotMap, outcomes: outcomes, runThrew: false)
        } catch {
            recordRetryHistory(for: uniqueCandidates, preSnapshots: snapshotMap, outcomes: [:], runThrew: true)
            logger.warning("Retry pass failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    /// Specialised history writer for retry runs — reuses the
    /// from/to versions from the originating failed entry rather than
    /// the live `brew outdated` snapshot.
    private func recordRetryHistory(for entries: [UpgradeHistoryEntry],
                                    preSnapshots: [String: PreUpgradeContext],
                                    outcomes: [String: CaskUpgradeOutcome],
                                    runThrew: Bool) {
        let now = Date()
        for entry in entries {
            let ctx = preSnapshots[entry.token]
            let outcome: CaskUpgradeOutcome = runThrew ? .failed : (outcomes[entry.token] ?? .attempted)
            let (retryCount, nextRetryAt) = computeRetryState(for: entry.token, outcome: outcome, now: now)
            PreUpgradeSnapshot.record(
                token: entry.token,
                displayName: ctx?.displayName ?? entry.displayName,
                bundleID: ctx?.bundleID ?? entry.bundleID,
                fromVersion: entry.fromVersion,
                toVersion: entry.toVersion,
                snapshotID: ctx?.snapshotID,
                outcome: outcome,
                retryCount: retryCount,
                nextRetryAt: nextRetryAt
            )
        }
    }

    private func handleMissedRun() {
        guard settings.showNotifications else {
            Task { await triggerManualRun() }
            return
        }
        notificationManager.showMissedRunNotification()
    }

    // MARK: - Pre-Upgrade Snapshot + History

    /// Carries the snapshot the scheduler took right before a cask was
    /// upgraded. `snapshotID` is `nil` when the cask had nothing to snapshot
    /// (CLI-only cask, app not under /Applications) or the snapshot failed;
    /// the history row is still written so the audit trail is complete.
    private struct PreUpgradeContext {
        let snapshotID: UUID?
        let bundleID: String?
        let displayName: String
    }

    /// Best-effort snapshot of each cask's user data right before its
    /// upgrade. Looks up the bundle ID via `InstalledAppsStore` (refreshing
    /// once if the store is empty) and delegates the actual snapshot work
    /// to `PreUpgradeSnapshot.capture` so manual upgrades from BrewStore
    /// share the same code path. Every error path produces a `nil`-snapshot
    /// context rather than throwing — a snapshot failure must never block
    /// the upgrade itself.
    private func capturePreUpgradeSnapshots(forCasks casks: [OutdatedPackage]) async -> [String: PreUpgradeContext] {
        if InstalledAppsStore.shared.apps.isEmpty {
            await InstalledAppsStore.shared.refresh()
        }
        let apps = InstalledAppsStore.shared.apps
        let policyEnabled = settings.autoSnapshotBeforeUpgrade
        var result: [String: PreUpgradeContext] = [:]
        for cask in casks {
            // Honour scheduler cancellation between snapshots — a 10-cask pass
            // on a slow disk can easily run several minutes, long enough for
            // the user to flip trigger mode or quit.
            if Task.isCancelled { return result }
            let app = apps.first(where: { ($0.caskToken ?? "").lowercased() == cask.name.lowercased() })
            let displayName = app?.displayName ?? cask.name
            let snapshotID = await PreUpgradeSnapshot.capture(
                token: cask.name,
                bundleID: app?.bundleID,
                displayName: displayName,
                fromVersion: cask.currentVersion,
                policyEnabled: policyEnabled
            )
            result[cask.name] = PreUpgradeContext(snapshotID: snapshotID,
                                                  bundleID: app?.bundleID,
                                                  displayName: displayName)
        }
        return result
    }

    /// Writes one history row per requested cask. The outcome map comes
    /// from `BrewUpgradeOutcomeParser`; tokens that brew never mentioned
    /// (skipped no-ops, greedy mode side effects) are absent from the map
    /// and default to `.attempted`. When `runUpgrade` itself threw, the
    /// outcomes map is empty and every cask falls to `.failed` because we
    /// only got there from the catch branch.
    ///
    /// For failed casks we carry the retry counter forward from the
    /// last entry for the same token, so a third consecutive failure
    /// lands on `retryCount=2` and a fourth (sticky-failed) would land
    /// on `retryCount=3` with `nextRetryAt=nil` — the retry pass
    /// ignores those.
    private func recordUpgradeHistory(for casks: [OutdatedPackage],
                                      preSnapshots: [String: PreUpgradeContext],
                                      outcomes: [String: CaskUpgradeOutcome],
                                      runThrew: Bool) {
        let now = Date()
        for cask in casks {
            let ctx = preSnapshots[cask.name]
            let outcome: CaskUpgradeOutcome
            if runThrew {
                outcome = .failed
            } else {
                outcome = outcomes[cask.name] ?? .attempted
            }

            let (retryCount, nextRetryAt) = computeRetryState(for: cask.name, outcome: outcome, now: now)

            PreUpgradeSnapshot.record(
                token: cask.name,
                displayName: ctx?.displayName ?? cask.name,
                bundleID: ctx?.bundleID,
                fromVersion: cask.currentVersion,
                toVersion: cask.newVersion,
                snapshotID: ctx?.snapshotID,
                outcome: outcome,
                retryCount: retryCount,
                nextRetryAt: nextRetryAt
            )
        }
    }

    /// Looks at the most-recent prior history entry for `token` and
    /// computes the new retry state. Success and unclear outcomes
    /// reset the counter; failures increment and produce the next
    /// backoff window — until the budget is exhausted, at which point
    /// the row becomes sticky-failed (`nextRetryAt == nil`).
    private func computeRetryState(for token: String,
                                   outcome: CaskUpgradeOutcome,
                                   now: Date) -> (retryCount: Int, nextRetryAt: Date?) {
        switch outcome {
        case .succeeded, .attempted:
            return (0, nil)
        case .failed:
            let previousFailure = historyStore.entries
                .first(where: { $0.token == token && $0.outcome == .failed })
            let previousRetryCount = previousFailure?.retryCount ?? 0
            let nextRetryAt = UpgradeHistoryEntry.nextRetryDate(previousRetryCount: previousRetryCount, now: now)
            // When the budget is exhausted the new entry still
            // carries the saturated retryCount so the UI can render
            // "Retries exhausted" instead of "Attempt 4".
            let newRetryCount = min(previousRetryCount + 1, UpgradeHistoryEntry.maxRetries)
            return (newRetryCount, nextRetryAt)
        }
    }

    private init() {}
}
