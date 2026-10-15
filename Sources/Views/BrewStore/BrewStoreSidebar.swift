import SwiftUI

/// Left rail of BrewStore. Fixed-order top section (Discover/Installed/Snapshots/
/// Updates) above the category list. The category order here is intentionally
/// hand-curated, not alphabetical — most-used surfaces sit higher.
struct BrewStoreSidebar: View {
    @Binding var selection: BrewStoreSection
    @Binding var searchText: String

    @State private var pendingStore = PendingUpdatesStore.shared

    /// Order matches the precomputed rankings in `CatalogStore.rankedCategories`
    /// so the sidebar and Discover sections stay in sync.
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
            .adaptiveGlassCard(cornerRadius: 8)
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 12)

            List(selection: Binding(
                get: { Optional(selection) },
                set: { if let new = $0 { selection = new } }
            )) {
                Section {
                    sidebarRow(BrewStoreSection.discover, label: String(localized: "Discover"), systemImage: "star.fill")
                    sidebarRow(BrewStoreSection.installed, label: String(localized: "Installed"), systemImage: "shippingbox.fill")
                    sidebarRow(BrewStoreSection.snapshots, label: String(localized: "Snapshots"), systemImage: "camera.on.rectangle.fill")
                    sidebarRow(BrewStoreSection.updates, label: String(localized: "Updates"), systemImage: "arrow.triangle.2.circlepath")
                    sidebarRow(BrewStoreSection.history, label: String(localized: "History"), systemImage: "clock.arrow.circlepath")
                    sidebarRow(BrewStoreSection.collections, label: String(localized: "Collections"), systemImage: "rectangle.stack")
                    sidebarRow(BrewStoreSection.orphans, label: String(localized: "Orphans"), systemImage: "leaf")
                    sidebarRow(BrewStoreSection.doctor, label: String(localized: "Doctor"), systemImage: "stethoscope")
                    // Approvals row only shows when something is actually
                    // pending — keeps the sidebar uncluttered for users who
                    // don't have major updates pending.
                    if pendingStore.pendingCount > 0 {
                        approvalsRow
                    }
                }
                Section(String(localized: "Categories")) {
                    ForEach(contentCategories) { cat in
                        sidebarRow(BrewStoreSection.category(cat), label: cat.displayName, systemImage: cat.systemImage)
                    }
                }

                // External resources — kept in their own section so they're
                // always visible below the categories and never selectable
                // like a BrewStoreSection.
                Section {
                    externalLinkRow(
                        title: String(localized: "Help & Support"),
                        systemImage: "questionmark.circle",
                        url: "https://support.apps.digitalfreedom.co.za"
                    )
                    externalLinkRow(
                        title: String(localized: "Sponsor this Project"),
                        systemImage: "heart",
                        url: "https://github.com/sponsors/marcelrgberger"
                    )
                    externalLinkRow(
                        title: String(localized: "Source Code"),
                        systemImage: "chevron.left.forwardslash.chevron.right",
                        url: "https://github.com/marcelrgberger/auto-brew"
                    )
                }
            }
            .listStyle(.sidebar)
        }
    }

    /// Renders an external link the same way `SettingsView` does — `Link`
    /// rather than `Button` so the system reports it as a URL target to
    /// VoiceOver and respects the user's default browser.
    @ViewBuilder
    private func externalLinkRow(title: String, systemImage: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack {
                Label(title, systemImage: systemImage)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func sidebarRow(_ section: BrewStoreSection, label: String, systemImage: String) -> some View {
        Label(label, systemImage: systemImage)
            .padding(.vertical, 4)
            .tag(section)
    }

    private var approvalsRow: some View {
        HStack {
            Label(String(localized: "Pending Approvals"), systemImage: "exclamationmark.circle.fill")
                .foregroundStyle(.orange)
            Spacer()
            Text("\(pendingStore.pendingCount)")
                .font(.caption2.bold())
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(.orange, in: Capsule())
                .foregroundStyle(.white)
        }
        .padding(.vertical, 4)
        .tag(BrewStoreSection.pendingApprovals)
    }
}
