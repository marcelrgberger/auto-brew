import SwiftUI

struct SnapshotListView: View {
    @Binding var selection: AppSnapshot?
    @Bindable var store: SnapshotsStore

    var body: some View {
        List(selection: $selection) {
            ForEach(store.groupedByApp, id: \.bundleID) { group in
                Section(group.items.first?.displayName ?? group.bundleID) {
                    ForEach(group.items) { snap in
                        VStack(alignment: .leading) {
                            Text(snap.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.callout)
                            Text(ByteFormatter.string(snap.totalBytes))
                                .font(.caption2).foregroundStyle(.secondary)
                        }.tag(snap)
                    }
                }
            }
        }
    }
}
