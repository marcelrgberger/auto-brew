import SwiftUI
import AppKit

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
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    Task { await exportAll() }
                } label: {
                    Label(String(localized: "Export All…"), systemImage: "square.and.arrow.up.on.square")
                }
                .disabled(store.snapshots.isEmpty)
            }
        }
        .sheet(isPresented: $showWizard) {
            RestoreWizardView(onClose: {
                showWizard = false
                store.refresh()
            })
        }
    }

    @MainActor
    private func exportAll() async {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.title = String(localized: "Choose folder for export")
        let resp = await withCheckedContinuation { cont in panel.begin { cont.resume(returning: $0) } }
        guard resp == .OK, let dir = panel.url else { return }
        let stamp = Date().formatted(.iso8601.year().month().day())
        let target = dir.appendingPathComponent("AutoBrew-export-\(stamp).autobrewbundle", isDirectory: true)
        try? await SnapshotService.shared.exportRestoreList(snapshots: store.snapshots, to: target)
    }
}
