import Foundation

@Observable
@MainActor
final class InstalledAppsStore {
    static let shared = InstalledAppsStore()

    private(set) var apps: [InstalledApp] = []
    private(set) var isLoading = false
    var searchQuery: String = ""

    var filtered: [InstalledApp] {
        let q = searchQuery.trimmingCharacters(in: .whitespaces).lowercased()
        if q.isEmpty { return apps }
        return apps.filter {
            $0.displayName.lowercased().contains(q) ||
            $0.bundleID.lowercased().contains(q) ||
            ($0.caskToken?.lowercased().contains(q) ?? false)
        }
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        if BrewCatalogService.shared.casks.isEmpty {
            try? await BrewCatalogService.shared.loadCache()
        }
        // First-launch fallback: if cache was empty too, try a network fetch
        // so Homebrew-managed apps get their cask token immediately.
        if BrewCatalogService.shared.casks.isEmpty {
            try? await BrewCatalogService.shared.refresh()
        }
        let resolver = CaskNameResolver(catalog: BrewCatalogService.shared.casks)
        apps = await AppDiscoveryService().scan(resolver: resolver)
    }
}
