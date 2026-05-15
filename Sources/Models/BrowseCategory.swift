import Foundation

enum BrowseCategory: String, CaseIterable, Identifiable, Sendable {
    case all, popular, recent

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .all: String(localized: "All Casks")
        case .popular: String(localized: "Top Installed")
        case .recent: String(localized: "Recently Added")
        }
    }

    var systemImage: String {
        switch self {
        case .all: "list.bullet"
        case .popular: "chart.bar"
        case .recent: "clock"
        }
    }
}
