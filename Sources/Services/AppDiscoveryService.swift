import Foundation
import AppKit

struct AppDiscoveryService: Sendable {
    func scan(directories: [URL] = [URL(fileURLWithPath: "/Applications")],
              resolver: CaskNameResolver) async -> [InstalledApp] {
        var results: [InstalledApp] = []
        for dir in directories {
            guard let items = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) else { continue }
            for item in items where item.pathExtension == "app" {
                guard let app = readApp(at: item) else { continue }
                if AppleAppFilter.isAppleSystemApp(bundleID: app.bundleID) { continue }
                let token = resolver.token(forAppName: item.lastPathComponent)
                results.append(InstalledApp(
                    bundleID: app.bundleID,
                    displayName: app.displayName,
                    appPath: item,
                    version: app.version,
                    caskToken: token,
                    isHomebrewManaged: token != nil
                ))
            }
        }
        return results.sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
    }

    func readApp(at appURL: URL) -> InstalledApp? {
        let plistURL = appURL.appendingPathComponent("Contents/Info.plist")
        guard let data = try? Data(contentsOf: plistURL),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let bundleID = plist["CFBundleIdentifier"] as? String else {
            return nil
        }
        let name = (plist["CFBundleDisplayName"] as? String)
                ?? (plist["CFBundleName"] as? String)
                ?? appURL.deletingPathExtension().lastPathComponent
        let version = plist["CFBundleShortVersionString"] as? String
        return InstalledApp(
            bundleID: bundleID,
            displayName: name,
            appPath: appURL,
            version: version,
            caskToken: nil,
            isHomebrewManaged: false
        )
    }
}
