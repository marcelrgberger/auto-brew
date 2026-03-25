import Foundation

enum BrewStage: String, Sendable {
    case detecting = "Homebrew suchen..."
    case installing = "Homebrew installieren..."
    case updating = "brew update..."
    case upgrading = "brew upgrade..."
    case cleanup = "brew cleanup..."
    case done = "Fertig"
}
