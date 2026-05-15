import SwiftUI

struct BrowseDetailView: View {
    let entry: CaskCatalogEntry
    @State private var isInstalling = false
    @State private var installError: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    CaskIconView(token: entry.token, size: 64)
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
        // Install-Aktion wird in Phase 3.6 angebunden — Platzhalter:
        Button {
            // Wird in Task 3.6 angebunden
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
}
