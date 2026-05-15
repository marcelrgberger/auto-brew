import XCTest
@testable import AutoBrew

final class CaskNameResolverTests: XCTestCase {
    private func sampleCasks() -> [CaskCatalogEntry] {
        let json = """
        [
            {"token":"firefox","name":["Firefox"],"desc":null,"homepage":"x","url":"y","version":"1","artifacts":[{"app":["Firefox.app"]}]},
            {"token":"google-chrome","name":["Google Chrome"],"desc":null,"homepage":"x","url":"y","version":"1","artifacts":[{"app":["Google Chrome.app"]}]},
            {"token":"visual-studio-code","name":["VS Code"],"desc":null,"homepage":"x","url":"y","version":"1","artifacts":[{"app":["Visual Studio Code.app"]}]}
        ]
        """.data(using: .utf8)!
        return try! JSONDecoder().decode([CaskCatalogEntry].self, from: json)
    }

    func testResolvesByAppName() {
        let r = CaskNameResolver(catalog: sampleCasks())
        XCTAssertEqual(r.token(forAppName: "Firefox.app"), "firefox")
        XCTAssertEqual(r.token(forAppName: "Visual Studio Code.app"), "visual-studio-code")
        XCTAssertNil(r.token(forAppName: "Unknown.app"))
    }

    func testCaseInsensitive() {
        let r = CaskNameResolver(catalog: sampleCasks())
        XCTAssertEqual(r.token(forAppName: "firefox.app"), "firefox")
    }
}
