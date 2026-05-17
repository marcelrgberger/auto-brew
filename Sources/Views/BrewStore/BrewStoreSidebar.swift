import SwiftUI

struct BrewStoreSidebar: View {
    @Binding var selection: BrewStoreSection
    @Binding var searchText: String

    private let contentCategories: [BrowseCategory] = [
        .browsers, .developerTools, .communication, .productivity,
        .media, .graphics, .utilities, .security, .games, .storage
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField(String(localized: "Search"), text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(8)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 12)
            .padding(.top, 8)

            List(selection: Binding(
                get: { Optional(selection) },
                set: { if let new = $0 { selection = new } }
            )) {
                Section {
                    sidebarRow(BrewStoreSection.discover, label: String(localized: "Discover"), systemImage: "star.fill")
                    sidebarRow(BrewStoreSection.installed, label: String(localized: "Installed"), systemImage: "shippingbox.fill")
                    sidebarRow(BrewStoreSection.snapshots, label: String(localized: "Snapshots"), systemImage: "camera.on.rectangle.fill")
                    sidebarRow(BrewStoreSection.updates, label: String(localized: "Updates"), systemImage: "arrow.triangle.2.circlepath")
                }
                Section(String(localized: "Categories")) {
                    ForEach(contentCategories) { cat in
                        sidebarRow(BrewStoreSection.category(cat), label: cat.displayName, systemImage: cat.systemImage)
                    }
                }
            }
            .listStyle(.sidebar)
        }
    }

    @ViewBuilder
    private func sidebarRow(_ section: BrewStoreSection, label: String, systemImage: String) -> some View {
        Label(label, systemImage: systemImage)
            .padding(.vertical, 4)
            .tag(section)
    }
}
