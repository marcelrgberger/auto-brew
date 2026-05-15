import SwiftUI

enum BrewStationTab: String, CaseIterable, Identifiable {
    case browse, installed, snapshots
    var id: String { rawValue }
    var label: String {
        switch self {
        case .browse: String(localized: "Browse")
        case .installed: String(localized: "Installed")
        case .snapshots: String(localized: "Snapshots")
        }
    }
    var systemImage: String {
        switch self {
        case .browse: "magnifyingglass"
        case .installed: "shippingbox"
        case .snapshots: "camera.on.rectangle"
        }
    }
}

struct BrewStationWindow: View {
    @State private var selectedTab: BrewStationTab = .browse

    var body: some View {
        TabView(selection: $selectedTab) {
            BrowseRootView()
                .tabItem { Label(BrewStationTab.browse.label, systemImage: BrewStationTab.browse.systemImage) }
                .tag(BrewStationTab.browse)

            InstalledAppsView()
                .tabItem { Label(BrewStationTab.installed.label, systemImage: BrewStationTab.installed.systemImage) }
                .tag(BrewStationTab.installed)

            SnapshotsRootView()
                .tabItem { Label(BrewStationTab.snapshots.label, systemImage: BrewStationTab.snapshots.systemImage) }
                .tag(BrewStationTab.snapshots)
        }
        .frame(minWidth: 900, minHeight: 600)
    }
}

// Platzhalter — werden in 3.5/4.8 ersetzt:
struct InstalledAppsView: View { var body: some View { Text("Installed") } }
struct SnapshotsRootView: View { var body: some View { Text("Snapshots") } }
