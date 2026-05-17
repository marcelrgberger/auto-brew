import XCTest
@testable import AutoBrew

final class AppleAppFilterTests: XCTestCase {
    func testFiltersApple() {
        XCTAssertTrue(AppleAppFilter.isAppleSystemApp(bundleID: "com.apple.Safari"))
        XCTAssertTrue(AppleAppFilter.isAppleSystemApp(bundleID: "com.apple.dt.Xcode"))
        XCTAssertTrue(AppleAppFilter.isAppleSystemApp(bundleID: "com.apple.appstore"))
    }
    func testAllowsThirdParty() {
        XCTAssertFalse(AppleAppFilter.isAppleSystemApp(bundleID: "org.mozilla.firefox"))
        XCTAssertFalse(AppleAppFilter.isAppleSystemApp(bundleID: "com.microsoft.VSCode"))
    }
}
