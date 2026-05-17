import SwiftUI

struct BrowseDetailView: View {
    let entry: CaskCatalogEntry
    @State private var isInstalling = false
    @State private var installError: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    CaskIconView(token: entry.token,
                                 appNames: entry.appNames,
                                 displayName: entry.displayName,
                                 homepage: entry.homepage,
                                 size: 64)
                    VStack(alignment: .leading) {
                        Text(entry.displayName).font(.title2).bold()
                        Text(entry.token).font(.caption).foregroundStyle(.secondary).monospaced()
                        Text(String(localized: "Version: \(entry.version)")).font(.caption)
                    }
                    Spacer()
                    installButton
                }
                Divider()
                if let desc = entry.description {
                    Text(desc).font(.body)
                }
                if !entry.homepage.isEmpty, let url = URL(string: entry.homepage) {
                    Link(entry.homepage, destination: url).font(.callout)
                }
                if !entry.appNames.isEmpty {
                    Text(String(localized: "Installed apps:")).font(.headline).padding(.top, 8)
                    ForEach(entry.appNames, id: \.self) { name in
                        Label(name, systemImage: "app").font(.callout)
                    }
                }
            }
            .padding()
        }
        .alert(String(localized: "Install failed"),
               isPresented: Binding(get: { installError != nil }, set: { if !$0 { installError = nil } }),
               presenting: installError) { _ in
            Button("OK") { installError = nil }
        } message: { msg in Text(msg) }
    }

    @ViewBuilder
    private var installButton: some View {
        Button {
            Task { await install() }
        } label: {
            if isInstalling {
                ProgressView().controlSize(.small)
            } else {
                Label(String(localized: "Install"), systemImage: "arrow.down.circle.fill")
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(isInstalling)
    }

    @MainActor
    private func install() async {
        isInstalling = true
        defer { isInstalling = false }
        do {
            try await BrewInstaller().install(token: entry.token)
            await InstalledAppsStore.shared.refresh()
        } catch {
            installError = error.localizedDescription
        }
    }
}
