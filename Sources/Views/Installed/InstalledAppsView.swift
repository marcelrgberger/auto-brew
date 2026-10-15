import SwiftUI

/// Installed tab: scans `/Applications`, resolves cask tokens against the
/// brew catalog, and lets the user upgrade/uninstall/snapshot per app.
/// The list refreshes on appear and after every brew action so the cask
/// token column reflects the post-operation state — the catalog isn't
/// observed reactively.
struct InstalledAppsView: View {
    @State private var store = InstalledAppsStore.shared
    @State private var snapshotTarget: InstalledApp?
    @State private var operationError: String?
    /// Tokens whose snapshot-then-brew-upgrade pipeline is currently in
    /// flight. A second tap on the same row must not kick off a parallel
    /// run — two concurrent snapshots compete for disk, two concurrent
    /// `brew upgrade` invocations fight Homebrew's lock, and either way
    /// the History store would gain duplicate rows.
    @State private var upgradingTokens: Set<String> = []

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField(String(localized: "Filter…"), text: $store.searchQuery)
                    .textFieldStyle(.roundedBorder)
                Button {
                    Task { await store.refresh() }
                } label: { Label(String(localized: "Refresh"), systemImage: "arrow.clockwise") }
                .disabled(store.isLoading)
            }
            .padding(8)

            if store.apps.isEmpty && !store.isLoading {
                ContentUnavailableView(
                    String(localized: "No apps found"),
                    systemImage: "shippingbox",
                    description: Text(String(localized: "Refresh to scan /Applications."))
                )
            } else {
                List(store.filtered) { app in
                    InstalledAppRowView(
                        app: app,
                        onUpgrade: {
                            guard let token = app.caskToken else { return }
                            guard !upgradingTokens.contains(token) else { return }
                            Task { await performUpgrade(app: app, token: token) }
                        },
                        onUninstall: {
                            guard let token = app.caskToken else { return }
                            Task {
                                do {
                                    try await BrewInstaller().uninstall(token: token)
                                    await store.refresh()
                                } catch {
                                    operationError = error.localizedDescription
                                }
                            }
                        },
                        onSnapshot: { snapshotTarget = app }
                    )
                }
            }
        }
        .task { await store.refresh() }
        .sheet(item: $snapshotTarget) { app in
            NewSnapshotView(app: app, onDone: { snapshotTarget = nil })
        }
        .alert(String(localized: "Operation failed"),
               isPresented: Binding(get: { operationError != nil },
                                    set: { if !$0 { operationError = nil } }),
               presenting: operationError) { _ in
            Button("OK") { operationError = nil }
        } message: { msg in Text(msg) }
    }

    /// Runs the same snapshot-then-upgrade-then-record flow the auto-update
    /// scheduler uses, so a manual upgrade from this view also produces an
    /// `UpgradeHistoryEntry` with a rollback affordance.
    private func performUpgrade(app: InstalledApp, token: String) async {
        upgradingTokens.insert(token)
        defer { upgradingTokens.remove(token) }

        let fromVersion = app.version ?? "?"
        let toVersion = BrewCatalogService.shared.casks
            .first(where: { $0.token == token })?
            .version ?? "?"

        let snapshotID = await PreUpgradeSnapshot.capture(
            token: token,
            bundleID: app.bundleID,
            displayName: app.displayName,
            fromVersion: fromVersion,
            policyEnabled: SettingsStore.shared.autoSnapshotBeforeUpgrade
        )

        do {
            try await BrewInstaller().upgrade(token: token)
            PreUpgradeSnapshot.record(
                token: token,
                displayName: app.displayName,
                bundleID: app.bundleID,
                fromVersion: fromVersion,
                toVersion: toVersion,
                snapshotID: snapshotID,
                outcome: .succeeded
            )
            // The update is installed, so any pending decision for it
            // (for instance an approval kept after a failed scheduled run)
            // is settled.
            PendingUpdatesStore.shared.remove(keys: [PendingUpdatesStore.key(kind: .cask, token: token)])
            await store.refresh()
        } catch {
            // Continue the backoff of an earlier automatic failure instead
            // of resetting it; a fresh failure schedules the first retry.
            let retry = UpgradeHistoryEntry.retryState(
                after: .failed,
                token: token,
                history: UpgradeHistoryStore.shared.entries,
                now: Date()
            )
            PreUpgradeSnapshot.record(
                token: token,
                displayName: app.displayName,
                bundleID: app.bundleID,
                fromVersion: fromVersion,
                toVersion: toVersion,
                snapshotID: snapshotID,
                outcome: .failed,
                retryCount: retry.retryCount,
                nextRetryAt: retry.nextRetryAt
            )
            operationError = error.localizedDescription
        }
    }
}
