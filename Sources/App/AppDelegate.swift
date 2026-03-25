import AppKit
import os

final class AppDelegate: NSObject, NSApplicationDelegate, Sendable {
    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "AppDelegate")

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        Task { @MainActor in
            await NotificationManager.shared.requestAuthorization()
            SchedulerService.shared.start()
            logger.info("AutoBrew started")
        }
    }
}
