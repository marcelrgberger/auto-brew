import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct RestoreWizardView: View {
    @State private var store = RestoreWizardStore()
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            content
            Divider()
            footer
        }
        .frame(width: 560, height: 480)
    }

    private var header: some View {
        HStack {
            Label(String(localized: "Restore from Snapshot Bundle"), systemImage: "tray.and.arrow.down.fill")
                .font(.headline)
            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private var content: some View {
        switch store.step {
        case .selectFile:
            VStack(spacing: 14) {
                Image(systemName: "tray.and.arrow.down")
                    .font(.system(size: 40)).foregroundStyle(.secondary)
                Text(String(localized: "Open a .autobrewsnapshot file or a folder exported from another Mac."))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button(String(localized: "Choose…")) { Task { await pick() } }
                    .buttonStyle(.borderedProminent)
                if let err = store.loadError {
                    Text(err)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        case .review:
            VStack(alignment: .leading) {
                Text(String(localized: "Apps to restore (\(store.snapshots.count))"))
                    .font(.headline).padding(.horizontal)
                List {
                    ForEach(store.snapshots) { snap in
                        Toggle(isOn: Binding(
                            get: { store.selected.contains(snap.bundleID) },
                            set: { on in
                                if on { store.selected.insert(snap.bundleID) }
                                else { store.selected.remove(snap.bundleID) }
                            }
                        )) {
                            VStack(alignment: .leading) {
                                Text(snap.displayName)
                                Text(snap.bundleID).font(.caption).foregroundStyle(.secondary).monospaced()
                            }
                        }
                    }
                }
                Toggle(String(localized: "Install missing casks via Homebrew"),
                       isOn: $store.installMissingCasks).padding(.horizontal)
                Toggle(String(localized: "Quit apps before restoring data"),
                       isOn: $store.quitAppsBeforeRestore).padding(.horizontal)
            }
        case .running:
            RestoreProgressView(store: store)
        case .done:
            VStack(spacing: 12) {
                Image(systemName: store.failedBundles.isEmpty ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(store.failedBundles.isEmpty ? .green : .orange)
                Text(store.failedBundles.isEmpty
                     ? String(localized: "All snapshots restored successfully.")
                     : String(localized: "Completed with \(store.failedBundles.count) failures."))
                if !store.failedBundles.isEmpty {
                    ForEach(store.failedBundles, id: \.self) {
                        Text($0).font(.caption).foregroundStyle(.red)
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var footer: some View {
        HStack {
            Button(String(localized: "Close"), action: onClose)
            Spacer()
            actionButton
        }.padding()
    }

    @ViewBuilder
    private var actionButton: some View {
        switch store.step {
        case .review:
            Button(String(localized: "Restore")) {
                Task { await store.performRestore() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(store.selected.isEmpty)
        case .done:
            Button(String(localized: "Done"), action: onClose).buttonStyle(.borderedProminent)
        default: EmptyView()
        }
    }

    private func pick() async {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        let snapshotType = UTType(filenameExtension: "autobrewsnapshot") ?? .data
        panel.allowedContentTypes = [snapshotType]
        panel.allowsOtherFileTypes = false
        let resp = await panel.runModalAsync()
        if resp == .OK, let url = panel.url {
            await store.loadBundle(at: url)
        }
    }
}
