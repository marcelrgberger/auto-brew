import Foundation
import os

@Observable
@MainActor
final class SnapshotsStore {
    static let shared = SnapshotsStore()

    private(set) var snapshots: [AppSnapshot] = []
    private(set) var isWorking = false
    private(set) var lastError: String?

    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "SnapshotsStore")

    var groupedByApp: [(bundleID: String, items: [AppSnapshot])] {
        let dict = Dictionary(grouping: snapshots, by: \.bundleID)
        return dict.map { ($0.key, $0.value.sorted { $0.createdAt > $1.createdAt }) }
                  .sorted { ($0.items.first?.displayName ?? "") < ($1.items.first?.displayName ?? "") }
    }

    func refresh() {
        do { snapshots = try SnapshotService.shared.listSnapshots() }
        catch { lastError = error.localizedDescription }
    }

    func createSnapshot(for app: InstalledApp) async {
        isWorking = true
        defer { isWorking = false }
        do {
            _ = try await SnapshotService.shared.createSnapshot(
                bundleID: app.bundleID,
                displayName: app.displayName,
                caskToken: app.caskToken,
                sourceAppVersion: app.version
            )
            refresh()
        } catch {
            lastError = error.localizedDescription
            logger.error("Snapshot failed: \(error.localizedDescription)")
        }
    }

    func delete(_ snapshot: AppSnapshot) {
        do { try SnapshotService.shared.deleteSnapshot(snapshot); refresh() }
        catch { lastError = error.localizedDescription }
    }

    func restore(_ snapshot: AppSnapshot, terminateApp: Bool) async {
        isWorking = true
        defer { isWorking = false }
        do { try await SnapshotService.shared.restoreSnapshot(snapshot, terminateApp: terminateApp) }
        catch { lastError = error.localizedDescription }
    }
}
