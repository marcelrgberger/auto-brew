import Foundation

enum BrewStage: String, Sendable {
    case detecting = "Detecting Homebrew..."
    case installing = "Installing Homebrew..."
    case updating = "brew update..."
    case upgrading = "brew upgrade..."
    case upgradingCasks = "brew upgrade --cask..."
    case cleanup = "brew cleanup..."
    case done = "Done"
}
