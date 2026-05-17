import SwiftUI

enum BrewStoreSection: Hashable {
    case discover
    case category(BrowseCategory)
    case installed
    case snapshots
    case updates
}

struct BrewStoreWindow: View {
    @State private var selection: BrewStoreSection = .discover
    @State private var catalog = CatalogStore.shared
    @State private var service = BrewCatalogService.shared
    @State private var searchText: String = ""
    @State private var detailEntry: CaskCatalogEntry?

    var body: some View {
        NavigationSplitView {
            BrewStoreSidebar(selection: $selection, searchText: $searchText)
                .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)
        } detail: {
            detailView
                .navigationTitle(titleForSelection)
                .toolbarTitleDisplayMode(.inline)
        }
        .frame(minWidth: 980, minHeight: 640)
        .task {
            await loadCatalog()
            await InstalledAppsStore.shared.refresh()
        }
        .sheet(item: $detailEntry) { entry in
            NavigationStack {
                BrowseDetailView(entry: entry)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(String(localized: "Close")) { detailEntry = nil }
                        }
                    }
                    .frame(minWidth: 520, minHeight: 420)
            }
        }
    }

    @ViewBuilder
    private var detailView: some View {
        switch selection {
        case .discover:
            DiscoverView(store: catalog, onSelect: { detailEntry = $0 })
        case .category(let cat):
            CategoryListView(category: cat, store: catalog, searchText: $searchText)
        case .installed:
            InstalledAppsView()
        case .snapshots:
            SnapshotsRootView()
        case .updates:
            UpdatesView()
        }
    }

    private var titleForSelection: String {
        switch selection {
        case .discover: String(localized: "Discover")
        case .category(let cat): cat.displayName
        case .installed: String(localized: "Installed")
        case .snapshots: String(localized: "Snapshots")
        case .updates: String(localized: "Updates")
        }
    }

    private func loadCatalog() async {
        try? await service.loadCache()
        catalog.replaceAll(service.casks, analytics: service.analytics)
        let stale = service.lastRefresh.map { Date().timeIntervalSince($0) > 86_400 } ?? true
        if stale {
            try? await service.refresh()
            catalog.replaceAll(service.casks, analytics: service.analytics)
        }
    }
}
