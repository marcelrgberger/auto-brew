import Foundation
import os

@Observable
@MainActor
final class RestoreWizardStore {
    enum Step: Equatable { case selectFile, review, running, done }

    var step: Step = .selectFile
    var sourceURL: URL?
    var restoreList: RestoreList?
    var snapshots: [AppSnapshot] = []
    var selected: Set<String> = []
    var installMissingCasks: Bool = true
    var quitAppsBeforeRestore: Bool = true
    var progress: [String: String] = [:]
    private(set) var failedBundles: [String] = []

    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "RestoreWizard")

    func loadBundle(at url: URL) async {
        sourceURL = url
        do {
            let result: (list: RestoreList, imported: [AppSnapshot])
            if url.hasDirectoryPath {
                result = try await SnapshotService.shared.importRestoreList(from: url)
            } else {
                let snap = try await SnapshotService.shared.importSnapshot(from: url)
                let synth = RestoreList(
                    schemaVersion: 1, createdAt: snap.createdAt, originHost: "imported",
                    entries: [.init(bundleID: snap.bundleID, caskToken: snap.caskToken,
                                    archiveFilename: url.lastPathComponent)]
                )
                result = (synth, [snap])
            }
            restoreList = result.list
            snapshots = result.imported
            selected = Set(result.imported.map(\.bundleID))
            step = .review
        } catch {
            logger.error("Load failed: \(error.localizedDescription)")
        }
    }

    func performRestore() async {
        step = .running
        failedBundles = []
        let installer = BrewInstaller()
        for snap in snapshots where selected.contains(snap.bundleID) {
            progress[snap.bundleID] = String(localized: "Installing…")
            if installMissingCasks, let token = snap.caskToken {
                do { try await installer.install(token: token) }
                catch {
                    let alt = try? await installer.searchCask(query: snap.displayName)
                    if let alt {
                        progress[snap.bundleID] = String(localized: "Trying alternative \(alt)…")
                        try? await installer.install(token: alt)
                    } else {
                        progress[snap.bundleID] = String(localized: "Install failed, restoring data only")
                    }
                }
            }
            progress[snap.bundleID] = String(localized: "Restoring data…")
            do {
                try await SnapshotService.shared.restoreSnapshot(snap, terminateApp: quitAppsBeforeRestore)
                progress[snap.bundleID] = String(localized: "Done")
            } catch {
                failedBundles.append(snap.bundleID)
                progress[snap.bundleID] = String(localized: "Failed: \(error.localizedDescription)")
            }
        }
        step = .done
    }
}
