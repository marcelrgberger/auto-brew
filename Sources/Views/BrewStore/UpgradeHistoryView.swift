import SwiftUI

/// Audit log of every auto-upgrade plus one-click rollback when the
/// pre-upgrade snapshot still exists. The rollback runs straight through
/// `SnapshotService.restoreSnapshot(_:terminateApp:)` — the full
/// `RestoreWizard` would needlessly try to reinstall the cask that the
/// upgrade just installed.
struct UpgradeHistoryView: View {
    @State private var historyStore = UpgradeHistoryStore.shared
    @State private var availableSnapshots: [UUID: AppSnapshot] = [:]
    @State private var pendingConfirmation: UpgradeHistoryEntry?
    @State private var restoreInProgress: UUID?
    @State private var restoreResult: RestoreResult?
    @State private var componentSelection: Set<String> = []

    private struct RestoreResult: Identifiable {
        let id = UUID()
        let title: String
        let message: String
        let isError: Bool
    }

    var body: some View {
        Group {
            if historyStore.entries.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .task { reloadAvailableSnapshots() }
        .onChange(of: historyStore.entries.count) { _, _ in reloadAvailableSnapshots() }
        .sheet(item: $pendingConfirmation) { entry in
            rollbackSheet(for: entry)
        }
        .alert(item: $restoreResult) { result in
            Alert(
                title: Text(result.title),
                message: Text(result.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // MARK: - States

    private var emptyState: some View {
        ContentUnavailableView(
            String(localized: "No auto-upgrades yet"),
            systemImage: "clock.arrow.circlepath",
            description: Text(String(localized: "Once AutoBrew installs an update on its own, the run shows up here. If pre-upgrade snapshots are enabled in Settings, you can roll back from this view with one click."))
        )
    }

    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(historyStore.entries) { entry in
                    row(for: entry)
                }
            }
            .padding(16)
        }
    }

    @ViewBuilder
    private func row(for entry: UpgradeHistoryEntry) -> some View {
        HStack(alignment: .center, spacing: 12) {
            statusIcon(for: entry)

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.displayName)
                    .font(.body.weight(.medium))
                HStack(spacing: 6) {
                    Text(entry.fromVersion)
                        .foregroundStyle(.secondary)
                    Image(systemName: "arrow.right")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(entry.toVersion)
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text(entry.timestamp, format: .relative(presentation: .named))
                        .foregroundStyle(.secondary)
                }
                .font(.callout)
                retryBadge(for: entry)
            }

            Spacer()

            rollbackControl(for: entry)
        }
        .padding(12)
        .adaptiveGlassCard(cornerRadius: 10)
    }

    @ViewBuilder
    private func retryBadge(for entry: UpgradeHistoryEntry) -> some View {
        if entry.outcome == .failed {
            if let nextRetry = entry.nextRetryAt, nextRetry > Date() {
                Label {
                    Text(String(localized: "Auto-retry \(nextRetry, format: .relative(presentation: .named))"))
                } icon: {
                    Image(systemName: "arrow.clockwise")
                }
                .font(.caption2)
                .foregroundStyle(.orange)
                .help(String(localized: "AutoBrew will retry this upgrade automatically. Backoff: 1 h, then 4 h, then 12 h — up to three attempts."))
            } else if entry.retryCount >= UpgradeHistoryEntry.maxRetries {
                Label {
                    Text(String(localized: "Retries exhausted"))
                } icon: {
                    Image(systemName: "exclamationmark.octagon")
                }
                .font(.caption2)
                .foregroundStyle(.red)
                .help(String(localized: "AutoBrew gave up after three automatic retries. Trigger a manual upgrade from the Outdated list to try again."))
            }
        }
    }

    @ViewBuilder
    private func statusIcon(for entry: UpgradeHistoryEntry) -> some View {
        switch entry.outcome {
        case .succeeded:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .imageScale(.large)
        case .failed:
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red)
                .imageScale(.large)
        case .attempted:
            // Brew swallowed the per-cask outcome — we know the run
            // completed but not whether *this* cask actually upgraded.
            // Don't claim a green tick we cannot back up.
            Image(systemName: "questionmark.circle.fill")
                .foregroundStyle(.orange)
                .imageScale(.large)
                .help(String(localized: "Outcome unclear — brew did not emit a success or error marker for this cask. The pre-upgrade snapshot is still available for rollback."))
        }
    }

    @ViewBuilder
    private func rollbackControl(for entry: UpgradeHistoryEntry) -> some View {
        if restoreInProgress == entry.id {
            ProgressView()
                .controlSize(.small)
        } else if let snapshotID = entry.snapshotID, availableSnapshots[snapshotID] != nil {
            Button {
                pendingConfirmation = entry
            } label: {
                Label(String(localized: "Roll Back"), systemImage: "arrow.uturn.backward")
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        } else if entry.snapshotID != nil {
            // We had a snapshot at upgrade time but it's gone now — usually
            // pruned by the retention policy. Surface that explicitly so the
            // user doesn't expect a rollback that no longer exists.
            Label(String(localized: "Snapshot pruned"), systemImage: "trash")
                .labelStyle(.titleAndIcon)
                .font(.caption)
                .foregroundStyle(.secondary)
        } else {
            Label(String(localized: "No snapshot"), systemImage: "minus.circle")
                .labelStyle(.titleAndIcon)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    // MARK: - Rollback sheet

    @ViewBuilder
    private func rollbackSheet(for entry: UpgradeHistoryEntry) -> some View {
        let snapshot = entry.snapshotID.flatMap { availableSnapshots[$0] }
        let manifest = snapshot.flatMap(loadManifest(for:))
        let components = manifest?.components ?? []

        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: "Roll back \(entry.displayName)?"))
                .font(.headline)
            Text(String(localized: "AutoBrew will quit \(entry.displayName) and restore the selected user-data folders from the snapshot taken right before the \(entry.fromVersion) → \(entry.toVersion) upgrade. The upgraded \(entry.displayName) binary itself stays in place — only your settings and data are reverted."))
                .font(.callout)
                .foregroundStyle(.secondary)

            if components.isEmpty {
                Text(String(localized: "Snapshot manifest could not be read — rollback unavailable."))
                    .foregroundStyle(.red)
                    .font(.callout)
            } else {
                Text(String(localized: "Choose which components to restore"))
                    .font(.callout.weight(.medium))
                    .padding(.top, 4)
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(components, id: \.relativeArchivePath) { component in
                            Toggle(isOn: Binding(
                                get: { componentSelection.contains(component.relativeArchivePath) },
                                set: { isOn in
                                    if isOn { componentSelection.insert(component.relativeArchivePath) }
                                    else { componentSelection.remove(component.relativeArchivePath) }
                                }
                            )) {
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(component.originalPath)
                                        .font(.callout.monospaced())
                                        .lineLimit(1)
                                    Text(ByteFormatter.string(component.byteSize))
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxHeight: 240)
            }

            HStack {
                Button(String(localized: "Cancel"), role: .cancel) {
                    pendingConfirmation = nil
                }
                Spacer()
                Button(String(localized: "Roll Back"), role: .destructive) {
                    Task { await performRollback(for: entry) }
                }
                .disabled(componentSelection.isEmpty || components.isEmpty)
            }
        }
        .padding(20)
        .frame(minWidth: 460)
        .task {
            // Default to "everything selected" — matches old all-or-
            // nothing semantics so a user who doesn't care just hits
            // Roll Back without ticking every box.
            componentSelection = Set(components.map(\.relativeArchivePath))
        }
    }

    private func loadManifest(for snapshot: AppSnapshot) -> SnapshotManifest? {
        guard let data = try? Data(contentsOf: snapshot.manifestURL) else { return nil }
        return try? JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: data)
    }

    // MARK: - Actions

    private func reloadAvailableSnapshots() {
        let snapshots = (try? SnapshotService.shared.listSnapshots()) ?? []
        var map: [UUID: AppSnapshot] = [:]
        for snap in snapshots { map[snap.id] = snap }
        availableSnapshots = map
        // History rows keep their `snapshotID` even after a snapshot is pruned
        // so the audit link survives — the rollback button is gated on the
        // live `availableSnapshots` map, which falls through to the "Snapshot
        // pruned" branch when the disk no longer has it.
    }

    private func performRollback(for entry: UpgradeHistoryEntry) async {
        let selectedComponents = componentSelection
        pendingConfirmation = nil
        guard let snapshotID = entry.snapshotID,
              let snapshot = availableSnapshots[snapshotID] else {
            restoreResult = RestoreResult(
                title: String(localized: "Snapshot unavailable"),
                message: String(localized: "The snapshot for this upgrade is no longer on disk — it was probably removed by retention or manual cleanup."),
                isError: true
            )
            return
        }
        restoreInProgress = entry.id
        defer { restoreInProgress = nil }
        do {
            try await SnapshotService.shared.restoreSnapshot(
                snapshot,
                terminateApp: true,
                components: selectedComponents.isEmpty ? nil : selectedComponents
            )
            restoreResult = RestoreResult(
                title: String(localized: "Rolled back"),
                message: String(localized: "\(entry.displayName) is back on the user data from before the \(entry.fromVersion) → \(entry.toVersion) upgrade (\(selectedComponents.count) components restored)."),
                isError: false
            )
        } catch {
            restoreResult = RestoreResult(
                title: String(localized: "Rollback failed"),
                message: error.localizedDescription,
                isError: true
            )
        }
    }
}
