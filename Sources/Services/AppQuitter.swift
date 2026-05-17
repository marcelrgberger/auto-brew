import AppKit
import Foundation

@MainActor
enum AppQuitter {
    private static let pollIntervalMilliseconds: Int = 200
    private static let defaultTimeoutSeconds: TimeInterval = 5.0

    static func quit(bundleID: String, timeout: TimeInterval = defaultTimeoutSeconds) async throws {
        let running = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
        guard !running.isEmpty else { return }
        for app in running {
            app.terminate()
        }

        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            let still = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
            if still.isEmpty { return }
            try await Task.sleep(for: .milliseconds(pollIntervalMilliseconds))
        }
        for app in NSRunningApplication.runningApplications(withBundleIdentifier: bundleID) {
            _ = app.forceTerminate()
        }
    }
}
