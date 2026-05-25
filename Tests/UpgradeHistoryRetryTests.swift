import XCTest
@testable import AutoBrew

final class UpgradeHistoryRetryTests: XCTestCase {
    func testBackoffScheduleMatchesContract() {
        XCTAssertEqual(UpgradeHistoryEntry.backoffSchedule, [3600, 14400, 43200])
        XCTAssertEqual(UpgradeHistoryEntry.maxRetries, 3)
    }

    func testFirstFailureSchedulesOneHour() {
        let now = Date(timeIntervalSince1970: 1_000_000)
        let next = UpgradeHistoryEntry.nextRetryDate(previousRetryCount: 0, now: now)
        XCTAssertEqual(next, now.addingTimeInterval(3600))
    }

    func testSecondFailureSchedulesFourHours() {
        let now = Date(timeIntervalSince1970: 1_000_000)
        let next = UpgradeHistoryEntry.nextRetryDate(previousRetryCount: 1, now: now)
        XCTAssertEqual(next, now.addingTimeInterval(14400))
    }

    func testThirdFailureSchedulesTwelveHours() {
        let now = Date(timeIntervalSince1970: 1_000_000)
        let next = UpgradeHistoryEntry.nextRetryDate(previousRetryCount: 2, now: now)
        XCTAssertEqual(next, now.addingTimeInterval(43200))
    }

    func testFourthFailureExhaustsBudget() {
        // previousRetryCount=3 means we've already had three retries
        // after the initial failure — fourth attempt would be over
        // the budget, so the row becomes sticky-failed.
        let next = UpgradeHistoryEntry.nextRetryDate(previousRetryCount: 3)
        XCTAssertNil(next, "Retry budget must be exhausted at maxRetries")
    }

    func testCodableRoundtripIncludesRetryFields() throws {
        let entry = UpgradeHistoryEntry(
            id: UUID(),
            timestamp: Date(timeIntervalSince1970: 800_000_000),
            token: "vscode",
            displayName: "Visual Studio Code",
            fromVersion: "1.90.0",
            toVersion: "1.91.0",
            bundleID: "com.microsoft.VSCode",
            snapshotID: UUID(),
            outcome: .failed,
            retryCount: 2,
            nextRetryAt: Date(timeIntervalSince1970: 800_043_200)
        )
        let data = try JSONEncoder.iso8601.encode([entry])
        let decoded = try JSONDecoder.iso8601.decode([UpgradeHistoryEntry].self, from: data)
        XCTAssertEqual(decoded.first?.retryCount, 2)
        XCTAssertEqual(decoded.first?.nextRetryAt, Date(timeIntervalSince1970: 800_043_200))
    }

    func testLegacyEntryDecodesWithDefaults() throws {
        let legacy = #"""
        [{
          "id": "11111111-1111-1111-1111-111111111111",
          "timestamp": "2025-12-01T12:00:00Z",
          "token": "vscode",
          "displayName": "Visual Studio Code",
          "fromVersion": "1.90.0",
          "toVersion": "1.91.0",
          "bundleID": "com.microsoft.VSCode",
          "snapshotID": null,
          "succeeded": false
        }]
        """#
        let data = Data(legacy.utf8)
        let decoded = try JSONDecoder.iso8601.decode([UpgradeHistoryEntry].self, from: data)
        XCTAssertEqual(decoded.first?.outcome, .failed)
        XCTAssertEqual(decoded.first?.retryCount, 0,
                       "Pre-retry-schema rows must default to retryCount=0")
        XCTAssertNil(decoded.first?.nextRetryAt,
                     "Pre-retry-schema rows must default to nextRetryAt=nil")
    }
}
