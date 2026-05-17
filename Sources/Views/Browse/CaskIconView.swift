import AppKit
import SwiftUI

@Observable
@MainActor
final class CaskIconCache {
    static let shared = CaskIconCache()
    private var localCache: [String: NSImage] = [:]
    private var localChecked: Set<String> = []

    func localIcon(for token: String, appNames: [String]) -> NSImage? {
        if let cached = localCache[token] { return cached }
        if localChecked.contains(token) { return nil }
        localChecked.insert(token)

        for appName in appNames {
            let path = "/Applications/\(appName)"
            if FileManager.default.fileExists(atPath: path) {
                let image = NSWorkspace.shared.icon(forFile: path)
                localCache[token] = image
                return image
            }
        }
        return nil
    }
}

struct CaskIconView: View {
    let token: String
    let appNames: [String]
    let displayName: String
    let homepage: String
    let size: CGFloat

    @State private var localCache = CaskIconCache.shared
    @State private var remoteLoader = RemoteIconLoader.shared
    @State private var remoteImage: NSImage?

    var body: some View {
        Group {
            if let icon = localCache.localIcon(for: token, appNames: appNames) {
                Image(nsImage: icon)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
            } else if let icon = remoteImage ?? remoteLoader.cached(token: token) {
                Image(nsImage: icon)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
            } else {
                fallback
            }
        }
        .frame(width: size, height: size)
        .task(id: token) {
            // Only fetch remote if local lookup failed
            if localCache.localIcon(for: token, appNames: appNames) != nil { return }
            if remoteImage != nil { return }
            if remoteLoader.cached(token: token) != nil { return }
            if remoteLoader.isCachedMiss(token: token) { return }
            if let img = await remoteLoader.fetch(token: token, displayName: displayName, homepage: homepage) {
                if Task.isCancelled { return }
                remoteImage = img
            }
        }
    }

    private var fallback: some View {
        Image(systemName: "shippingbox.fill")
            .resizable().scaledToFit()
            .padding(size * 0.2)
            .foregroundStyle(.secondary)
            .frame(width: size, height: size)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: size * 0.18))
    }
}
