import AppKit
import SwiftUI

struct RankedCaskRow: View {
    let rank: Int
    let entry: CaskCatalogEntry

    @State private var installer = BrewInstaller()
    @State private var isInstalling = false
    @State private var installerError: String?

    var body: some View {
        HStack(spacing: 12) {
            CaskIconView(token: entry.token,
                         appNames: entry.appNames,
                         displayName: entry.displayName,
                         homepage: entry.homepage,
                         size: 56)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("\(rank)")
                .font(.title3.weight(.regular))
                .foregroundStyle(.secondary)
                .frame(width: 24, alignment: .center)
                .monospacedDigit()

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.displayName)
                    .font(.system(.body, weight: .semibold))
                    .lineLimit(1)
                if let desc = entry.description {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            installButton
        }
        .padding(.vertical, 8)
        .alert(String(localized: "Install failed"),
               isPresented: Binding(get: { installerError != nil },
                                    set: { if !$0 { installerError = nil } }),
               presenting: installerError) { _ in
            Button("OK") { installerError = nil }
        } message: { msg in
            Text(msg)
        }
    }

    @ViewBuilder
    private var installButton: some View {
        Button {
            Task { await install() }
        } label: {
            if isInstalling {
                ProgressView().controlSize(.small)
            } else {
                Text(isInstalled ? String(localized: "Open") : String(localized: "Install"))
                    .font(.callout.weight(.semibold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 5)
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .clipShape(Capsule())
        .disabled(isInstalling)
    }

    private var isInstalled: Bool {
        entry.appNames.contains { name in
            FileManager.default.fileExists(atPath: "/Applications/\(name)")
        }
    }

    @MainActor
    private func install() async {
        guard !isInstalled else {
            if let appName = entry.appNames.first {
                NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/\(appName)"))
            }
            return
        }
        isInstalling = true
        defer { isInstalling = false }
        do {
            try await installer.install(token: entry.token)
            await InstalledAppsStore.shared.refresh()
        } catch {
            installerError = error.localizedDescription
        }
    }
}
