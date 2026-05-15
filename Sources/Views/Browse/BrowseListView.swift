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
        case .all: store.filtered
        case .popular:
            Array(store.filtered.sorted {
                (store.analytics?.installCount(for: $0.token) ?? 0) >
                (store.analytics?.installCount(for: $1.token) ?? 0)
            }.prefix(100))
        case .recent: store.filtered
        }
    }

    private func formatCount(_ n: Int) -> String {
        if n > 1_000_000 { return "\(n / 1_000_000)M" }
        if n > 1_000 { return "\(n / 1_000)k" }
        return "\(n)"
    }
}
