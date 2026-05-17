import SwiftUI
import AppKit

struct InstalledAppRowView: View {
    let app: InstalledApp
    let onUpgrade: () -> Void
    let onUninstall: () -> Void
    let onSnapshot: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(nsImage: NSWorkspace.shared.icon(forFile: app.appPath.path))
                .resizable().frame(width: 38, height: 38)
            VStack(alignment: .leading, spacing: 2) {
                Text(app.displayName).font(.system(.body, weight: .semibold))
                HStack(spacing: 6) {
                    Text(app.bundleID).font(.caption).foregroundStyle(.secondary).monospaced()
                    if let v = app.version {
                        Text("· \(v)").font(.caption).foregroundStyle(.tertiary)
                    }
                }
                if let token = app.caskToken {
                    Label(token, systemImage: "shippingbox").font(.caption2).foregroundStyle(.blue)
                }
            }
            Spacer()
            Menu {
                Button(String(localized: "Take Snapshot"), action: onSnapshot)
                if app.caskToken != nil {
                    Button(String(localized: "Upgrade via Brew"), action: onUpgrade)
                    Button(String(localized: "Uninstall via Brew"), role: .destructive, action: onUninstall)
                }
            } label: {
                Image(systemName: "ellipsis.circle").imageScale(.large)
            }
            .menuStyle(.borderlessButton)
            .fixedSize()
        }
        .padding(.vertical, 4)
    }
}
