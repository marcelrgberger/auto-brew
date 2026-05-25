import Foundation
import os

private let preUpgradeLogger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "PreUpgradeSnapshot")

/// Snapshot-then-record helper shared by the auto-update scheduler and
/// the manual cask-upgrade buttons in BrewStore. Lives outside the
/// scheduler so manual upgrades (which don't go through `runBrewUpdate`)
/// can take advantage of the same pre-upgrade-safety net without
/// duplicating logic.
///
/// Both call-sites care about the same three things in the same order:
///   1. capture a snapshot if the policy is on and we can resolve a
///      bundle ID,
///   2. run the upgrade,
///   3. record an `UpgradeHistoryEntry` regardless of the snapshot
///      outcome, so the audit trail stays complete even when the
///      snapshot was skipped or failed.
///
/// Failure to capture a snapshot **never** blocks the upgrade — that is
/// the whole reason this helper splits step (1) from step (2): the
/// upgrade is the user-visible action, the snapshot is a safety net.
@MainActor
enum PreUpgradeSnapshot {
    /// Captures a snapshot of `bundleID`'s user data right before `token`'s
    /// upgrade if the policy is on and the bundle resolves. `bundleID` and
    /// `displayName` come from the caller (the scheduler resolves them via
    /// `InstalledAppsStore`; manual buttons already have the
    /// `InstalledApp` in hand) so this helper does no discovery on its
    /// own.
    static func capture(
        token: String,
        bundleID: String?,
        displayName: String,
        fromVersion: String,
        policyEnabled: Bool
    ) async -> UUID? {
        guard policyEnabled else { return nil }
        guard let bundleID else {
            preUpgradeLogger.info("Pre-upgrade snapshot skipped for \(token, privacy: .public) — no bundle ID")
            return nil
        }
        // Defensive: a near-full disk is a worse outcome than no snapshot
        // — we would only be filling the home-directory volume and
        // breaking unrelated apps. The upgrade still runs; the user
        // just loses the rollback affordance for this one cask.
        let minGB = SettingsStore.shared.minFreeGBForSnapshot
        if !DiskSpaceMonitor.hasAtLeast(minGB) {
            let availableGB = (DiskSpaceMonitor.availableBytes() ?? 0) / 1_073_741_824
            preUpgradeLogger.warning("Pre-upgrade snapshot skipped for \(token, privacy: .public) — only \(availableGB) GiB free, threshold is \(minGB) GiB")
            NotificationManager.shared.showLowDiskSpace(forToken: token, availableGB: availableGB, thresholdGB: minGB)
            return nil
        }

        // Per-cask pre-snapshot hook: lets the user flush in-memory
        // state through `osascript`/`pmset`/whatever before we copy
        // their files. Failure is logged but never blocks the
        // snapshot — the user explicitly opts in and chose what to
        // run.
        if let command = SettingsStore.shared.packageOverrides
            .first(where: { $0.token == token })?
            .preSnapshotCommand,
           !command.trimmingCharacters(in: .whitespaces).isEmpty {
            await runPreSnapshotHook(token: token, command: command)
        }

        do {
            let snapshot = try await SnapshotService.shared.createSnapshot(
                bundleID: bundleID,
                displayName: displayName,
                caskToken: token,
                sourceAppVersion: fromVersion
            )
            preUpgradeLogger.info("Pre-upgrade snapshot \(token, privacy: .public) → \(snapshot.id)")
            return snapshot.id
        } catch {
            preUpgradeLogger.warning("Pre-upgrade snapshot failed for \(token, privacy: .public): \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }

    /// Writes one row to `UpgradeHistoryStore`. The outcome is the
    /// per-cask result from the parser (`succeeded` / `failed` /
    /// `attempted`), not an aggregate flag. The snapshot ID may be nil
    /// when capture was disabled, skipped, or failed — the row is still
    /// useful as an audit entry, it just won't show a Roll Back button.
    /// Runs the per-cask pre-snapshot hook with a 30 s wall clock.
    /// Anything beyond that suggests the command itself is hung, and
    /// blocking the snapshot+upgrade pipeline behind a stuck script
    /// is worse than dropping the hook for that one run.
    private static func runPreSnapshotHook(token: String, command: String) async {
        preUpgradeLogger.info("Running pre-snapshot hook for \(token, privacy: .public)")
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    let process = Process()
                    process.executableURL = URL(fileURLWithPath: "/bin/bash")
                    process.arguments = ["-c", command]
                    let outPipe = Pipe()
                    let errPipe = Pipe()
                    process.standardOutput = outPipe
                    process.standardError = errPipe
                    try process.run()
                    process.waitUntilExit()
                    if process.terminationStatus != 0 {
                        let err = String(data: errPipe.fileHandleForReading.readDataToEndOfFile(),
                                         encoding: .utf8) ?? ""
                        preUpgradeLogger.warning("Pre-snapshot hook for \(token, privacy: .public) exited \(process.terminationStatus): \(err, privacy: .public)")
                    }
                }
                group.addTask {
                    try await Task.sleep(for: .seconds(30))
                    throw CancellationError()
                }
                try await group.next()
                group.cancelAll()
            }
        } catch {
            preUpgradeLogger.warning("Pre-snapshot hook for \(token, privacy: .public) timed out or failed — proceeding with snapshot anyway")
        }
    }

    static func record(
        token: String,
        displayName: String,
        bundleID: String?,
        fromVersion: String,
        toVersion: String,
        snapshotID: UUID?,
        outcome: CaskUpgradeOutcome,
        retryCount: Int = 0,
        nextRetryAt: Date? = nil
    ) {
        UpgradeHistoryStore.shared.append(UpgradeHistoryEntry(
            id: UUID(),
            timestamp: Date(),
            token: token,
            displayName: displayName,
            fromVersion: fromVersion,
            toVersion: toVersion,
            bundleID: bundleID,
            snapshotID: snapshotID,
            outcome: outcome,
            retryCount: retryCount,
            nextRetryAt: nextRetryAt
        ))
    }
}
