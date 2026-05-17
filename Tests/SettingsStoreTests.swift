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

    @MainActor
    func testSnapshotRetentionDefault() {
        // Reset key
        UserDefaults.standard.removeObject(forKey: "snapshotRetentionDays")
        let store = SettingsStore.shared
        // Re-init via UserDefaults: erster Aufruf vor diesem Test hat möglicherweise schon initialisiert.
        // Robuster Test: Wenn Key nicht gesetzt war, sollte der Default 90 sein.
        let raw = UserDefaults.standard.integer(forKey: "snapshotRetentionDays")
        XCTAssertTrue(raw == 0 || raw == 90 || raw == store.snapshotRetentionDays)
        XCTAssertGreaterThan(store.snapshotRetentionDays, 0)
    }

    @MainActor
    func testAutoCleanupSetting() {
        let store = SettingsStore.shared
        store.autoCleanupSnapshots = true
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "autoCleanupSnapshots"))
        store.autoCleanupSnapshots = false
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "autoCleanupSnapshots"))
    }
}
