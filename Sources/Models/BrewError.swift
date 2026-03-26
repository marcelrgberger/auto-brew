import Foundation

enum BrewError: LocalizedError, Sendable {
    case notFound
    case installFailed(String)
    case updateFailed(String)
    case upgradeFailed(String)
    case cleanupFailed(String)

    var errorDescription: String? {
        switch self {
        case .notFound: String(localized: "Homebrew not found")
        case .installFailed(let msg): String(localized: "Installation failed: \(msg)")
        case .updateFailed(let msg): String(localized: "Update failed: \(msg)")
        case .upgradeFailed(let msg): String(localized: "Upgrade failed: \(msg)")
        case .cleanupFailed(let msg): String(localized: "Cleanup failed: \(msg)")
        }
    }
}
