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
        // Measure the volume the snapshot is written to, which is an
        // external drive when the user moved snapshot storage there.
        let minGB = SettingsStore.shared.minFreeGBForSnapshot
        let storageRoot = SnapshotService.shared.storageRoot
        if !DiskSpaceMonitor.hasAtLeast(minGB, volume: storageRoot) {
            let availableGB = (DiskSpaceMonitor.availableBytes(volume: storageRoot) ?? 0) / 1_073_741_824
            preUpgradeLogger.warning("Pre-upgrade snapshot skipped for \(token, privacy: .public) — only \(availableGB) GiB free, threshold is \(minGB) GiB")
            if SettingsStore.shared.showNotifications {
                NotificationManager.shared.showLowDiskSpace(forToken: token, availableGB: availableGB, thresholdGB: minGB)
            }
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

    /// Wall clock for the per-cask pre-snapshot hook.
    static let hookTimeout: TimeInterval = 30

    enum HookResult: Equatable, Sendable {
        case exited(Int32)
        case timedOut
        case failedToLaunch(String)
    }

    /// Runs the per-cask pre-snapshot hook. Anything beyond the timeout
    /// suggests the command itself is hung, and blocking the
    /// snapshot+upgrade pipeline behind a stuck script is worse than
    /// dropping the hook for that one run.
    private static func runPreSnapshotHook(token: String, command: String) async {
        preUpgradeLogger.info("Running pre-snapshot hook for \(token, privacy: .public)")
        switch await runHook(command: command, timeout: hookTimeout) {
        case .exited(0):
            break
        case .exited(let status):
            preUpgradeLogger.warning("Pre-snapshot hook for \(token, privacy: .public) exited \(status) — proceeding with snapshot anyway")
        case .timedOut:
            preUpgradeLogger.warning("Pre-snapshot hook for \(token, privacy: .public) timed out after \(Int(hookTimeout)) s and was terminated — proceeding with snapshot anyway")
        case .failedToLaunch(let reason):
            preUpgradeLogger.warning("Pre-snapshot hook for \(token, privacy: .public) could not start: \(reason, privacy: .public)")
        }
    }

    /// Runs `command` through `/bin/bash -c` and returns once the shell
    /// exits or `timeout` elapses. On timeout the whole process group gets
    /// SIGTERM and, after `killGrace`, SIGKILL — the hook runs in its own
    /// group, so children it started are stopped too and AutoBrew's own
    /// group is never signalled. Output goes to `/dev/null`, not to pipes:
    /// a pipe nobody reads blocks a chatty command, and reading one to EOF
    /// blocks while any child still holds it open.
    nonisolated static func runHook(command: String, timeout: TimeInterval, killGrace: TimeInterval = 2) async -> HookResult {
        var pid: pid_t = 0
        var attributes: posix_spawnattr_t?
        var fileActions: posix_spawn_file_actions_t?
        posix_spawnattr_init(&attributes)
        posix_spawn_file_actions_init(&fileActions)
        defer {
            posix_spawnattr_destroy(&attributes)
            posix_spawn_file_actions_destroy(&fileActions)
        }
        // New process group led by the child (pgroup 0). Start with an
        // empty signal mask and default dispositions: the spawning thread
        // may block or ignore signals, and the hook must see SIGTERM.
        var emptyMask = sigset_t()
        var allSignals = sigset_t()
        sigemptyset(&emptyMask)
        sigfillset(&allSignals)
        posix_spawnattr_setflags(&attributes, Int16(POSIX_SPAWN_SETPGROUP | POSIX_SPAWN_SETSIGMASK | POSIX_SPAWN_SETSIGDEF))
        posix_spawnattr_setpgroup(&attributes, 0)
        posix_spawnattr_setsigmask(&attributes, &emptyMask)
        posix_spawnattr_setsigdefault(&attributes, &allSignals)
        posix_spawn_file_actions_addopen(&fileActions, 0, "/dev/null", O_RDONLY, 0)
        posix_spawn_file_actions_addopen(&fileActions, 1, "/dev/null", O_WRONLY, 0)
        posix_spawn_file_actions_addopen(&fileActions, 2, "/dev/null", O_WRONLY, 0)

        // Explicit types: older Swift compilers otherwise resolve the
        // literal as C string pointers and reject the String elements.
        let argumentStrings: [String] = ["/bin/bash", "-c", command]
        let arguments: [UnsafeMutablePointer<CChar>?] = argumentStrings.map { strdup($0) }
        defer { arguments.forEach { free($0) } }
        let argv: [UnsafeMutablePointer<CChar>?] = arguments + [nil]
        let spawnError = posix_spawn(&pid, "/bin/bash", &fileActions, &attributes, argv, environ)
        guard spawnError == 0 else {
            return .failedToLaunch(String(cString: strerror(spawnError)))
        }
        return await HookSupervisor(shell: pid, timeout: timeout, killGrace: killGrace).result()
    }

    /// Waits for a spawned hook shell and enforces its timeout. Every
    /// state change runs on one serial queue, and the shell is reaped only
    /// once no signal is pending for its group: until then the exited
    /// shell stays a zombie that keeps its pid and group id reserved, so a
    /// late SIGKILL can never reach a recycled group.
    private final class HookSupervisor: @unchecked Sendable {
        private let shell: pid_t
        private let timeout: TimeInterval
        private let killGrace: TimeInterval
        private let queue = DispatchQueue(label: "za.co.digitalfreedom.AutoBrew.hook")
        private var exitSource: DispatchSourceProcess?
        private var continuation: CheckedContinuation<HookResult, Never>?
        private var shellExited = false
        private var escalating = false
        private var reaped = false

        init(shell: pid_t, timeout: TimeInterval, killGrace: TimeInterval) {
            self.shell = shell
            self.timeout = timeout
            self.killGrace = killGrace
        }

        func result() async -> HookResult {
            await withCheckedContinuation { continuation in
                queue.async {
                    self.continuation = continuation
                    let source = DispatchSource.makeProcessSource(identifier: self.shell, eventMask: .exit, queue: self.queue)
                    source.setEventHandler { [self] in shellDidExit() }
                    self.exitSource = source
                    source.resume()
                    // An exit before the source was armed raises no event.
                    if Self.hasExited(self.shell) { self.shellDidExit() }
                    self.queue.asyncAfter(deadline: .now() + self.timeout) { [self] in timeoutFired() }
                }
            }
        }

        private func shellDidExit() {
            guard !shellExited else { return }
            shellExited = true
            exitSource?.cancel()
            if !escalating { reap() }
        }

        private func timeoutFired() {
            guard !shellExited, let continuation else { return }
            self.continuation = nil
            escalating = true
            killpg(shell, SIGTERM)
            continuation.resume(returning: .timedOut)
            queue.asyncAfter(deadline: .now() + killGrace) { [self] in
                killpg(shell, SIGKILL)
                escalating = false
                if shellExited { reap() }
            }
        }

        private func reap() {
            guard !reaped else { return }
            reaped = true
            var status: Int32 = 0
            var waited: pid_t
            repeat {
                waited = waitpid(shell, &status, 0)
            } while waited == -1 && errno == EINTR
            guard let continuation else { return }
            self.continuation = nil
            guard waited == shell else {
                continuation.resume(returning: .failedToLaunch("waitpid failed: \(String(cString: strerror(errno)))"))
                return
            }
            // Low 7 bits are the terminating signal (0 = normal exit).
            let signal = status & 0x7f
            continuation.resume(returning: .exited(signal == 0 ? (status >> 8) & 0xff : 128 + signal))
        }

        /// True if `pid` is already a zombie, checked without reaping it.
        private static func hasExited(_ pid: pid_t) -> Bool {
            var info = siginfo_t()
            return waitid(P_PID, id_t(pid), &info, WEXITED | WNOHANG | WNOWAIT) == 0 && info.si_pid == pid
        }
    }

    /// Writes one row to `UpgradeHistoryStore`. The outcome is the
    /// per-cask result from the parser (`succeeded` / `failed` /
    /// `attempted`), not an aggregate flag. The snapshot ID may be nil
    /// when capture was disabled, skipped, or failed — the row is still
    /// useful as an audit entry, it just won't show a Roll Back button.
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
