import Foundation

enum BrewError: LocalizedError, Sendable {
    case notFound
    case installFailed(String)
    case updateFailed(String)
    case upgradeFailed(String)
    case cleanupFailed(String)

    var errorDescription: String? {
        switch self {
        case .notFound: "Homebrew nicht gefunden"
        case .installFailed(let msg): "Installation fehlgeschlagen: \(msg)"
        case .updateFailed(let msg): "Update fehlgeschlagen: \(msg)"
        case .upgradeFailed(let msg): "Upgrade fehlgeschlagen: \(msg)"
        case .cleanupFailed(let msg): "Cleanup fehlgeschlagen: \(msg)"
        }
    }
}
