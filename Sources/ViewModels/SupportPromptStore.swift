// Sources/ViewModels/SupportPromptStore.swift
import Foundation
import Observation

@Observable
@MainActor
final class SupportPromptStore {

    static let shared = SupportPromptStore()

    private enum Keys {
        static let installDate = "supportPrompt.installDate"
        static let dismissedStages = "supportPrompt.dismissedStages"
        static let userHasSupported = "supportPrompt.userHasSupported"
    }

    private let defaults: UserDefaults
    private let now: () -> Date

    private(set) var installDate: Date?
    private(set) var dismissedStages: Set<SupportStage>
    private(set) var userHasSupported: Bool

    init(defaults: UserDefaults = .standard, now: @escaping () -> Date = Date.init) {
        self.defaults = defaults
        self.now = now
        self.installDate = defaults.object(forKey: Keys.installDate) as? Date
        let raw = defaults.stringArray(forKey: Keys.dismissedStages) ?? []
        self.dismissedStages = Set(raw.compactMap { SupportStage(rawValue: $0) })
        self.userHasSupported = defaults.bool(forKey: Keys.userHasSupported)
    }

    func ensureInstallDate() {
        guard installDate == nil else { return }
        let date = now()
        installDate = date
        defaults.set(date, forKey: Keys.installDate)
    }

    var pendingStage: SupportStage? {
        guard !userHasSupported, let installDate else { return nil }
        let days = Calendar.current.dateComponents([.day], from: installDate, to: now()).day ?? 0
        if days >= SupportStage.quarter.thresholdDays {
            return dismissedStages.contains(.quarter) ? nil : .quarter
        }
        if days >= SupportStage.week.thresholdDays {
            return dismissedStages.contains(.week) ? nil : .week
        }
        return nil
    }

    func dismiss(_ stage: SupportStage) {
        dismissedStages.insert(stage)
        persistDismissed()
    }

    func markAsSupporter() {
        userHasSupported = true
        defaults.set(true, forKey: Keys.userHasSupported)
    }

    private func persistDismissed() {
        let raw = dismissedStages.map(\.rawValue).sorted()
        defaults.set(raw, forKey: Keys.dismissedStages)
    }
}
