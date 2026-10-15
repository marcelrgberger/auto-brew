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

    // MARK: - Retry candidate selection

    private func entry(_ token: String, at seconds: TimeInterval, outcome: CaskUpgradeOutcome,
                       retryCount: Int = 0, nextRetryAt: TimeInterval? = nil) -> UpgradeHistoryEntry {
        UpgradeHistoryEntry(
            id: UUID(),
            timestamp: Date(timeIntervalSince1970: seconds),
            token: token,
            displayName: token,
            fromVersion: "1.0",
            toVersion: "1.1",
            bundleID: nil,
            snapshotID: nil,
            outcome: outcome,
            retryCount: retryCount,
            nextRetryAt: nextRetryAt.map(Date.init(timeIntervalSince1970:))
        )
    }

    func testDueFailureIsRetryCandidate() {
        let now = Date(timeIntervalSince1970: 10_000)
        let entries = [entry("vscode", at: 1_000, outcome: .failed, nextRetryAt: 4_600)]
        XCTAssertEqual(UpgradeHistoryEntry.retryCandidates(in: entries, now: now).map(\.token), ["vscode"])
    }

    func testOlderFailureIsIgnoredAfterLaterSuccess() {
        // Newest first, as UpgradeHistoryStore keeps it.
        let now = Date(timeIntervalSince1970: 10_000)
        let entries = [
            entry("vscode", at: 5_000, outcome: .succeeded),
            entry("vscode", at: 1_000, outcome: .failed, nextRetryAt: 4_600),
        ]
        XCTAssertTrue(UpgradeHistoryEntry.retryCandidates(in: entries, now: now).isEmpty)
    }

    func testOlderFailureDoesNotBypassNewerBackoffWindow() {
        let now = Date(timeIntervalSince1970: 10_000)
        let entries = [
            entry("vscode", at: 5_000, outcome: .failed, retryCount: 1, nextRetryAt: 19_400),
            entry("vscode", at: 1_000, outcome: .failed, retryCount: 0, nextRetryAt: 4_600),
        ]
        XCTAssertTrue(UpgradeHistoryEntry.retryCandidates(in: entries, now: now).isEmpty)
    }

    func testLatestPerTokenKeepsNewestEntryOfEachToken() {
        let entries = [
            entry("vscode", at: 3_000, outcome: .succeeded),
            entry("docker", at: 2_000, outcome: .failed, nextRetryAt: 5_600),
            entry("vscode", at: 1_000, outcome: .failed, nextRetryAt: 4_600),
        ]
        let latest = UpgradeHistoryEntry.latestPerToken(in: entries)
        XCTAssertEqual(latest.map(\.id), [entries[0].id, entries[1].id])
    }

    func testExhaustedBudgetIsNotRetried() {
        let now = Date(timeIntervalSince1970: 10_000)
        let entries = [entry("vscode", at: 1_000, outcome: .failed, retryCount: 3, nextRetryAt: nil)]
        XCTAssertTrue(UpgradeHistoryEntry.retryCandidates(in: entries, now: now).isEmpty)
    }

    /// Walks the complete failure sequence through the writer and the
    /// selector: three automatic retries (1 h, 4 h, 12 h), then sticky.
    func testFullFailureSequenceRetriesThreeTimesThenStops() {
        var history: [UpgradeHistoryEntry] = []
        var now = Date(timeIntervalSince1970: 100_000)
        var executedRetries = 0
        var delays: [TimeInterval] = []

        func recordFailure() {
            let state = UpgradeHistoryEntry.retryState(after: .failed, token: "vscode", history: history, now: now)
            history.insert(entry("vscode", at: now.timeIntervalSince1970, outcome: .failed,
                                 retryCount: state.retryCount,
                                 nextRetryAt: state.nextRetryAt?.timeIntervalSince1970), at: 0)
        }

        recordFailure() // initial scheduled run fails
        while let due = history.first?.nextRetryAt {
            delays.append(due.timeIntervalSince(now))
            now = due
            XCTAssertEqual(UpgradeHistoryEntry.retryCandidates(in: history, now: now).map(\.token), ["vscode"])
            executedRetries += 1
            recordFailure()
            XCTAssertLessThanOrEqual(executedRetries, UpgradeHistoryEntry.maxRetries)
        }

        XCTAssertEqual(executedRetries, 3)
        XCTAssertEqual(delays, [3600, 14400, 43200])
        XCTAssertEqual(history.first?.retryCount, UpgradeHistoryEntry.maxRetries)
        XCTAssertTrue(UpgradeHistoryEntry.retryCandidates(in: history, now: now.addingTimeInterval(86_400)).isEmpty)
    }

    func testSuccessResetsRetryState() {
        let history = [entry("vscode", at: 1_000, outcome: .failed, retryCount: 2, nextRetryAt: 15_400)]
        let state = UpgradeHistoryEntry.retryState(after: .succeeded, token: "vscode", history: history,
                                                   now: Date(timeIntervalSince1970: 2_000))
        XCTAssertEqual(state.retryCount, 0)
        XCTAssertNil(state.nextRetryAt)
    }

    func testSuccessInBetweenStartsFreshBudget() {
        // exhausted failure -> success -> new failure must schedule the
        // first 1 h retry again, not inherit the exhausted count.
        let now = Date(timeIntervalSince1970: 50_000)
        let history = [
            entry("vscode", at: 40_000, outcome: .succeeded),
            entry("vscode", at: 30_000, outcome: .failed, retryCount: 3, nextRetryAt: nil),
        ]
        let state = UpgradeHistoryEntry.retryState(after: .failed, token: "vscode", history: history, now: now)
        XCTAssertEqual(state.retryCount, 1)
        XCTAssertEqual(state.nextRetryAt, now.addingTimeInterval(3600))
    }

    func testManualFailureContinuesBackoff() {
        // A manual failure after an automatic one must keep the retry
        // going with the next window instead of cancelling it.
        let now = Date(timeIntervalSince1970: 5_000)
        let history = [entry("vscode", at: 1_000, outcome: .failed, retryCount: 1, nextRetryAt: 4_600)]
        let state = UpgradeHistoryEntry.retryState(after: .failed, token: "vscode", history: history, now: now)
        XCTAssertEqual(state.retryCount, 2)
        XCTAssertEqual(state.nextRetryAt, now.addingTimeInterval(14_400))
    }
}
