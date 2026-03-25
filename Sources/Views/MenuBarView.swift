import SwiftUI

struct MenuBarView: View {
    @State private var scheduler = SchedulerService.shared
    @State private var brewManager = BrewManager.shared
    @State private var settings = SettingsStore.shared
    @State private var showSettings = false
    @State private var showLog = false

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
                        Text("Last run: \(lastRun.formatted(.relative(presentation: .named)))")
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

            // Outdated packages
            if !brewManager.outdatedPackages.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(brewManager.outdatedPackages.count) outdated")
                        .font(.caption)
                        .foregroundStyle(.orange)
                    ForEach(brewManager.outdatedPackages.prefix(5)) { pkg in
                        HStack {
                            Text(pkg.name)
                                .font(.caption2)
                            Spacer()
                            Text("\(pkg.currentVersion) → \(pkg.newVersion)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    if brewManager.outdatedPackages.count > 5 {
                        Text("+ \(brewManager.outdatedPackages.count - 5) more...")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }

            Divider()

            Button {
                Task { await scheduler.triggerManualRun() }
            } label: {
                Label("Update Now", systemImage: "arrow.triangle.2.circlepath")
            }
            .disabled(brewManager.isRunning)

            Button {
                Task { await brewManager.fetchOutdated() }
            } label: {
                Label("Check for Updates", systemImage: "magnifyingglass")
            }
            .disabled(brewManager.isRunning)

            if !brewManager.lastOutput.isEmpty {
                Button {
                    showLog.toggle()
                } label: {
                    Label("Show Log", systemImage: "doc.text")
                }
            }

            Button {
                showSettings.toggle()
            } label: {
                Label("Settings...", systemImage: "gear")
            }

            Divider()

            HStack {
                if let path = brewManager.brewExecutable {
                    Text(path)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                } else {
                    Text("Homebrew not installed")
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
                Spacer()
            }

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Quit", systemImage: "power")
            }
        }
        .padding()
        .frame(width: 280)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showLog) {
            LogView(output: brewManager.lastOutput)
        }
        .task {
            await brewManager.fetchOutdated()
        }
    }

    @ViewBuilder
    private var statusBadge: some View {
        switch scheduler.state {
        case .running:
            HStack(spacing: 4) {
                ProgressView()
                    .controlSize(.mini)
                Text("Running")
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
            Label("Ready", systemImage: "checkmark")
        case .waitingForIdle:
            Label("Waiting for idle...", systemImage: "hourglass")
        case .waitingForSchedule:
            Label("Scheduled: \(formattedSchedule)", systemImage: "calendar.badge.clock")
        case .running(let stage):
            Label(stage.rawValue, systemImage: "arrow.triangle.2.circlepath")
                .foregroundStyle(.orange)
        case .completed(let date):
            Label("Completed \(date.formatted(date: .omitted, time: .shortened))", systemImage: "checkmark.circle")
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
            "After \(settings.idleMinutes) min idle"
        case .scheduled:
            "Daily at \(formattedSchedule)"
        }
    }

    private var formattedSchedule: String {
        String(format: "%02d:%02d", settings.scheduledHour, settings.scheduledMinute)
    }
}
