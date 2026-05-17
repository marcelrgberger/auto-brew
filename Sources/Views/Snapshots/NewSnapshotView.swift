import SwiftUI
import AppKit

struct NewSnapshotView: View {
    let app: InstalledApp
    let onDone: () -> Void
    @State private var store = SnapshotsStore.shared
    @State private var error: String?

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(nsImage: NSWorkspace.shared.icon(forFile: app.appPath.path))
                    .resizable().frame(width: 48, height: 48)
                VStack(alignment: .leading) {
                    Text(app.displayName).font(.title3).bold()
                    Text(app.bundleID).font(.caption).foregroundStyle(.secondary).monospaced()
                }
                Spacer()
            }
            Divider()
            Text(String(localized: "AutoBrew will copy this app's preferences, application support data, containers, and saved state into a snapshot bundle. The app stays installed."))
                .font(.callout).foregroundStyle(.secondary)
            if let error {
                Text(error).foregroundStyle(.red).font(.callout)
            }
            HStack {
                Button(String(localized: "Cancel"), action: onDone)
                Spacer()
                Button {
                    Task {
                        await store.createSnapshot(for: app)
                        if let err = store.lastError { error = err }
                        else { onDone() }
                    }
                } label: {
                    if store.isWorking { ProgressView().controlSize(.small) }
                    else { Label(String(localized: "Create Snapshot"), systemImage: "camera.fill") }
                }
                .buttonStyle(.borderedProminent)
                .disabled(store.isWorking)
            }
        }
        .padding(24)
        .frame(width: 440)
    }
}
