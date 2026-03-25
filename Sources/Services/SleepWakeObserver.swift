import Foundation
import AppKit
import os

@Observable
@MainActor
final class SleepWakeObserver {
    private(set) var lastSleepDate: Date?
    private(set) var missedRun = false

    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "SleepWake")
    private let settings = SettingsStore.shared

    private var sleepObserverToken: NSObjectProtocol?
    private var wakeObserverToken: NSObjectProtocol?

    var onWakeWithMissedRun: (@MainActor () -> Void)?

    func startObserving() {
        // Remove existing observers to prevent duplicates
        stopObserving()

        let center = NSWorkspace.shared.notificationCenter

        sleepObserverToken = center.addObserver(
            forName: NSWorkspace.willSleepNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleSleep()
            }
        }

        wakeObserverToken = center.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleWake()
            }
        }

        logger.info("Sleep/Wake observer started")
    }

    func stopObserving() {
        let center = NSWorkspace.shared.notificationCenter
        if let token = sleepObserverToken {
            center.removeObserver(token)
            sleepObserverToken = nil
        }
        if let token = wakeObserverToken {
            center.removeObserver(token)
            wakeObserverToken = nil
        }
    }

    private func handleSleep() {
        lastSleepDate = Date()
        logger.info("System going to sleep")
    }

    private func handleWake() {
        logger.info("System woke up")

        guard !settings.didRunToday else {
            logger.info("Already ran today, skipping missed-run check")
            return
        }

        let didMiss: Bool
        switch settings.triggerMode {
        case .scheduled:
            didMiss = checkMissedScheduledRun()
        case .idle:
            didMiss = true
        }

        if didMiss {
            missedRun = true
            logger.info("Missed run detected, notifying user")
            onWakeWithMissedRun?()
        }
    }

    private func checkMissedScheduledRun() -> Bool {
        guard let sleepDate = lastSleepDate else { return false }

        let calendar = Calendar.current
        var scheduled = calendar.dateComponents([.year, .month, .day], from: Date())
        scheduled.hour = settings.scheduledHour
        scheduled.minute = settings.scheduledMinute

        guard let scheduledDate = calendar.date(from: scheduled) else { return false }

        return sleepDate < scheduledDate && scheduledDate < Date()
    }

    func clearMissedRun() {
        missedRun = false
    }
}
