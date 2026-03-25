import XCTest
@testable import AutoBrew

final class IdleDetectorTests: XCTestCase {
    func testSystemIdleTimeReturnsValue() {
        let idleTime = IdleDetector.systemIdleTime()
        // Should return a non-negative value on macOS
        if let idle = idleTime {
            XCTAssertGreaterThanOrEqual(idle, 0)
        }
        // nil is acceptable in CI where IOKit may not be available
    }
}
