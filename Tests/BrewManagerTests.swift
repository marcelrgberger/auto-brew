import XCTest
@testable import AutoBrew

final class BrewManagerTests: XCTestCase {
    @MainActor
    func testBrewDetection() {
        let manager = BrewManager.shared
        // On a dev machine with Homebrew, this should find it
        if manager.isHomebrewInstalled {
            XCTAssertNotNil(manager.brewPath)
            XCTAssertNotNil(manager.brewExecutable)
            XCTAssertTrue(manager.brewExecutable!.hasSuffix("/brew"))
        }
    }

    @MainActor
    func testNotRunningByDefault() {
        let manager = BrewManager.shared
        XCTAssertFalse(manager.isRunning)
    }
}
