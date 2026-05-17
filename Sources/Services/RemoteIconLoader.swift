import AppKit
import Foundation
import os

@MainActor
@Observable
final class RemoteIconLoader {
    static let shared = RemoteIconLoader()

    private var memoryCache: [String: NSImage] = [:]
    private var inFlight: Set<String> = []
    private let diskCacheDir: URL
    private let session: URLSession
    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "RemoteIcon")

    private init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        self.diskCacheDir = support.appendingPathComponent("AutoBrew/IconCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: diskCacheDir, withIntermediateDirectories: true)
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 8
        cfg.timeoutIntervalForResource = 12
        self.session = URLSession(configuration: cfg)
    }

    /// Synchronous lookup of an already-cached icon. Returns nil if no cached icon
    /// yet — caller should kick off `fetch(...)` to populate it.
    func cached(token: String) -> NSImage? {
        if let img = memoryCache[token] { return img }
        let hit = diskCacheDir.appendingPathComponent("\(token).png")
        if FileManager.default.fileExists(atPath: hit.path), let img = NSImage(contentsOf: hit) {
            memoryCache[token] = img
            return img
        }
        return nil
    }

    /// True if we've already tried and failed for this token (don't retry).
    func isCachedMiss(token: String) -> Bool {
        FileManager.default.fileExists(atPath: diskCacheDir.appendingPathComponent("\(token).miss").path)
    }

    /// Asynchronously fetch the icon. Calls `onLoad` on the main actor when an image becomes available.
    /// If both sources fail, writes a `.miss` sentinel and does NOT call `onLoad`.
    func fetch(token: String,
               displayName: String,
               homepage: String,
               onLoad: @MainActor @escaping (NSImage) -> Void) {
        guard !inFlight.contains(token) else { return }
        if memoryCache[token] != nil { return }
        if isCachedMiss(token: token) { return }
        if let cached = cached(token: token) {
            onLoad(cached)
            return
        }
        inFlight.insert(token)

        Task.detached { [weak self] in
            guard let self else { return }
            let img = await self.fetchRemote(displayName: displayName, homepage: homepage)
            await MainActor.run {
                self.inFlight.remove(token)
                if let img {
                    self.memoryCache[token] = img
                    if let png = img.pngData() {
                        let dest = self.diskCacheDir.appendingPathComponent("\(token).png")
                        try? png.write(to: dest)
                    }
                    onLoad(img)
                } else {
                    let miss = self.diskCacheDir.appendingPathComponent("\(token).miss")
                    try? Data().write(to: miss)
                }
            }
        }
    }

    /// Nonisolated remote-fetch path. Tries iTunes Search first, then icon.horse.
    nonisolated private func fetchRemote(displayName: String, homepage: String) async -> NSImage? {
        if let img = await fetchFromITunes(name: displayName) { return img }
        if let img = await fetchFromIconHorse(homepage: homepage) { return img }
        return nil
    }

    nonisolated private func fetchFromITunes(name: String) async -> NSImage? {
        guard var components = URLComponents(string: "https://itunes.apple.com/search") else { return nil }
        components.queryItems = [
            URLQueryItem(name: "term", value: name),
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "entity", value: "macSoftware"),
            URLQueryItem(name: "limit", value: "1")
        ]
        guard let url = components.url else { return nil }
        do {
            let (data, _) = try await session.data(from: url)
            struct Resp: Decodable {
                let results: [Result]
                struct Result: Decodable { let artworkUrl512: String? }
            }
            let resp = try JSONDecoder().decode(Resp.self, from: data)
            guard let artURL = resp.results.first?.artworkUrl512,
                  let imageURL = URL(string: artURL) else { return nil }
            let (imgData, _) = try await session.data(from: imageURL)
            return NSImage(data: imgData)
        } catch {
            return nil
        }
    }

    nonisolated private func fetchFromIconHorse(homepage: String) async -> NSImage? {
        guard !homepage.isEmpty,
              let homepageURL = URL(string: homepage),
              let host = homepageURL.host,
              let iconURL = URL(string: "https://icon.horse/icon/\(host)") else { return nil }
        do {
            let (data, response) = try await session.data(from: iconURL)
            if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) { return nil }
            return NSImage(data: data)
        } catch {
            return nil
        }
    }
}

private extension NSImage {
    func pngData() -> Data? {
        guard let tiff = self.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiff) else { return nil }
        return rep.representation(using: .png, properties: [:])
    }
}
