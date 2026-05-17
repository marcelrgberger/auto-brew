import SwiftUI

struct DiscoverView: View {
    @Bindable var store: CatalogStore
    let onSelect: (CaskCatalogEntry) -> Void

    @State private var service = BrewCatalogService.shared

    private let categoriesToShow: [BrowseCategory] = [
        .developerTools, .productivity, .browsers, .communication, .media
    ]

    var body: some View {
        Group {
            if store.allCasks.isEmpty {
                if let err = service.lastError {
                    ContentUnavailableView(
                        String(localized: "Couldn't load catalog"),
                        systemImage: "wifi.exclamationmark",
                        description: Text(err)
                    )
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        DiscoverSection(
                            title: String(localized: "Top Installed"),
                            entries: store.topInstalledOverall,
                            onSelect: onSelect
                        )

                        ForEach(categoriesToShow) { cat in
                            DiscoverSection(
                                title: cat.displayName,
                                entries: store.topByCategory[cat] ?? [],
                                onSelect: onSelect
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }
            }
        }
    }
}
