import SwiftUI

enum MenuPage: Equatable {
    case main
    case settings
    case log
}

struct MenuBarView: View {
    @State private var scheduler = SchedulerService.shared
    @State private var brewManager = BrewManager.shared
    @State private var settings = SettingsStore.shared
    @State private var currentPage: MenuPage = .main

    @State private var needsOnboarding: Bool = !BrewManager.shared.isHomebrewInstalled

    var body: some View {
        Group {
            if needsOnboarding {
                OnboardingView {
                    needsOnboarding = false
                    scheduler.start()
                }
                .transition(.opacity)
            } else {
                switch currentPage {
                case .main:
                    mainView
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                case .settings:
                    SettingsView(onBack: { currentPage = .main })
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                case .log:
                    LogView(output: brewManager.lastOutput, onBack: { currentPage = .main })
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                }
            }
        }
        .animation(.spring(duration: 0.3, bounce: 0.15), value: currentPage)
        .animation(.easeInOut(duration: 0.3), value: needsOnboarding)
    }

    private var mainView: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with subtle pulse on mug icon when running
            HStack {
                Image(systemName: "mug.fill")
                    .foregroundStyle(.brown)
                    .symbolEffect(.pulse, isActive: brewManager.isRunning)
                Text("AutoBrew")
                    .font(.headline)
                Spacer()
                statusBadge
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                statusRow
                    .contentTransition(.numericText())

                if let lastRun = settings.lastRunDate {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundStyle(.secondary)
                        Text("Last run: \(lastRun.formatted(.relative(presentation: .named)))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .transition(.push(from: .bottom))
                }

                HStack {
                    Image(systemName: settings.triggerMode == .idle ? "hourglass" : "calendar.badge.clock")
                        .foregroundStyle(.secondary)
                        .contentTransition(.symbolEffect(.replace))
                    Text(triggerDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .contentTransition(.numericText())
                }
            }
            .animation(.easeInOut(duration: 0.3), value: scheduler.state)

            // Outdated packages with staggered appearance
            if !brewManager.outdatedPackages.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(brewManager.outdatedPackages.count) outdated")
                            .font(.caption)
                            .foregroundStyle(.orange)
                            .contentTransition(.numericText())
                        Spacer()
                    }
                    ForEach(Array(brewManager.outdatedPackages.prefix(5).enumerated()), id: \.element.id) { index, pkg in
                        HStack {
                            Text(pkg.name)
                                .font(.caption2)
                            Spacer()
                            Text("\(pkg.currentVersion) → \(pkg.newVersion)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .transition(.push(from: .bottom).combined(with: .opacity))
                    }
                    if brewManager.outdatedPackages.count > 5 {
                        Text("+ \(brewManager.outdatedPackages.count - 5) more...")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            Divider()

            // Update button with bounce on press
            Button {
                Task { await scheduler.triggerManualRun() }
            } label: {
                HStack {
                    Spacer()
                    if brewManager.isRunning {
                        ProgressView()
                            .controlSize(.small)
                            .transition(.scale.combined(with: .opacity))
                    }
                    Label(
                        brewManager.isRunning ? "Updating..." : "Update Now",
                        systemImage: "arrow.triangle.2.circlepath"
                    )
                    .font(.system(.body, weight: .semibold))
                    .symbolEffect(.rotate, isActive: brewManager.isRunning)
                    Spacer()
                }
                .padding(.vertical, 6)
                .animation(.easeInOut(duration: 0.2), value: brewManager.isRunning)
            }
            .buttonStyle(.borderedProminent)
            .tint(brewManager.isRunning ? .orange : .accentColor)
            .disabled(brewManager.isRunning)
            .animation(.easeInOut(duration: 0.3), value: brewManager.isRunning)

            Button {
                Task { await brewManager.fetchOutdated() }
            } label: {
                Label("Check for Updates", systemImage: "magnifyingglass")
            }
            .disabled(brewManager.isRunning)

            if !brewManager.lastOutput.isEmpty {
                Button {
                    currentPage = .log
                } label: {
                    Label("Show Log", systemImage: "doc.text")
                }
                .transition(.push(from: .bottom).combined(with: .opacity))
            }

            Button {
                currentPage = .settings
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
                        .symbolEffect(.pulse)
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
            .transition(.scale.combined(with: .opacity))
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .symbolEffect(.bounce, value: scheduler.state)
                .transition(.scale.combined(with: .opacity))
        case .failed:
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
                .symbolEffect(.bounce, value: scheduler.state)
                .transition(.scale.combined(with: .opacity))
        default:
            Image(systemName: "circle.fill")
                .foregroundStyle(.secondary)
                .font(.caption2)
                .transition(.opacity)
        }
    }

    @ViewBuilder
    private var statusRow: some View {
        switch scheduler.state {
        case .idle:
            Label("Ready", systemImage: "checkmark")
        case .waitingForIdle:
            Label("Waiting for idle...", systemImage: "hourglass")
                .symbolEffect(.variableColor.iterative, isActive: true)
        case .waitingForSchedule:
            Label("Scheduled: \(formattedSchedule)", systemImage: "calendar.badge.clock")
        case .running(let stage):
            Label(stage.rawValue, systemImage: "arrow.triangle.2.circlepath")
                .foregroundStyle(.orange)
                .symbolEffect(.rotate, isActive: true)
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
