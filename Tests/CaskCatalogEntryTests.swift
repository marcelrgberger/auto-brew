import XCTest
@testable import AutoBrew

final class CaskCatalogEntryTests: XCTestCase {
    func testDecodesBasicCask() throws {
        let json = """
        {
            "token": "firefox",
            "name": ["Firefox"],
            "desc": "Web browser",
            "homepage": "https://www.mozilla.org/firefox/",
            "url": "https://download.mozilla.org/...",
            "version": "126.0",
            "artifacts": [{"app": ["Firefox.app"]}]
        }
        """.data(using: .utf8)!

        let entry = try JSONDecoder().decode(CaskCatalogEntry.self, from: json)

        XCTAssertEqual(entry.token, "firefox")
        XCTAssertEqual(entry.displayName, "Firefox")
        XCTAssertEqual(entry.description, "Web browser")
        XCTAssertEqual(entry.version, "126.0")
        XCTAssertEqual(entry.appNames, ["Firefox.app"])
    }

    func testHandlesMultipleAppArtifacts() throws {
        let json = """
        {
            "token": "office",
            "name": ["Microsoft Office"],
            "desc": null,
            "homepage": "https://office.com",
            "url": "https://...",
            "version": "16.0",
            "artifacts": [
                {"app": ["Word.app", "Excel.app"]},
                {"app": ["PowerPoint.app"]}
            ]
        }
        """.data(using: .utf8)!

        let entry = try JSONDecoder().decode(CaskCatalogEntry.self, from: json)
        XCTAssertEqual(entry.appNames, ["Word.app", "Excel.app", "PowerPoint.app"])
    }

    func testHandlesMissingArtifacts() throws {
        let json = """
        {
            "token": "cli-tool",
            "name": ["Tool"],
            "desc": null,
            "homepage": "https://example.com",
            "url": "https://...",
            "version": "1.0",
            "artifacts": []
        }
        """.data(using: .utf8)!

        let entry = try JSONDecoder().decode(CaskCatalogEntry.self, from: json)
        XCTAssertEqual(entry.appNames, [])
    }
}

final class CaskAnalyticsTests: XCTestCase {
    func testDecodesAnalytics() throws {
        let json = """
        {
            "category": "cask-install",
            "total_items": 2,
            "total_count": 1000,
            "items": [
                {"number": 1, "cask": "firefox", "count": "500"},
                {"number": 2, "cask": "chrome", "count": "300"}
            ]
        }
        """.data(using: .utf8)!

        let analytics = try JSONDecoder().decode(CaskAnalytics.self, from: json)
        XCTAssertEqual(analytics.installCount(for: "firefox"), 500)
        XCTAssertEqual(analytics.installCount(for: "chrome"), 300)
        XCTAssertEqual(analytics.installCount(for: "unknown"), 0)
    }

    func testHandlesCommaSeparatedCount() throws {
        let json = """
        {"category":"cask-install","total_items":1,"total_count":1500000,
         "items":[{"number":1,"cask":"vlc","count":"1,500,000"}]}
        """.data(using: .utf8)!

        let analytics = try JSONDecoder().decode(CaskAnalytics.self, from: json)
        XCTAssertEqual(analytics.installCount(for: "vlc"), 1_500_000)
    }
}
