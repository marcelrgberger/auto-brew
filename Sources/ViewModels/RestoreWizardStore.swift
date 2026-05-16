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
    var loadError: String?
    private(set) var failedBundles: [String] = []

    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "RestoreWizard")

    func loadBundle(at url: URL) async {
        loadError = nil
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
            loadError = error.localizedDescription
            logger.error("Load failed: \(error.localizedDescription)")
        }
    }

    func performRestore() async {
        step = .running
        failedBundles = []
        let installer = BrewInstaller()
        for snap in snapshots where selected.contains(snap.bundleID) {
            // Track whether the cask is actually present before we attempt the data
            // restore. Pushing user data onto a non-existent app produces files the
            // user cannot reach and hides the real failure behind a green "Done".
            var installSucceeded = !installMissingCasks || snap.caskToken == nil
            if installMissingCasks, let token = snap.caskToken {
                progress[snap.bundleID] = String(localized: "Installing…")
                do {
                    try await installer.install(token: token)
                    installSucceeded = true
                } catch {
                    if let alt = try? await installer.searchCask(query: snap.displayName) {
                        progress[snap.bundleID] = String(localized: "Trying alternative \(alt)…")
                        do {
                            try await installer.install(token: alt)
                            installSucceeded = true
                        } catch {
                            // Alternative also failed — fall through to the failure branch.
                        }
                    }
                }
            }
            if !installSucceeded {
                failedBundles.append(snap.bundleID)
                progress[snap.bundleID] = String(localized: "Install failed, skipping data restore")
                continue
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
