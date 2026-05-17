import SwiftUI

struct DiscoverSection: View {
    let title: String
    let entries: [CaskCatalogEntry]
    let onSelect: (CaskCatalogEntry) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title).font(.title3).bold()
                Spacer()
            }
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)], spacing: 0) {
                ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                    RankedCaskRow(rank: index + 1, entry: entry, onOpenDetail: { onSelect(entry) })
                }
            }
            Divider()
        }
    }
}
