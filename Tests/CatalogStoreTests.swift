import XCTest
@testable import AutoBrew

final class CatalogStoreTests: XCTestCase {
    private func sampleCasks() -> [CaskCatalogEntry] {
        let json = """
        [
            {"token":"firefox","name":["Firefox"],"desc":"Browser","homepage":"x","url":"y","version":"1","artifacts":[]},
            {"token":"google-chrome","name":["Google Chrome"],"desc":"Chrome browser","homepage":"x","url":"y","version":"1","artifacts":[]},
            {"token":"vlc","name":["VLC"],"desc":"Media player","homepage":"x","url":"y","version":"1","artifacts":[]}
        ]
        """.data(using: .utf8)!
        return try! JSONDecoder().decode([CaskCatalogEntry].self, from: json)
    }

    @MainActor
    func testSearchByToken() {
        let store = CatalogStore()
        store.replaceAll(sampleCasks(), analytics: nil)
        store.searchQuery = "vlc"
        XCTAssertEqual(store.filtered.count, 1)
        XCTAssertEqual(store.filtered.first?.token, "vlc")
    }

    @MainActor
    func testSearchByName() {
        let store = CatalogStore()
        store.replaceAll(sampleCasks(), analytics: nil)
        store.searchQuery = "chrome"
        XCTAssertEqual(store.filtered.count, 1)
    }

    @MainActor
    func testSearchByDescription() {
        let store = CatalogStore()
        store.replaceAll(sampleCasks(), analytics: nil)
        store.searchQuery = "media"
        XCTAssertEqual(store.filtered.count, 1)
        XCTAssertEqual(store.filtered.first?.token, "vlc")
    }

    @MainActor
    func testEmptyQueryReturnsAll() {
        let store = CatalogStore()
        store.replaceAll(sampleCasks(), analytics: nil)
        store.searchQuery = ""
        XCTAssertEqual(store.filtered.count, 3)
    }

    @MainActor
    func testSortByPopularity() throws {
        let analyticsJSON = """
        {"category":"cask-install","total_items":3,"total_count":1000,
         "items":[
            {"number":1,"cask":"vlc","count":"500"},
            {"number":2,"cask":"firefox","count":"300"},
            {"number":3,"cask":"google-chrome","count":"100"}
         ]}
        """.data(using: .utf8)!
        let analytics = try JSONDecoder().decode(CaskAnalytics.self, from: analyticsJSON)

        let store = CatalogStore()
        store.replaceAll(sampleCasks(), analytics: analytics)
        store.sortMode = .popularity
        let tokens = store.filtered.map(\.token)
        XCTAssertEqual(tokens, ["vlc", "firefox", "google-chrome"])
    }

    @MainActor
    func testSortByName() {
        let store = CatalogStore()
        store.replaceAll(sampleCasks(), analytics: nil)
        store.sortMode = .name
        let names = store.filtered.map(\.displayName)
        XCTAssertEqual(names, ["Firefox", "Google Chrome", "VLC"])
    }
}
