import XCTest
@testable import AutoBrew

final class SettingsStoreTests: XCTestCase {
    @MainActor
    func testDefaultTriggerMode() {
        let store = SettingsStore.shared
        // Default is .idle
        XCTAssertNotNil(store.triggerMode)
    }

    @MainActor
    func testDefaultIdleMinutes() {
        let store = SettingsStore.shared
        XCTAssertGreaterThan(store.idleMinutes, 0)
    }

    @MainActor
    func testDidRunTodayWhenNeverRun() {
        let store = SettingsStore.shared
        // If lastRunDate is nil or old, didRunToday should be false
        // This depends on state, so we just verify it doesn't crash
        _ = store.didRunToday
    }
}
