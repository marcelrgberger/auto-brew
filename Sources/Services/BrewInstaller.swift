import Foundation
import os

@MainActor
struct BrewInstaller {
    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "BrewInstaller")

    enum InstallError: LocalizedError {
        case brewMissing
        case commandFailed(token: String, stderr: String)
        case noMatchFound(query: String)

        var errorDescription: String? {
            switch self {
            case .brewMissing: String(localized: "Homebrew not found")
            case .commandFailed(let token, let stderr): String(localized: "\(token): \(stderr)")
            case .noMatchFound(let q): String(localized: "No cask matches \"\(q)\"")
            }
        }
    }

    func install(token: String) async throws {
        let manager = BrewManager.shared
        guard let brew = manager.brewExecutable, let path = manager.brewPath else {
            throw InstallError.brewMissing
        }

        logger.info("Installing cask: \(token, privacy: .public)")
        let result = try await BrewProcess.run(executable: brew, arguments: ["install", "--cask", token], brewPath: path)
        if result.succeeded { return }

        logger.warning("First attempt failed for \(token, privacy: .public), retrying with --force")
        let retry = try await BrewProcess.run(executable: brew, arguments: ["install", "--cask", "--force", token], brewPath: path)
        if !retry.succeeded {
            throw InstallError.commandFailed(token: token, stderr: retry.stderr)
        }
    }

    func searchCask(query: String) async throws -> String? {
        let manager = BrewManager.shared
        guard let brew = manager.brewExecutable, let path = manager.brewPath else {
            throw InstallError.brewMissing
        }
        let result = try await BrewProcess.run(executable: brew, arguments: ["search", "--cask", query], brewPath: path)
        guard result.succeeded else { return nil }
        let lines = result.stdout.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        let candidates = lines.filter { !$0.isEmpty && !$0.contains("==>") }
        return candidates.first
    }

    func uninstall(token: String, zap: Bool = false) async throws {
        let manager = BrewManager.shared
        guard let brew = manager.brewExecutable, let path = manager.brewPath else { throw InstallError.brewMissing }
        var args = ["uninstall", "--cask"]
        if zap { args.append("--zap") }
        args.append(token)
        let result = try await BrewProcess.run(executable: brew, arguments: args, brewPath: path)
        if !result.succeeded { throw InstallError.commandFailed(token: token, stderr: result.stderr) }
    }

    func upgrade(token: String) async throws {
        let manager = BrewManager.shared
        guard let brew = manager.brewExecutable, let path = manager.brewPath else { throw InstallError.brewMissing }
        let result = try await BrewProcess.run(executable: brew, arguments: ["upgrade", "--cask", token], brewPath: path)
        if !result.succeeded { throw InstallError.commandFailed(token: token, stderr: result.stderr) }
    }
}
