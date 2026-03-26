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
            // Only treat as missed if we slept long enough that an idle run was due
            if let sleepDate = lastSleepDate {
                let sleepDuration = Date().timeIntervalSince(sleepDate)
                didMiss = sleepDuration >= TimeInterval(settings.idleMinutes * 60)
            } else {
                didMiss = false
            }
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
        let now = Date()

        // Check today's scheduled time
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
        todayComponents.hour = settings.scheduledHour
        todayComponents.minute = settings.scheduledMinute

        if let todayScheduled = calendar.date(from: todayComponents),
           sleepDate < todayScheduled && todayScheduled < now {
            return true
        }

        // Check yesterday's scheduled time (overnight sleep)
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now) {
            var yesterdayComponents = calendar.dateComponents([.year, .month, .day], from: yesterday)
            yesterdayComponents.hour = settings.scheduledHour
            yesterdayComponents.minute = settings.scheduledMinute

            if let yesterdayScheduled = calendar.date(from: yesterdayComponents),
               sleepDate < yesterdayScheduled && yesterdayScheduled < now {
                return true
            }
        }

        return false
    }

    func clearMissedRun() {
        missedRun = false
    }
}
