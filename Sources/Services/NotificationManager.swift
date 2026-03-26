import Foundation
import UserNotifications
import os

@MainActor
final class NotificationManager: NSObject, @unchecked Sendable, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "Notifications")
    private let center = UNUserNotificationCenter.current()

    nonisolated private static let missedRunCategory = "MISSED_RUN"
    nonisolated private static let runNowAction = "RUN_NOW"
    nonisolated private static let skipAction = "SKIP"

    var onRunNowRequested: (@MainActor () -> Void)?

    override private init() {
        super.init()
        center.delegate = self

        let runAction = UNNotificationAction(
            identifier: Self.runNowAction,
            title: String(localized: "Update Now"),
            options: .foreground
        )
        let skipAction = UNNotificationAction(
            identifier: Self.skipAction,
            title: String(localized: "Skip"),
            options: .destructive
        )
        let category = UNNotificationCategory(
            identifier: Self.missedRunCategory,
            actions: [runAction, skipAction],
            intentIdentifiers: []
        )
        center.setNotificationCategories([category])
    }

    func requestAuthorization() async {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            logger.info("Notification authorization: \(granted)")
        } catch {
            logger.error("Notification authorization failed: \(error.localizedDescription)")
        }
    }

    func showMissedRunNotification() {
        let content = UNMutableNotificationContent()
        content.title = "AutoBrew"
        content.body = String(localized: "The scheduled brew update was missed. Run it now in the background?")
        content.sound = .default
        content.categoryIdentifier = Self.missedRunCategory

        let request = UNNotificationRequest(
            identifier: "missed-run-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil
        )

        center.add(request) { [weak self] error in
            if let error {
                self?.logger.error("Failed to show notification: \(error.localizedDescription)")
            }
        }
    }

    func showCompletionNotification(success: Bool, detail: String? = nil) {
        let content = UNMutableNotificationContent()
        content.title = "AutoBrew"
        content.body = success
            ? String(localized: "All Homebrew packages have been updated.")
            : String(localized: "Update failed: \(detail ?? "Unknown error")")
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "completion-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil
        )
        center.add(request)
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if response.actionIdentifier == Self.runNowAction {
            Task { @MainActor in
                onRunNowRequested?()
            }
        }
        completionHandler()
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
