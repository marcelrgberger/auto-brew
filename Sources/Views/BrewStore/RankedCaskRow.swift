import AppKit
import SwiftUI

struct RankedCaskRow: View {
    let rank: Int
    let entry: CaskCatalogEntry
    let onOpenDetail: () -> Void

    @State private var installer = BrewInstaller()
    @State private var isInstalling = false
    @State private var installerError: String?
    @State private var installedApps = InstalledAppsStore.shared

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

            Button {
                onOpenDetail()
            } label: {
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

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

    /// Resolves to the first appName from `entry.appNames` that exists on disk,
    /// or nil if none are installed. Uses the in-memory `InstalledAppsStore` to
    /// avoid syscalls when warm; falls back to a direct disk check on cold launch
    /// so users don't see Install on already-installed apps before the store loads.
    private var installedAppPath: String? {
        let installed = installedApps.apps
        if !installed.isEmpty {
            for name in entry.appNames {
                if let app = installed.first(where: { $0.appPath.lastPathComponent == name }) {
                    return app.appPath.path
                }
            }
            return nil
        }
        // Cold-launch fallback: store hasn't refreshed yet — check disk directly.
        for name in entry.appNames {
            let path = "/Applications/\(name)"
            if FileManager.default.fileExists(atPath: path) { return path }
        }
        return nil
    }

    private var isInstalled: Bool { installedAppPath != nil }

    @MainActor
    private func install() async {
        if let path = installedAppPath {
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
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
