import SwiftUI

struct SettingsView: View {
    @State private var settings = SettingsStore.shared
    @State private var scheduler = SchedulerService.shared
    @State private var brewManager = BrewManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("AutoBrew Einstellungen")
                    .font(.headline)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding()

            Divider()

            Form {
                Section("Aktualisierungsmodus") {
                    Picker("Modus", selection: Binding(
                        get: { settings.triggerMode },
                        set: {
                            settings.triggerMode = $0
                            scheduler.restartScheduling()
                        }
                    )) {
                        Text("Nach Leerlauf").tag(TriggerMode.idle)
                        Text("Zu fester Uhrzeit").tag(TriggerMode.scheduled)
                    }
                    .pickerStyle(.segmented)

                    if settings.triggerMode == .idle {
                        HStack {
                            Text("Leerlaufzeit")
                            Spacer()
                            Stepper(
                                "\(settings.idleMinutes) Min.",
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
                            "Uhrzeit",
                            selection: scheduledTimeBinding,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: scheduledTimeBinding.wrappedValue) {
                            scheduler.restartScheduling()
                        }
                    }
                }

                Section("Allgemein") {
                    Toggle("Mit System starten", isOn: Binding(
                        get: { settings.loginItemEnabled },
                        set: {
                            settings.loginItemEnabled = $0
                            LoginItemManager.setEnabled($0)
                        }
                    ))

                    Toggle("Benachrichtigungen anzeigen", isOn: Binding(
                        get: { settings.showNotifications },
                        set: { settings.showNotifications = $0 }
                    ))
                }

                Section("Homebrew") {
                    HStack {
                        Text("Status")
                        Spacer()
                        if brewManager.isHomebrewInstalled {
                            Label("Installiert", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else {
                            Label("Nicht gefunden", systemImage: "xmark.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }

                    if let path = brewManager.brewExecutable {
                        HStack {
                            Text("Pfad")
                            Spacer()
                            Text(path)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Info") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Entwickler")
                        Spacer()
                        Text("Marcel R. G. Berger")
                            .foregroundStyle(.secondary)
                    }
                    Link(destination: URL(string: "https://github.com/sponsors/marcelrgberger")!) {
                        HStack {
                            Label("Projekt unterstützen", systemImage: "heart")
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
        .frame(width: 380, height: 440)
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
