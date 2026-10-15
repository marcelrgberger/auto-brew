import Foundation
import os

/// Orchestrates the full `brew update → upgrade → upgrade --cask → cleanup`
/// cycle and serialises it via `isRunning`. Running two in parallel would hit
/// Homebrew's global lock and fail both.
@Observable
@MainActor
final class BrewManager {
    static let shared = BrewManager()

    private(set) var isRunning = false
    private(set) var currentStage: BrewStage?
    private(set) var lastError: String?
    private(set) var lastOutput: String = ""
    private(set) var outdatedPackages: [OutdatedPackage] = []

    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "BrewManager")

    /// Directory containing `brew`. Apple Silicon uses a different prefix than
    /// Intel, so check both before falling back to `which`.
    var brewPath: String? {
        // Check standard locations first
        let arm = "/opt/homebrew/bin"
        let intel = "/usr/local/bin"
        if FileManager.default.fileExists(atPath: "\(arm)/brew") { return arm }
        if FileManager.default.fileExists(atPath: "\(intel)/brew") { return intel }
        // Try resolving from PATH via which
        if let resolved = (try? shellWhich("brew")).flatMap({ $0 }) {
            return (resolved as NSString).deletingLastPathComponent
        }
        return nil
    }

    var brewExecutable: String? {
        guard let path = brewPath else { return nil }
        return "\(path)/brew"
    }

    var isHomebrewInstalled: Bool { brewPath != nil }

    /// Runs the official Homebrew installer non-interactively via bash.
    func installHomebrew() async throws {
        guard !isRunning else { return }
        isRunning = true
        currentStage = .installing
        lastError = nil
        defer { isRunning = false }

        logger.info("Installing Homebrew via official script...")

        // Run the official installer non-interactively
        let result = try await BrewProcess.run(
            executable: "/bin/bash",
            arguments: ["-c", "NONINTERACTIVE=1 /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""],
            brewPath: "/usr/local/bin"
        )

        if !result.succeeded {
            let msg = result.stderr.isEmpty ? "Unknown error" : result.stderr
            logger.error("Homebrew installation failed: \(msg)")
            lastError = msg
            throw BrewError.installFailed(msg)
        }

        logger.info("Homebrew installed successfully")
        currentStage = .done
    }

    /// Convenience wrapper that runs the whole cycle without any policy
    /// gating — used by callers that aren't aware of the selective-update
    /// machinery (e.g. test helpers). The scheduler calls the more granular
    /// `runUpdate`, `runUpgrade(formulae:casks:)`, `runCleanup` directly so
    /// it can fit the evaluator in between.
    func runFullUpdate() async throws {
        try await runUpdate()
        try await runUpgrade(formulae: nil, casks: nil)
        try await runCleanup()
    }

    /// Runs `brew update` (refresh the package index). Always safe to run —
    /// doesn't change anything that's installed.
    func runUpdate() async throws {
        guard !isRunning else { return }
        guard let brew = brewExecutable, let path = brewPath else {
            throw BrewError.notFound
        }

        isRunning = true
        lastError = nil
        lastOutput = ""
        defer {
            isRunning = false
            if lastError == nil { currentStage = .done }
        }

        logger.info("brew update")
        currentStage = .updating
        let result = try await BrewProcess.run(executable: brew, arguments: ["update"], brewPath: path)
        if !result.succeeded {
            lastError = result.stderr
            throw BrewError.updateFailed(result.stderr)
        }
        lastOutput += result.stdout
    }

    /// Runs `brew upgrade` for formulae and casks separately. Pass `nil` for a
    /// pass-through "upgrade everything in this category" (matches the old
    /// `brew upgrade` and `brew upgrade --cask --greedy` behaviour). Pass an
    /// empty array to skip the category entirely. Pass a token list to upgrade
    /// only those packages.
    ///
    /// Returns per-cask outcomes attributed by `BrewUpgradeOutcomeParser`
    /// against the cask portion of stdout — necessary because brew reports
    /// only an aggregate exit status and the History view needs to know
    /// which individual cask actually upgraded. Tokens that were requested
    /// but never mentioned in the output (greedy mode, or brew skipping a
    /// no-op) come back as `.attempted`. Empty/nil cask selection returns
    /// an empty map.
    @discardableResult
    func runUpgrade(formulae: [String]?, casks: [String]?) async throws -> [String: CaskUpgradeOutcome] {
        // Throw rather than return an empty map: callers record history
        // and drop approvals from the result, which must not happen for a
        // run that never started.
        guard !isRunning else { throw BrewError.busy }
        guard let brew = brewExecutable, let path = brewPath else {
            throw BrewError.notFound
        }

        isRunning = true
        lastError = nil
        defer {
            isRunning = false
            if lastError == nil { currentStage = .done }
        }

        if shouldRun(selection: formulae) {
            currentStage = .upgrading
            var args = ["upgrade"]
            if let formulae { args.append(contentsOf: formulae) }
            logger.info("brew \(args.joined(separator: " "))")
            let result = try await BrewProcess.run(executable: brew, arguments: args, brewPath: path)
            lastOutput += result.stdout
            if !result.succeeded {
                lastError = result.stderr
                throw BrewError.upgradeFailed(result.stderr)
            }
        }

        var caskOutcomes: [String: CaskUpgradeOutcome] = [:]
        if shouldRun(selection: casks) {
            currentStage = .upgradingCasks
            var args = ["upgrade", "--cask"]
            if let casks {
                args.append(contentsOf: casks)
            } else {
                args.append("--greedy")
            }
            logger.info("brew \(args.joined(separator: " "))")
            let result = try await BrewProcess.run(executable: brew, arguments: args, brewPath: path)
            lastOutput += result.stdout

            // Only the explicit-token call gives the parser a target set;
            // `--greedy` makes per-cask attribution meaningless, so we
            // leave the outcomes map empty in that case and the scheduler
            // falls back to its aggregate-status logic.
            if let casks, !casks.isEmpty {
                let combined = result.stdout + (result.succeeded ? "" : "\n" + result.stderr)
                caskOutcomes = BrewUpgradeOutcomeParser.parse(stdout: combined, tokens: casks)
            }

            if !result.succeeded {
                // One broken cask shouldn't take down the rest of the cycle.
                logger.warning("Cask upgrade had issues: \(result.stderr)")
                lastOutput += "\n[Cask warning] \(result.stderr)"
            }
        }
        return caskOutcomes
    }

    private(set) var orphanedPackages: [OrphanedPackage] = []
    private(set) var doctorReport: DoctorReport?

    /// Runs `brew doctor`, parses the output through
    /// `DoctorReport.parse`, and exposes the result on
    /// `doctorReport`. `brew doctor` exits non-zero when it found
    /// warnings — that is its normal mode, not a failure of our
    /// invocation — so we parse regardless of exit status. Genuine
    /// failures (brew missing, process couldn't launch) surface as
    /// nil so the UI can render an honest "couldn't ask brew".
    func runDoctor() async {
        guard !isRunning,
              let brew = brewExecutable,
              let path = brewPath else { return }
        guard let result = try? await BrewProcess.run(
            executable: brew,
            arguments: ["doctor"],
            brewPath: path
        ) else {
            doctorReport = nil
            return
        }
        // brew writes warnings to stderr in newer versions; combine
        // both streams so the parser sees the full text either way.
        let combined = [result.stdout, result.stderr]
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
        doctorReport = DoctorReport.parse(combined)
    }

    /// Asks brew which formulae would be removed by `brew autoremove`
    /// without actually removing anything. Used by the BrewStore
    /// Orphans surface so the user sees what's reclaimable before
    /// committing. Failures are swallowed — empty list means
    /// "couldn't tell" rather than "definitely nothing", which
    /// matches the rest of the BrewManager's defensive style.
    func fetchOrphans() async {
        guard !isRunning,
              let brew = brewExecutable,
              let path = brewPath else { return }
        let result = try? await BrewProcess.run(
            executable: brew,
            arguments: ["autoremove", "--dry-run"],
            brewPath: path
        )
        guard let result, result.succeeded else {
            orphanedPackages = []
            return
        }
        // brew autoremove --dry-run prints lines like
        //   ==> Would remove (3 formulae):
        //   foo
        //   bar
        //   baz
        // We keep only lines that match the cask-token grammar so
        // headers and progress chatter never sneak in.
        let tokenPattern = #"^[a-zA-Z0-9][a-zA-Z0-9._@+-]*$"#
        let names = result.stdout
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty && $0.range(of: tokenPattern, options: .regularExpression) != nil }
        orphanedPackages = names.map(OrphanedPackage.init(name:))
    }

    /// Runs `brew autoremove` for real. Returns the list that was
    /// expected to go away — callers can compare with the post-state
    /// to surface anything that survived (e.g. user re-installed a
    /// parent between dry-run and apply).
    @discardableResult
    func runAutoremove() async throws -> [OrphanedPackage] {
        guard !isRunning else { return [] }
        guard let brew = brewExecutable, let path = brewPath else {
            throw BrewError.notFound
        }
        isRunning = true
        defer {
            isRunning = false
            if lastError == nil { currentStage = .done }
        }
        let expected = orphanedPackages
        currentStage = .cleanup
        logger.info("brew autoremove")
        let result = try await BrewProcess.run(executable: brew, arguments: ["autoremove"], brewPath: path)
        lastOutput += result.stdout
        if !result.succeeded {
            lastError = result.stderr
            throw BrewError.cleanupFailed(result.stderr)
        }
        orphanedPackages = []
        return expected
    }

    /// Runs `brew cleanup --prune=7` to free disk space.
    func runCleanup() async throws {
        guard !isRunning else { return }
        guard let brew = brewExecutable, let path = brewPath else {
            throw BrewError.notFound
        }

        isRunning = true
        defer {
            isRunning = false
            if lastError == nil { currentStage = .done }
        }

        currentStage = .cleanup
        logger.info("brew cleanup --prune=7")
        let result = try await BrewProcess.run(executable: brew, arguments: ["cleanup", "--prune=7"], brewPath: path)
        if !result.succeeded {
            lastError = result.stderr
            throw BrewError.cleanupFailed(result.stderr)
        }
        lastOutput += result.stdout
    }

    /// Empty selection (`[]`) means "skip this category"; `nil` and any
    /// non-empty list both mean "run upgrade".
    private func shouldRun(selection: [String]?) -> Bool {
        guard let selection else { return true }
        return !selection.isEmpty
    }

    /// Reads `brew outdated --json=v2`. Fails silently — it only feeds the UI,
    /// so if brew is busy or the output isn't parseable, the old list stays.
    func fetchOutdated() async {
        guard !isRunning else { return }
        guard let brew = brewExecutable, let path = brewPath else { return }

        let result = try? await BrewProcess.run(executable: brew, arguments: ["outdated", "--json=v2"], brewPath: path)
        guard let result, result.succeeded else { return }
        guard let data = result.stdout.data(using: .utf8) else { return }

        struct BrewOutdated: Decodable {
            struct Formula: Decodable {
                let name: String
                let installed_versions: [String]
                let current_version: String
            }
            struct Cask: Decodable {
                let name: String
                let installed_versions: String
                let current_version: String
            }
            let formulae: [Formula]
            let casks: [Cask]
        }

        guard let outdated = try? JSONDecoder().decode(BrewOutdated.self, from: data) else { return }

        var packages: [OutdatedPackage] = []
        for f in outdated.formulae {
            packages.append(OutdatedPackage(
                name: f.name,
                currentVersion: f.installed_versions.first ?? "?",
                newVersion: f.current_version,
                isCask: false
            ))
        }
        for c in outdated.casks {
            packages.append(OutdatedPackage(
                name: c.name,
                currentVersion: c.installed_versions,
                newVersion: c.current_version,
                isCask: true
            ))
        }
        outdatedPackages = packages
    }

    private func shellWhich(_ command: String) throws -> String? {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = [command]
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice
        try process.run()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else { return nil }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private init() {}
}
