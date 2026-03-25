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

        currentStage = .updating
        let updateResult = try await BrewProcess.run("\(brew) update", brewPath: path)
        if !updateResult.succeeded {
            lastError = updateResult.stderr
            throw BrewError.updateFailed(updateResult.stderr)
        }
        lastOutput += updateResult.stdout

        currentStage = .upgrading
        let upgradeResult = try await BrewProcess.run("\(brew) upgrade", brewPath: path)
        if !upgradeResult.succeeded {
            lastError = upgradeResult.stderr
            throw BrewError.upgradeFailed(upgradeResult.stderr)
        }
        lastOutput += upgradeResult.stdout

        currentStage = .cleanup
        let cleanupResult = try await BrewProcess.run("\(brew) cleanup --prune=7", brewPath: path)
        if !cleanupResult.succeeded {
            lastError = cleanupResult.stderr
            throw BrewError.cleanupFailed(cleanupResult.stderr)
        }
        lastOutput += cleanupResult.stdout

        logger.info("Full brew update cycle completed successfully")
    }

    private init() {}
}
