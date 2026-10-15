import Foundation

/// Errors surfaced from the brew pipeline. Each case maps to a distinct user
/// message and, in some flows, to a different recovery action (`.notFound`
/// triggers the install prompt; the others render the underlying stderr).
enum BrewError: LocalizedError, Sendable {
    case notFound
    case installFailed(String)
    case updateFailed(String)
    case upgradeFailed(String)
    case cleanupFailed(String)
    /// Another brew operation is already running; nothing was executed.
    case busy

    var errorDescription: String? {
        switch self {
        case .notFound: String(localized: "Homebrew not found")
        case .installFailed(let msg): String(localized: "Installation failed: \(msg)")
        case .updateFailed(let msg): String(localized: "Update failed: \(msg)")
        case .upgradeFailed(let msg): String(localized: "Upgrade failed: \(msg)")
        case .cleanupFailed(let msg): String(localized: "Cleanup failed: \(msg)")
        case .busy: String(localized: "Homebrew is busy with another operation")
        }
    }
}
