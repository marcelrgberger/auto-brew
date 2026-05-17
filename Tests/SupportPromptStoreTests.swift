// Tests/SupportPromptStoreTests.swift
import XCTest
@testable import AutoBrew

final class SupportPromptStoreTests: XCTestCase {

    // MARK: - Helpers

    private func isolatedDefaults() -> UserDefaults {
        let name = "SupportPromptStoreTests.\(UUID().uuidString)"
        let d = UserDefaults(suiteName: name)!
        d.removePersistentDomain(forName: name)
        return d
    }

    @MainActor
    private func makeStore(
        defaults: UserDefaults,
        nowOffsetDays: Int = 0,
        baseDate: Date = Date(timeIntervalSince1970: 1_700_000_000)
    ) -> SupportPromptStore {
        let now = baseDate.addingTimeInterval(TimeInterval(nowOffsetDays) * 86_400)
        return SupportPromptStore(defaults: defaults, now: { now })
    }

    // MARK: - ensureInstallDate

    @MainActor
    func test_ensureInstallDate_setsDateOnFirstCall() {
        let defaults = isolatedDefaults()
        let store = makeStore(defaults: defaults)
        XCTAssertNil(store.installDate)

        store.ensureInstallDate()

        XCTAssertNotNil(store.installDate)
    }

    @MainActor
    func test_ensureInstallDate_doesNotOverwrite() {
        let defaults = isolatedDefaults()
        let store1 = makeStore(defaults: defaults, nowOffsetDays: 0)
        store1.ensureInstallDate()
        let firstDate = store1.installDate

        let store2 = makeStore(defaults: defaults, nowOffsetDays: 5)
        store2.ensureInstallDate()

        XCTAssertEqual(store2.installDate, firstDate)
    }

    // MARK: - pendingStage

    @MainActor
    func test_pendingStage_isNilImmediatelyAfterInstall() {
        let defaults = isolatedDefaults()
        let store = makeStore(defaults: defaults, nowOffsetDays: 0)
        store.ensureInstallDate()

        XCTAssertNil(store.pendingStage)
    }

    @MainActor
    func test_pendingStage_isWeekAfterSevenDays() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let later = makeStore(defaults: defaults, nowOffsetDays: 7)

        XCTAssertEqual(later.pendingStage, .week)
    }

    @MainActor
    func test_pendingStage_isQuarterAfterNinetyDays() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()
        installer.dismiss(.week)

        let later = makeStore(defaults: defaults, nowOffsetDays: 90)

        XCTAssertEqual(later.pendingStage, .quarter)
    }

    @MainActor
    func test_pendingStage_prefersQuarterOverWeekWhenBothDue() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let later = makeStore(defaults: defaults, nowOffsetDays: 100)

        XCTAssertEqual(later.pendingStage, .quarter)
    }

    @MainActor
    func test_pendingStage_isNilAfterMarkAsSupporter() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let later = makeStore(defaults: defaults, nowOffsetDays: 200)
        later.markAsSupporter()

        XCTAssertNil(later.pendingStage)
    }

    @MainActor
    func test_pendingStage_isNilAfterDismissingWeek_untilQuarter() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let weekTime = makeStore(defaults: defaults, nowOffsetDays: 7)
        weekTime.dismiss(.week)
        XCTAssertNil(weekTime.pendingStage)

        let day89 = makeStore(defaults: defaults, nowOffsetDays: 89)
        XCTAssertNil(day89.pendingStage)

        let day90 = makeStore(defaults: defaults, nowOffsetDays: 90)
        XCTAssertEqual(day90.pendingStage, .quarter)
    }

    @MainActor
    func test_pendingStage_isNilAfterDismissingQuarter() {
        let defaults = isolatedDefaults()
        let installer = makeStore(defaults: defaults, nowOffsetDays: 0)
        installer.ensureInstallDate()

        let later = makeStore(defaults: defaults, nowOffsetDays: 91)
        later.dismiss(.quarter)

        XCTAssertNil(later.pendingStage)
    }

    @MainActor
    func test_pendingStage_isNilWhenInstallDateMissing() {
        let defaults = isolatedDefaults()
        let store = makeStore(defaults: defaults, nowOffsetDays: 0)
        // ensureInstallDate wurde NICHT aufgerufen
        XCTAssertNil(store.pendingStage)
    }

    // MARK: - persistence

    @MainActor
    func test_dismissedStages_persistAcrossInstances() {
        let defaults = isolatedDefaults()
        let s1 = makeStore(defaults: defaults, nowOffsetDays: 0)
        s1.ensureInstallDate()
        s1.dismiss(.week)

        let s2 = makeStore(defaults: defaults, nowOffsetDays: 10)
        XCTAssertNil(s2.pendingStage) // .week dismissed, .quarter noch nicht fällig
    }

    @MainActor
    func test_userHasSupported_persistsAcrossInstances() {
        let defaults = isolatedDefaults()
        let s1 = makeStore(defaults: defaults, nowOffsetDays: 0)
        s1.ensureInstallDate()
        s1.markAsSupporter()

        let s2 = makeStore(defaults: defaults, nowOffsetDays: 200)
        XCTAssertTrue(s2.userHasSupported)
        XCTAssertNil(s2.pendingStage)
    }
}
