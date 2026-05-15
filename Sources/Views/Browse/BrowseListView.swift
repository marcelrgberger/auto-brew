import SwiftUI

struct BrowseListView: View {
    let category: BrowseCategory
    @Binding var selection: CaskCatalogEntry?
    @Bindable var store: CatalogStore

    var body: some View {
        VStack(spacing: 0) {
            TextField(String(localized: "Search casks…"), text: $store.searchQuery)
                .textFieldStyle(.roundedBorder)
                .padding(8)

            if category == .recent {
                Label(String(localized: "Sorted by catalog order (no \"added\" date in Homebrew API yet)."),
                      systemImage: "info.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
            }

            List(selection: $selection) {
                ForEach(filteredForCategory) { entry in
                    HStack(spacing: 10) {
                        CaskIconView(token: entry.token, size: 32)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.displayName).font(.system(.body, weight: .medium))
                            if let desc = entry.description {
                                Text(desc).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                            }
                        }
                        Spacer()
                        if let count = store.analytics?.installCount(for: entry.token), count > 0 {
                            Text(formatCount(count)).font(.caption2).foregroundStyle(.tertiary)
                        }
                    }
                    .tag(entry)
                }
            }
        }
    }

    private var filteredForCategory: [CaskCatalogEntry] {
        switch category {
        case .all:
            return store.filtered
        case .popular:
            let q = store.searchQuery.trimmingCharacters(in: .whitespaces).lowercased()
            let base = q.isEmpty
                ? store.allCasks
                : store.allCasks.filter { entry in
                    entry.token.lowercased().contains(q) ||
                    entry.displayName.lowercased().contains(q) ||
                    (entry.description?.lowercased().contains(q) ?? false)
                }
            return Array(base.sorted {
                (store.analytics?.installCount(for: $0.token) ?? 0) >
                (store.analytics?.installCount(for: $1.token) ?? 0)
            }.prefix(Self.maxPopularCount))
        case .recent:
            return store.filtered
        }
    }

    private func formatCount(_ n: Int) -> String {
        if n > Self.millionThreshold { return "\(n / Self.millionThreshold)M" }
        if n > Self.thousandThreshold { return "\(n / Self.thousandThreshold)k" }
        return "\(n)"
    }

    private static let maxPopularCount = 100
    private static let millionThreshold = 1_000_000
    private static let thousandThreshold = 1_000
}
