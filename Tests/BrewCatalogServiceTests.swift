import XCTest
@testable import AutoBrew

final class BrewCatalogServiceTests: XCTestCase {
    @MainActor
    func testFetchesAndCachesCatalog() async throws {
        let casksJSON = #"[{"token":"firefox","name":["Firefox"],"desc":"Browser","homepage":"https://mozilla.org","url":"x","version":"1","artifacts":[]}]"#
        let analyticsJSON = #"{"category":"cask-install","total_items":1,"total_count":100,"items":[{"number":1,"cask":"firefox","count":"100"}]}"#

        let session = MockURLSession(responses: [
            URL(string: "https://formulae.brew.sh/api/cask.json")!: casksJSON.data(using: .utf8)!,
            URL(string: "https://formulae.brew.sh/api/analytics/cask-install/homebrew-cask/365d.json")!: analyticsJSON.data(using: .utf8)!
        ])

        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmp) }

        let svc = BrewCatalogService(session: session, cacheDirectory: tmp)
        try await svc.refresh()

        XCTAssertEqual(svc.casks.count, 1)
        XCTAssertEqual(svc.casks.first?.token, "firefox")
        XCTAssertEqual(svc.analytics?.installCount(for: "firefox"), 100)
        XCTAssertTrue(FileManager.default.fileExists(atPath: tmp.appendingPathComponent("cask.json").path))
    }

    @MainActor
    func testLoadsFromCacheWhenOffline() async throws {
        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmp) }

        let cached = #"[{"token":"vlc","name":["VLC"],"desc":null,"homepage":"https://x","url":"y","version":"1","artifacts":[]}]"#
        try cached.write(to: tmp.appendingPathComponent("cask.json"), atomically: true, encoding: .utf8)

        let svc = BrewCatalogService(session: MockURLSession(error: URLError(.notConnectedToInternet)), cacheDirectory: tmp)
        try await svc.loadCache()

        XCTAssertEqual(svc.casks.count, 1)
        XCTAssertEqual(svc.casks.first?.token, "vlc")
    }
}

final class MockURLSession: URLSessionProtocol, @unchecked Sendable {
    let responses: [URL: Data]
    let error: Error?
    init(responses: [URL: Data] = [:], error: Error? = nil) {
        self.responses = responses
        self.error = error
    }
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error { throw error }
        guard let data = responses[url] else { throw URLError(.fileDoesNotExist) }
        let resp = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, resp)
    }
}
