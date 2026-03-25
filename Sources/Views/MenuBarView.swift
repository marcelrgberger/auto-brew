import SwiftUI

struct MenuBarView: View {
    @State private var scheduler = SchedulerService.shared
    @State private var brewManager = BrewManager.shared
    @State private var settings = SettingsStore.shared
    @State private var showSettings = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "mug.fill")
                    .foregroundStyle(.brown)
                Text("AutoBrew")
                    .font(.headline)
                Spacer()
                statusBadge
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                statusRow

                if let lastRun = settings.lastRunDate {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundStyle(.secondary)
                        Text("Letzter Lauf: \(lastRun.formatted(.relative(presentation: .named)))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack {
                    Image(systemName: settings.triggerMode == .idle ? "hourglass" : "calendar.badge.clock")
                        .foregroundStyle(.secondary)
                    Text(triggerDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            Button {
                Task { await scheduler.triggerManualRun() }
            } label: {
                Label("Jetzt aktualisieren", systemImage: "arrow.triangle.2.circlepath")
            }
            .disabled(brewManager.isRunning)

            Button {
                showSettings.toggle()
            } label: {
                Label("Einstellungen...", systemImage: "gear")
            }

            Divider()

            HStack {
                if let path = brewManager.brewExecutable {
                    Text(path)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                } else {
                    Text("Homebrew nicht installiert")
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
                Spacer()
            }

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Beenden", systemImage: "power")
            }
        }
        .padding()
        .frame(width: 280)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    @ViewBuilder
    private var statusBadge: some View {
        switch scheduler.state {
        case .running:
            HStack(spacing: 4) {
                ProgressView()
                    .controlSize(.mini)
                Text("Läuft")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        case .failed:
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
        default:
            Image(systemName: "circle.fill")
                .foregroundStyle(.secondary)
                .font(.caption2)
        }
    }

    @ViewBuilder
    private var statusRow: some View {
        switch scheduler.state {
        case .idle:
            Label("Bereit", systemImage: "checkmark")
        case .waitingForIdle:
            Label("Warte auf Leerlauf...", systemImage: "hourglass")
        case .waitingForSchedule:
            Label("Geplanter Lauf: \(formattedSchedule)", systemImage: "calendar.badge.clock")
        case .running(let stage):
            Label(stage.rawValue, systemImage: "arrow.triangle.2.circlepath")
                .foregroundStyle(.orange)
        case .completed(let date):
            Label("Abgeschlossen \(date.formatted(date: .omitted, time: .shortened))", systemImage: "checkmark.circle")
                .foregroundStyle(.green)
        case .failed(let msg):
            Label(msg, systemImage: "exclamationmark.triangle")
                .foregroundStyle(.red)
                .lineLimit(2)
                .font(.caption)
        }
    }

    private var triggerDescription: String {
        switch settings.triggerMode {
        case .idle:
            "Nach \(settings.idleMinutes) Min. Leerlauf"
        case .scheduled:
            "Täglich um \(formattedSchedule)"
        }
    }

    private var formattedSchedule: String {
        String(format: "%02d:%02d", settings.scheduledHour, settings.scheduledMinute)
    }
}
