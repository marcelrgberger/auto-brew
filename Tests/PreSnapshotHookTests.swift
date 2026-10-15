import XCTest
@testable import AutoBrew

@MainActor
final class PreSnapshotHookTests: XCTestCase {
    func testReportsExitStatus() async {
        let result = await PreUpgradeSnapshot.runHook(command: "exit 3", timeout: 10)
        XCTAssertEqual(result, .exited(3))
    }

    func testSuccessfulCommandExitsZero() async {
        let result = await PreUpgradeSnapshot.runHook(command: "true", timeout: 10)
        XCTAssertEqual(result, .exited(0))
    }

    func testHungCommandIsTerminatedAtTimeout() async {
        let start = Date()
        let result = await PreUpgradeSnapshot.runHook(command: "sleep 30", timeout: 0.5)
        XCTAssertEqual(result, .timedOut)
        XCTAssertLessThan(Date().timeIntervalSince(start), 5, "The timeout must not wait for the command to finish")
    }

    func testTimeoutStopsCommandsThatIgnoreSigtermIncludingChildren() async throws {
        // The shell ignores SIGTERM and starts a child; after the grace
        // period the whole group must be gone.
        let marker = FileManager.default.temporaryDirectory
            .appendingPathComponent("autobrew-hook-\(UUID().uuidString)")
        let command = "trap '' TERM; (sleep 3; touch '\(marker.path)') & sleep 30"
        let result = await PreUpgradeSnapshot.runHook(command: command, timeout: 0.3, killGrace: 0.3)
        XCTAssertEqual(result, .timedOut)
        try await Task.sleep(for: .seconds(4))
        XCTAssertFalse(FileManager.default.fileExists(atPath: marker.path),
                       "A child of the hook kept running after the timeout")
        try? FileManager.default.removeItem(at: marker)
    }

    func testLargeOutputDoesNotBlock() async {
        // Far more than a pipe buffer; must not stall the command.
        let result = await PreUpgradeSnapshot.runHook(command: "head -c 2000000 /dev/zero; head -c 2000000 /dev/zero >&2", timeout: 10)
        XCTAssertEqual(result, .exited(0))
    }

    func testBackgroundChildDoesNotDelayCompletion() async {
        // The shell exits right away while a child keeps running; the hook
        // must return on the shell's exit, not when the child ends.
        let start = Date()
        let result = await PreUpgradeSnapshot.runHook(command: "sleep 20 & exit 0", timeout: 10)
        XCTAssertEqual(result, .exited(0))
        XCTAssertLessThan(Date().timeIntervalSince(start), 5)
    }
}
