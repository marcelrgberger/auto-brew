import XCTest
@testable import AutoBrew

final class IdleDetectorTests: XCTestCase {
    func testSystemIdleTimeReturnsValue() throws {
        guard let idle = IdleDetector.systemIdleTime() else {
            throw XCTSkip("IOKit idle time unavailable in this environment")
        }
        XCTAssertGreaterThanOrEqual(idle, 0)
    }
}
