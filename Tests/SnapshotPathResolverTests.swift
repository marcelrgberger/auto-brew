import XCTest
@testable import AutoBrew

final class SnapshotPathResolverTests: XCTestCase {
    func testReturnsStandardLibraryPaths() {
        let r = SnapshotPathResolver(bundleID: "com.example.app", home: URL(fileURLWithPath: "/Users/test"))
        let pathStrings = r.candidatePaths().map { $0.path }

        XCTAssertTrue(pathStrings.contains("/Users/test/Library/Preferences/com.example.app.plist"))
        XCTAssertTrue(pathStrings.contains("/Users/test/Library/Application Support/com.example.app"))
        XCTAssertTrue(pathStrings.contains("/Users/test/Library/Containers/com.example.app"))
        XCTAssertTrue(pathStrings.contains("/Users/test/Library/Saved Application State/com.example.app.savedState"))
    }

    func testIncludesGroupContainerRoot() {
        let r = SnapshotPathResolver(bundleID: "com.example.app", home: URL(fileURLWithPath: "/Users/test"))
        XCTAssertEqual(r.groupContainerSearchRoot.path, "/Users/test/Library/Group Containers")
    }
}
