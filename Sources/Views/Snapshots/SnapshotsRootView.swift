import SwiftUI

struct SnapshotsRootView: View {
    @State private var store = SnapshotsStore.shared
    @State private var selected: AppSnapshot?
    @State private var showWizard = false

    var body: some View {
        NavigationSplitView {
            SnapshotListView(selection: $selected, store: store)
                .frame(minWidth: 280)
        } detail: {
            if let snap = selected {
                SnapshotDetailView(snapshot: snap)
            } else {
                ContentUnavailableView(
                    String(localized: "No snapshot selected"),
                    systemImage: "camera",
                    description: Text(String(localized: "Create a snapshot from the Installed tab."))
                )
            }
        }
        .task { store.refresh() }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showWizard = true
                } label: {
                    Label(String(localized: "Import Bundle"), systemImage: "tray.and.arrow.down")
                }
            }
        }
        .sheet(isPresented: $showWizard) {
            RestoreWizardView(onClose: {
                showWizard = false
                store.refresh()
            })
        }
    }
}
