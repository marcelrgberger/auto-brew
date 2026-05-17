import Foundation

enum BrowseCategory: String, CaseIterable, Identifiable, Sendable {
    case all, popular, recent
    case browsers
    case developerTools
    case communication
    case productivity
    case media
    case graphics
    case utilities
    case security
    case games
    case storage

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .all: String(localized: "All Casks")
        case .popular: String(localized: "Top Installed")
        case .recent: String(localized: "Recently Added")
        case .browsers: String(localized: "Browsers")
        case .developerTools: String(localized: "Developer Tools")
        case .communication: String(localized: "Communication")
        case .productivity: String(localized: "Productivity")
        case .media: String(localized: "Media")
        case .graphics: String(localized: "Graphics & Design")
        case .utilities: String(localized: "Utilities")
        case .security: String(localized: "Security")
        case .games: String(localized: "Games")
        case .storage: String(localized: "Cloud Storage")
        }
    }

    var systemImage: String {
        switch self {
        case .all: "list.bullet"
        case .popular: "chart.bar"
        case .recent: "clock"
        case .browsers: "safari"
        case .developerTools: "hammer"
        case .communication: "message"
        case .productivity: "checklist"
        case .media: "play.rectangle"
        case .graphics: "paintpalette"
        case .utilities: "wrench.and.screwdriver"
        case .security: "lock.shield"
        case .games: "gamecontroller"
        case .storage: "icloud"
        }
    }

    /// Returns true if the given cask entry belongs to this category.
    /// `.all`/`.popular`/`.recent` return true unconditionally (they're not content filters).
    func matches(_ entry: CaskCatalogEntry) -> Bool {
        switch self {
        case .all, .popular, .recent:
            return true
        default:
            return Self.categoryFor(entry).contains(self)
        }
    }

    /// Returns the content-based categories this entry belongs to (no .all/.popular/.recent).
    static func categoryFor(_ entry: CaskCatalogEntry) -> Set<BrowseCategory> {
        let haystack = "\(entry.token) \(entry.displayName) \(entry.description ?? "")".lowercased()
        var result: Set<BrowseCategory> = []

        // Token keyword matches (high precision)
        let browserTokens: Set<String> = ["firefox", "google-chrome", "brave-browser", "arc", "vivaldi", "opera", "tor-browser", "microsoft-edge", "chromium", "min", "orion"]
        let devTokens: Set<String> = ["visual-studio-code", "iterm2", "xcode", "jetbrains-toolbox", "intellij-idea", "pycharm", "webstorm", "android-studio", "docker", "github", "postman", "insomnia", "sourcetree", "tower", "fork", "sublime-text", "atom", "rubymine", "phpstorm", "goland", "clion", "datagrip"]
        let commTokens: Set<String> = ["slack", "discord", "zoom", "microsoft-teams", "telegram", "signal", "whatsapp", "skype", "thunderbird", "spark"]
        let productivityTokens: Set<String> = ["notion", "obsidian", "things", "fantastical", "raycast", "alfred", "todoist", "evernote", "bear", "linear-linear", "trello", "asana", "monday"]
        let mediaTokens: Set<String> = ["vlc", "spotify", "plex", "iina", "audacity", "infuse", "kodi", "music", "elmedia-player", "movist-pro", "tidal", "deezer"]
        let graphicsTokens: Set<String> = ["figma", "sketch", "blender", "gimp", "krita", "inkscape", "adobe-creative-cloud", "affinity-designer", "affinity-photo", "affinity-publisher", "pixelmator-pro", "photopea"]
        let utilTokens: Set<String> = ["rectangle", "magnet", "bartender", "cleanmymac", "appcleaner", "the-unarchiver", "keka", "transmit", "cyberduck", "stats", "istat-menus", "hiddenbar"]
        let secTokens: Set<String> = ["1password", "bitwarden", "tunnelblick", "mullvad-vpn", "nordvpn", "expressvpn", "protonvpn", "keeper-password-manager", "dashlane", "lastpass"]
        let gameTokens: Set<String> = ["steam", "epic-games", "battle-net", "gog-galaxy", "minecraft", "openemu"]
        let storageTokens: Set<String> = ["dropbox", "google-drive", "onedrive", "megasync", "box-drive", "pcloud-drive", "tresorit"]

        if browserTokens.contains(entry.token) || haystack.contains("browser") || haystack.contains("web browser") { result.insert(.browsers) }
        if devTokens.contains(entry.token) || haystack.contains("ide ") || haystack.contains("git client") || haystack.contains("developer") { result.insert(.developerTools) }
        if commTokens.contains(entry.token) || haystack.contains("chat") || haystack.contains("messaging") || haystack.contains("email client") || haystack.contains("video calling") { result.insert(.communication) }
        if productivityTokens.contains(entry.token) || haystack.contains("note") || haystack.contains("task manager") || haystack.contains("calendar") || haystack.contains("launcher") { result.insert(.productivity) }
        if mediaTokens.contains(entry.token) || haystack.contains("video player") || haystack.contains("music player") || haystack.contains("media player") || haystack.contains("audio editor") { result.insert(.media) }
        if graphicsTokens.contains(entry.token) || haystack.contains("image editor") || haystack.contains("vector") || haystack.contains("3d") || haystack.contains("graphic design") { result.insert(.graphics) }
        if utilTokens.contains(entry.token) || haystack.contains("window manager") || haystack.contains("menu bar") || haystack.contains("archiver") || haystack.contains("disk cleaner") { result.insert(.utilities) }
        if secTokens.contains(entry.token) || haystack.contains("password manager") || haystack.contains("vpn") { result.insert(.security) }
        if gameTokens.contains(entry.token) || haystack.contains("game launcher") || haystack.contains("emulator") { result.insert(.games) }
        if storageTokens.contains(entry.token) || haystack.contains("cloud storage") || haystack.contains("file sync") { result.insert(.storage) }

        return result
    }
}
