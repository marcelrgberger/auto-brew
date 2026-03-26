import Foundation
import os

@Observable
@MainActor
final class SchedulerService {
    static let shared = SchedulerService()

    private(set) var state: SchedulerState = .idle

    private let settings = SettingsStore.shared
    private let brewManager = BrewManager.shared
    private let sleepWakeObserver = SleepWakeObserver()
    private let notificationManager = NotificationManager.shared
    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "Scheduler")

    private var pollingTask: Task<Void, Never>?
    private var scheduledTask: Task<Void, Never>?

    var lastRunDate: Date? { settings.lastRunDate }
    var isRunning: Bool { brewManager.isRunning }
    var currentStage: BrewStage? { brewManager.currentStage }

    func start() {
        logger.info("Scheduler starting with mode: \(self.settings.triggerMode.rawValue)")

        sleepWakeObserver.onWakeWithMissedRun = { [weak self] in
            self?.handleMissedRun()
        }
        sleepWakeObserver.startObserving()

        notificationManager.onRunNowRequested = { [weak self] in
            Task { @MainActor in
                await self?.triggerManualRun()
            }
        }

        restartScheduling()
    }

    func restartScheduling() {
        pollingTask?.cancel()
        scheduledTask?.cancel()

        switch settings.triggerMode {
        case .idle:
            state = .waitingForIdle
            startIdlePolling()
        case .scheduled:
            state = .waitingForSchedule
            startScheduledTimer()
        }
    }

    func triggerManualRun() async {
        await runBrewUpdate()
    }

    // MARK: - Idle Mode

    private func startIdlePolling() {
        pollingTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                guard !Task.isCancelled else { break }
                await self?.checkIdleAndRun()
            }
        }
    }

    private func checkIdleAndRun() async {
        guard !settings.didRunToday, !brewManager.isRunning else { return }

        guard let idleSeconds = IdleDetector.systemIdleTime() else {
            logger.warning("Could not read idle time")
            return
        }

        let requiredSeconds = TimeInterval(settings.idleMinutes * 60)
        if idleSeconds >= requiredSeconds {
            logger.info("Idle threshold reached (\(Int(idleSeconds))s >= \(Int(requiredSeconds))s)")
            await runBrewUpdate()
        }
    }

    // MARK: - Scheduled Mode

    private func startScheduledTimer() {
        scheduledTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { break }
                guard let delay = self.secondsUntilNextRun() else {
                    try? await Task.sleep(for: .seconds(60))
                    continue
                }

                self.logger.info("Next scheduled run in \(Int(delay)) seconds")

                if delay > 0 {
                    try? await Task.sleep(for: .seconds(delay))
                }
                guard !Task.isCancelled else { break }

                if !self.settings.didRunToday {
                    await self.runBrewUpdate()
                }

                try? await Task.sleep(for: .seconds(3600))
            }
        }
    }

    private func secondsUntilNextRun() -> TimeInterval? {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = settings.scheduledHour
        components.minute = settings.scheduledMinute

        guard var target = calendar.date(from: components) else { return nil }

        if target <= now {
            guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: target) else { return nil }
            target = tomorrow
        }

        return target.timeIntervalSince(now)
    }

    // MARK: - Brew Execution

    private func runBrewUpdate() async {
        guard !brewManager.isRunning else { return }

        guard brewManager.isHomebrewInstalled else {
            state = .failed("Homebrew not installed")
            logger.warning("Brew update skipped — Homebrew not installed")
            return
        }

        do {
            state = .running(.updating)
            try await brewManager.runFullUpdate()
            settings.lastRunDate = Date()
            // Mirror the final stage from BrewManager
            if let stage = brewManager.currentStage {
                state = .running(stage)
            }
            state = .completed(Date())
            sleepWakeObserver.clearMissedRun()
            if settings.showNotifications {
                notificationManager.showCompletionNotification(success: true)
            }
            logger.info("Brew update completed successfully")
        } catch {
            state = .failed(error.localizedDescription)
            if settings.showNotifications {
                notificationManager.showCompletionNotification(success: false, detail: error.localizedDescription)
            }
            logger.error("Brew update failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Missed Run

    private func handleMissedRun() {
        guard settings.showNotifications else {
            Task { await triggerManualRun() }
            return
        }
        notificationManager.showMissedRunNotification()
    }

    private init() {}
}
