import SwiftUI

struct MenuBarIcon: View {
    let state: SchedulerState

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: iconName)
                .symbolRenderingMode(.hierarchical)
            if let badge = badgeIcon {
                Image(systemName: badge)
                    .font(.system(size: 7, weight: .bold))
            }
        }
    }

    private var iconName: String {
        switch state {
        case .running:
            "mug.fill"
        case .completed:
            "mug.fill"
        case .failed:
            "mug.fill"
        default:
            "mug.fill"
        }
    }

    private var badgeIcon: String? {
        switch state {
        case .running:
            "arrow.triangle.2.circlepath"
        case .completed:
            "checkmark"
        case .failed:
            "exclamationmark"
        default:
            nil
        }
    }
}
