import Foundation
import SwiftUI

@Observable
@MainActor
final class SettingsStore {
    static let shared = SettingsStore()

    private let defaults = UserDefaults.standard

    var triggerMode: TriggerMode {
        didSet { defaults.set(triggerMode.rawValue, forKey: "triggerMode") }
    }

    var idleMinutes: Int {
        didSet { defaults.set(idleMinutes, forKey: "idleMinutes") }
    }

    var scheduledHour: Int {
        didSet { defaults.set(scheduledHour, forKey: "scheduledHour") }
    }

    var scheduledMinute: Int {
        didSet { defaults.set(scheduledMinute, forKey: "scheduledMinute") }
    }

    var lastRunDate: Date? {
        didSet { defaults.set(lastRunDate, forKey: "lastRunDate") }
    }

    var loginItemEnabled: Bool {
        didSet { defaults.set(loginItemEnabled, forKey: "loginItemEnabled") }
    }

    var showNotifications: Bool {
        didSet { defaults.set(showNotifications, forKey: "showNotifications") }
    }

    var onboardingCompleted: Bool {
        didSet { defaults.set(onboardingCompleted, forKey: "onboardingCompleted") }
    }

    var didRunToday: Bool {
        guard let last = lastRunDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    private init() {
        let d = UserDefaults.standard

        if let raw = d.string(forKey: "triggerMode"),
           let mode = TriggerMode(rawValue: raw) {
            triggerMode = mode
        } else {
            triggerMode = .idle
        }

        let idle = d.integer(forKey: "idleMinutes")
        idleMinutes = idle > 0 ? idle : 30

        if d.object(forKey: "scheduledHour") != nil {
            scheduledHour = d.integer(forKey: "scheduledHour")
        } else {
            scheduledHour = 3
        }

        scheduledMinute = d.integer(forKey: "scheduledMinute")

        lastRunDate = d.object(forKey: "lastRunDate") as? Date
        loginItemEnabled = d.bool(forKey: "loginItemEnabled")

        if d.object(forKey: "showNotifications") != nil {
            showNotifications = d.bool(forKey: "showNotifications")
        } else {
            showNotifications = true
        }

        onboardingCompleted = d.bool(forKey: "onboardingCompleted")
    }
}
