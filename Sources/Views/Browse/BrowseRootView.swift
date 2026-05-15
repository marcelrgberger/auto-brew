import SwiftUI

struct BrowseRootView: View {
    @State private var selectedCategory: BrowseCategory = .popular
    @State private var selectedCask: CaskCatalogEntry?
    @State private var catalog = CatalogStore.shared
    @State private var service = BrewCatalogService.shared

    var body: some View {
        NavigationSplitView {
            BrowseSidebarView(selection: $selectedCategory)
                .frame(minWidth: 180)
        } content: {
            BrowseListView(category: selectedCategory, selection: $selectedCask, store: catalog)
                .frame(minWidth: 320)
        } detail: {
            if let cask = selectedCask {
                BrowseDetailView(entry: cask)
            } else {
                ContentUnavailableView(
                    String(localized: "Select a cask"),
                    systemImage: "shippingbox",
                    description: Text(String(localized: "Pick an item from the list to see details."))
                )
            }
        }
        .task { await loadCatalog() }
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
