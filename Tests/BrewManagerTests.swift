import XCTest
@testable import AutoBrew

final class BrewManagerTests: XCTestCase {
    @MainActor
    func testBrewDetection() throws {
        let manager = BrewManager.shared
        guard manager.isHomebrewInstalled else {
            throw XCTSkip("Homebrew not installed in this environment")
        }
        XCTAssertNotNil(manager.brewPath)
        XCTAssertNotNil(manager.brewExecutable)
        XCTAssertTrue(manager.brewExecutable!.hasSuffix("/brew"))
    }

    @MainActor
    func testNotRunningByDefault() {
        let manager = BrewManager.shared
        XCTAssertFalse(manager.isRunning)
    }
}
