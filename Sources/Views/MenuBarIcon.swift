import SwiftUI

struct MenuBarIcon: View {
    let state: SchedulerState

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "mug.fill")
                .symbolRenderingMode(.hierarchical)
            if let badge = badgeIcon {
                Image(systemName: badge)
                    .font(.system(size: 7, weight: .bold))
            }
        }
        .accessibilityLabel("AutoBrew")
        .accessibilityValue(accessibilityStatus)
    }

    private var badgeIcon: String? {
        switch state {
        case .running: "arrow.triangle.2.circlepath"
        case .completed: "checkmark"
        case .failed: "exclamationmark"
        default: nil
        }
    }

    private var accessibilityStatus: String {
        switch state {
        case .idle: "Idle"
        case .waitingForIdle: "Waiting for idle"
        case .waitingForSchedule: "Waiting for scheduled time"
        case .running: "Updating packages"
        case .completed: "Update completed"
        case .failed: "Update failed"
        }
    }
}
