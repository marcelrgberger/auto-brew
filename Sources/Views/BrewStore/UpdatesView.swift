import SwiftUI

struct UpdatesView: View {
    @State private var brewManager = BrewManager.shared
    @State private var hasLoaded = false

    var body: some View {
        Group {
            if !hasLoaded {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if brewManager.outdatedPackages.isEmpty {
                ContentUnavailableView(
                    String(localized: "All up to date"),
                    systemImage: "checkmark.seal.fill",
                    description: Text(String(localized: "No package updates available."))
                )
            } else {
                List {
                    ForEach(brewManager.outdatedPackages) { pkg in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(pkg.name).font(.body.weight(.semibold))
                                Text("\(pkg.currentVersion) → \(pkg.newVersion)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .monospaced()
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .task {
            await brewManager.fetchOutdated()
            hasLoaded = true
        }
    }
}
