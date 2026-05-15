import Foundation

@Observable
@MainActor
final class CatalogStore {
    static let shared = CatalogStore()

    var searchQuery: String = ""
    var sortMode: SortMode = .popularity
    private(set) var allCasks: [CaskCatalogEntry] = []
    private(set) var analytics: CaskAnalytics?

    enum SortMode: String, CaseIterable, Sendable {
        case popularity, name, recent
    }

    var filtered: [CaskCatalogEntry] {
        let q = searchQuery.trimmingCharacters(in: .whitespaces).lowercased()
        let base: [CaskCatalogEntry]
        if q.isEmpty {
            base = allCasks
        } else {
            base = allCasks.filter { entry in
                entry.token.lowercased().contains(q) ||
                entry.displayName.lowercased().contains(q) ||
                (entry.description?.lowercased().contains(q) ?? false)
            }
        }
        switch sortMode {
        case .popularity:
            return base.sorted {
                (analytics?.installCount(for: $0.token) ?? 0) >
                (analytics?.installCount(for: $1.token) ?? 0)
            }
        case .name:
            return base.sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
        case .recent:
            // No "added at" field in formulae.brew.sh catalog yet — falls back to catalog order.
            return base
        }
    }

    func replaceAll(_ casks: [CaskCatalogEntry], analytics: CaskAnalytics?) {
        allCasks = casks
        self.analytics = analytics
    }
}
