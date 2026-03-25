import Foundation
import UserNotifications
import os

@MainActor
final class NotificationManager: NSObject, @unchecked Sendable, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "Notifications")
    private let center = UNUserNotificationCenter.current()

    private nonisolated(unsafe) static let missedRunCategory = "MISSED_RUN"
    private nonisolated(unsafe) static let runNowAction = "RUN_NOW"
    private nonisolated(unsafe) static let skipAction = "SKIP"

    var onRunNowRequested: (@MainActor () -> Void)?

    override private init() {
        super.init()
        center.delegate = self

        let runAction = UNNotificationAction(
            identifier: Self.runNowAction,
            title: "Jetzt aktualisieren",
            options: .foreground
        )
        let skipAction = UNNotificationAction(
            identifier: Self.skipAction,
            title: "Überspringen",
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
        content.body = "Das geplante Brew-Update konnte nicht ausgeführt werden. Soll es jetzt im Hintergrund laufen?"
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
            ? "Alle Homebrew-Pakete wurden aktualisiert."
            : "Update fehlgeschlagen: \(detail ?? "Unbekannter Fehler")"
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
