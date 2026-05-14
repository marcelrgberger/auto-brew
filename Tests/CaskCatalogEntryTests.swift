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
