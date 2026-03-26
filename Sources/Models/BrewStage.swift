import Foundation

enum BrewStage: Sendable {
    case detecting
    case installing
    case updating
    case upgrading
    case upgradingCasks
    case cleanup
    case done

    var displayName: String {
        switch self {
        case .detecting: String(localized: "Detecting Homebrew...")
        case .installing: String(localized: "Installing Homebrew...")
        case .updating: String(localized: "brew update...")
        case .upgrading: String(localized: "brew upgrade...")
        case .upgradingCasks: String(localized: "brew upgrade --cask...")
        case .cleanup: String(localized: "brew cleanup...")
        case .done: String(localized: "Done")
        }
    }
}
