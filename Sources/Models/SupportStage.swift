// Sources/Models/SupportStage.swift
import Foundation

enum SupportStage: String, CaseIterable, Sendable, Identifiable {
    case week
    case quarter

    var id: String { rawValue }

    /// Tage seit Installation, nach denen diese Stage fällig wird.
    var thresholdDays: Int {
        switch self {
        case .week: return 7
        case .quarter: return 90
        }
    }
}

enum SupportLinks {
    static let starURL = URL(string: "https://github.com/marcelrgberger/auto-brew")!
    static let sponsorURL = URL(string: "https://github.com/sponsors/marcelrgberger")!
}
