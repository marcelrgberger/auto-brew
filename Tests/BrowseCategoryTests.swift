import XCTest
@testable import AutoBrew

final class BrowseCategoryTests: XCTestCase {
    private func makeEntry(token: String, desc: String? = nil) -> CaskCatalogEntry {
        let descPart = desc.map { "\"desc\":\"\($0)\"" } ?? "\"desc\":null"
        let json = #"""
        {"token":"\#(token)","name":["\#(token)"],\#(descPart),"homepage":"x","url":"y","version":"1","artifacts":[]}
        """#
        return try! JSONDecoder().decode(CaskCatalogEntry.self, from: Data(json.utf8))
    }

    func testBrowsersCategory() {
        let firefox = makeEntry(token: "firefox", desc: "Web browser")
        XCTAssertTrue(BrowseCategory.browsers.matches(firefox))
    }

    func testDeveloperToolsCategory() {
        let vscode = makeEntry(token: "visual-studio-code", desc: "Code editor")
        XCTAssertTrue(BrowseCategory.developerTools.matches(vscode))
    }

    func testCommunicationCategory() {
        let slack = makeEntry(token: "slack", desc: "Team communication")
        XCTAssertTrue(BrowseCategory.communication.matches(slack))
    }

    func testQuickCategoriesAlwaysMatch() {
        let any = makeEntry(token: "random", desc: nil)
        XCTAssertTrue(BrowseCategory.all.matches(any))
        XCTAssertTrue(BrowseCategory.popular.matches(any))
        XCTAssertTrue(BrowseCategory.recent.matches(any))
    }

    func testCategoryForDoesNotIncludeQuick() {
        let firefox = makeEntry(token: "firefox")
        let cats = BrowseCategory.categoryFor(firefox)
        XCTAssertFalse(cats.contains(.all))
        XCTAssertFalse(cats.contains(.popular))
        XCTAssertTrue(cats.contains(.browsers))
    }
}
