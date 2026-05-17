import Foundation
import os

protocol URLSessionProtocol: Sendable {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

@Observable
@MainActor
final class BrewCatalogService {
    static let shared = BrewCatalogService()

    private(set) var casks: [CaskCatalogEntry] = []
    private(set) var analytics: CaskAnalytics?
    private(set) var lastRefresh: Date?
    private(set) var isLoading: Bool = false
    private(set) var lastError: String?

    private let session: URLSessionProtocol
    private let cacheDir: URL
    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "BrewCatalog")

    private let casksURL = URL(string: "https://formulae.brew.sh/api/cask.json")!
    private let analyticsURL = URL(string: "https://formulae.brew.sh/api/analytics/cask-install/homebrew-cask/365d.json")!

    init(session: URLSessionProtocol = URLSession.shared, cacheDirectory: URL? = nil) {
        self.session = session
        if let cacheDirectory {
            self.cacheDir = cacheDirectory
        } else {
            let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let dir = support.appendingPathComponent("AutoBrew/Catalog", isDirectory: true)
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            self.cacheDir = dir
        }
    }

    func refresh() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            async let casksData = session.data(from: casksURL)
            async let analyticsData = session.data(from: analyticsURL)

            let (caskBytes, _) = try await casksData
            let (analyticsBytes, _) = try await analyticsData

            let (decoded, analyticsDecoded) = try await Task.detached {
                (try JSONDecoder().decode([CaskCatalogEntry].self, from: caskBytes),
                 try JSONDecoder().decode(CaskAnalytics.self, from: analyticsBytes))
            }.value

            // Write cache first — if either write fails, in-memory state stays untouched
            // so a subsequent loadCache() does not surface a mismatched cask/analytics pair.
            try caskBytes.write(to: cacheDir.appendingPathComponent("cask.json"))
            try analyticsBytes.write(to: cacheDir.appendingPathComponent("analytics.json"))

            casks = decoded
            analytics = analyticsDecoded
            lastRefresh = Date()
            lastError = nil

            logger.info("Catalog refreshed: \(decoded.count) casks")
        } catch {
            lastError = error.localizedDescription
            logger.error("Catalog refresh failed: \(error.localizedDescription)")
            throw error
        }
    }

    func loadCache() async throws {
        let caskFile = cacheDir.appendingPathComponent("cask.json")
        guard FileManager.default.fileExists(atPath: caskFile.path) else {
            throw NSError(domain: "BrewCatalog", code: 1, userInfo: [NSLocalizedDescriptionKey: "No cache"])
        }
        let analyticsFile = cacheDir.appendingPathComponent("analytics.json")
        let modDate = (try? FileManager.default.attributesOfItem(atPath: caskFile.path))?[.modificationDate] as? Date

        let (loadedCasks, loadedAnalytics) = try await Task.detached {
            let casksData = try Data(contentsOf: caskFile)
            let casks = try JSONDecoder().decode([CaskCatalogEntry].self, from: casksData)
            var analytics: CaskAnalytics?
            if FileManager.default.fileExists(atPath: analyticsFile.path) {
                let aData = try Data(contentsOf: analyticsFile)
                analytics = try? JSONDecoder().decode(CaskAnalytics.self, from: aData)
            }
            return (casks, analytics)
        }.value

        casks = loadedCasks
        analytics = loadedAnalytics
        lastRefresh = modDate
        logger.info("Loaded \(self.casks.count) casks from cache")
    }
}
