import Foundation
import SwiftUI

@Observable
@MainActor
final class SettingsStore {
    static let shared = SettingsStore()

    private let defaults = UserDefaults.standard

    var triggerMode: TriggerMode {
        get {
            guard let raw = defaults.string(forKey: "triggerMode"),
                  let mode = TriggerMode(rawValue: raw) else { return .idle }
            return mode
        }
        set { defaults.set(newValue.rawValue, forKey: "triggerMode") }
    }

    var idleMinutes: Int {
        get {
            let val = defaults.integer(forKey: "idleMinutes")
            return val > 0 ? val : 30
        }
        set { defaults.set(newValue, forKey: "idleMinutes") }
    }

    var scheduledHour: Int {
        get { defaults.integer(forKey: "scheduledHour") }
        set { defaults.set(newValue, forKey: "scheduledHour") }
    }

    var scheduledMinute: Int {
        get { defaults.integer(forKey: "scheduledMinute") }
        set { defaults.set(newValue, forKey: "scheduledMinute") }
    }

    var lastRunDate: Date? {
        get { defaults.object(forKey: "lastRunDate") as? Date }
        set { defaults.set(newValue, forKey: "lastRunDate") }
    }

    var loginItemEnabled: Bool {
        get { defaults.bool(forKey: "loginItemEnabled") }
        set { defaults.set(newValue, forKey: "loginItemEnabled") }
    }

    var showNotifications: Bool {
        get {
            if defaults.object(forKey: "showNotifications") == nil { return true }
            return defaults.bool(forKey: "showNotifications")
        }
        set { defaults.set(newValue, forKey: "showNotifications") }
    }

    var onboardingCompleted: Bool {
        get { defaults.bool(forKey: "onboardingCompleted") }
        set { defaults.set(newValue, forKey: "onboardingCompleted") }
    }

    var didRunToday: Bool {
        guard let last = lastRunDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    private init() {
        if defaults.object(forKey: "triggerMode") == nil {
            defaults.set(TriggerMode.idle.rawValue, forKey: "triggerMode")
        }
        if defaults.object(forKey: "scheduledHour") == nil {
            defaults.set(3, forKey: "scheduledHour")
        }
    }
}
