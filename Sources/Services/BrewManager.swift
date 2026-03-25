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
        let arm = "/opt/homebrew/bin"
        let intel = "/usr/local/bin"
        if FileManager.default.fileExists(atPath: "\(arm)/brew") { return arm }
        if FileManager.default.fileExists(atPath: "\(intel)/brew") { return intel }
        return nil
    }

    var brewExecutable: String? {
        guard let path = brewPath else { return nil }
        return "\(path)/brew"
    }

    var isHomebrewInstalled: Bool { brewPath != nil }

    func installHomebrew() async throws {
        guard !isRunning else { return }
        isRunning = true
        currentStage = .installing
        lastError = nil
        defer { isRunning = false }

        logger.info("Installing Homebrew...")

        let script = "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        let result = try await BrewProcess.run(script, brewPath: "/usr/local/bin")

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

        // Update formulae list
        currentStage = .updating
        let updateResult = try await BrewProcess.run("\(brew) update", brewPath: path)
        if !updateResult.succeeded {
            lastError = updateResult.stderr
            throw BrewError.updateFailed(updateResult.stderr)
        }
        lastOutput += updateResult.stdout

        // Upgrade formulae
        currentStage = .upgrading
        let upgradeResult = try await BrewProcess.run("\(brew) upgrade", brewPath: path)
        if !upgradeResult.succeeded {
            lastError = upgradeResult.stderr
            throw BrewError.upgradeFailed(upgradeResult.stderr)
        }
        lastOutput += upgradeResult.stdout

        // Upgrade casks
        currentStage = .upgradingCasks
        let caskResult = try await BrewProcess.run("\(brew) upgrade --cask --greedy", brewPath: path)
        // Cask upgrade failures are non-fatal (some casks auto-update)
        lastOutput += caskResult.stdout
        if !caskResult.succeeded {
            logger.warning("Cask upgrade had issues: \(caskResult.stderr)")
            lastOutput += "\n[Cask-Warnung] \(caskResult.stderr)"
        }

        // Cleanup
        currentStage = .cleanup
        let cleanupResult = try await BrewProcess.run("\(brew) cleanup --prune=7", brewPath: path)
        if !cleanupResult.succeeded {
            lastError = cleanupResult.stderr
            throw BrewError.cleanupFailed(cleanupResult.stderr)
        }
        lastOutput += cleanupResult.stdout

        logger.info("Full brew update cycle completed successfully")
    }

    func fetchOutdated() async {
        guard let brew = brewExecutable, let path = brewPath else { return }

        let result = try? await BrewProcess.run("\(brew) outdated --json=v2", brewPath: path)
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

    private init() {}
}
