import SwiftUI

struct RestoreProgressView: View {
    @Bindable var store: RestoreWizardStore

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(store.snapshots) { snap in
                HStack {
                    Text(snap.displayName).font(.callout).bold()
                    Spacer()
                    Text(store.progress[snap.bundleID] ?? "—").font(.caption).foregroundStyle(.secondary)
                }
            }
        }.padding()
    }
}
