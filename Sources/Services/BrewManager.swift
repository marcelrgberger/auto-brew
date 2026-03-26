import Foundation
import os

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

    func runFullUpdate() async throws {
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

        logger.info("Starting full brew update cycle")

        currentStage = .updating
        let updateResult = try await BrewProcess.run(executable: brew, arguments: ["update"], brewPath: path)
        if !updateResult.succeeded {
            lastError = updateResult.stderr
            throw BrewError.updateFailed(updateResult.stderr)
        }
        lastOutput += updateResult.stdout

        currentStage = .upgrading
        let upgradeResult = try await BrewProcess.run(executable: brew, arguments: ["upgrade"], brewPath: path)
        if !upgradeResult.succeeded {
            lastError = upgradeResult.stderr
            throw BrewError.upgradeFailed(upgradeResult.stderr)
        }
        lastOutput += upgradeResult.stdout

        currentStage = .upgradingCasks
        let caskResult = try await BrewProcess.run(executable: brew, arguments: ["upgrade", "--cask", "--greedy"], brewPath: path)
        lastOutput += caskResult.stdout
        if !caskResult.succeeded {
            logger.warning("Cask upgrade had issues: \(caskResult.stderr)")
            lastOutput += "\n[Cask warning] \(caskResult.stderr)"
        }

        currentStage = .cleanup
        let cleanupResult = try await BrewProcess.run(executable: brew, arguments: ["cleanup", "--prune=7"], brewPath: path)
        if !cleanupResult.succeeded {
            lastError = cleanupResult.stderr
            throw BrewError.cleanupFailed(cleanupResult.stderr)
        }
        lastOutput += cleanupResult.stdout

        logger.info("Full brew update cycle completed successfully")
    }

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
