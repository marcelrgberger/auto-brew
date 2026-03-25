import SwiftUI

struct SettingsView: View {
    @State private var settings = SettingsStore.shared
    @State private var scheduler = SchedulerService.shared
    @State private var brewManager = BrewManager.shared
    var onBack: () -> Void

    var body: some View {
        ScrollView {
            HStack {
                Button(action: onBack) {
                    Label("Back", systemImage: "chevron.left")
                }
                .buttonStyle(.plain)
                Spacer()
                Text("Settings")
                    .font(.headline)
                Spacer()
                Color.clear.frame(width: 44, height: 1)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .padding(.bottom, 4)

            Divider()

            Form {
                Section("Update Trigger") {
                    Picker("Mode", selection: Binding(
                        get: { settings.triggerMode },
                        set: {
                            settings.triggerMode = $0
                            scheduler.restartScheduling()
                        }
                    )) {
                        Text("After Idle").tag(TriggerMode.idle)
                        Text("Scheduled Time").tag(TriggerMode.scheduled)
                    }
                    .pickerStyle(.segmented)

                    if settings.triggerMode == .idle {
                        HStack {
                            Text("Idle Duration")
                            Spacer()
                            Stepper(
                                "\(settings.idleMinutes) min",
                                value: Binding(
                                    get: { settings.idleMinutes },
                                    set: { settings.idleMinutes = $0 }
                                ),
                                in: 5...120,
                                step: 5
                            )
                        }
                    } else {
                        DatePicker(
                            "Time",
                            selection: scheduledTimeBinding,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: scheduledTimeBinding.wrappedValue) {
                            scheduler.restartScheduling()
                        }
                    }
                }

                Section("General") {
                    Toggle("Launch at Login", isOn: Binding(
                        get: { settings.loginItemEnabled },
                        set: {
                            settings.loginItemEnabled = $0
                            LoginItemManager.setEnabled($0)
                        }
                    ))

                    Toggle("Show Notifications", isOn: Binding(
                        get: { settings.showNotifications },
                        set: { settings.showNotifications = $0 }
                    ))
                }

                Section("Homebrew") {
                    HStack {
                        Text("Status")
                        Spacer()
                        if brewManager.isHomebrewInstalled {
                            Label("Installed", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else {
                            Label("Not Found", systemImage: "xmark.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }

                    if let path = brewManager.brewExecutable {
                        HStack {
                            Text("Path")
                            Spacer()
                            Text(path)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Marcel R. G. Berger")
                            .foregroundStyle(.secondary)
                    }
                    Link(destination: URL(string: "https://github.com/sponsors/marcelrgberger")!) {
                        HStack {
                            Label("Support this Project", systemImage: "heart")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Link(destination: URL(string: "https://github.com/marcelrgberger/auto-brew")!) {
                        HStack {
                            Label("Source Code", systemImage: "chevron.left.forwardslash.chevron.right")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .formStyle(.grouped)
        }
        .frame(maxWidth: 320, maxHeight: 460)
    }

    private var scheduledTimeBinding: Binding<Date> {
        Binding(
            get: {
                var comps = DateComponents()
                comps.hour = settings.scheduledHour
                comps.minute = settings.scheduledMinute
                return Calendar.current.date(from: comps) ?? Date()
            },
            set: { date in
                let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
                settings.scheduledHour = comps.hour ?? 3
                settings.scheduledMinute = comps.minute ?? 0
            }
        )
    }
}
