import Foundation
import os

extension JSONDecoder {
    static func snapshotDecoder() -> JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }
}
extension JSONEncoder {
    static func snapshotEncoder() -> JSONEncoder {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        return e
    }
}

@MainActor
final class SnapshotService {
    static let shared = SnapshotService()
    static let schemaVersion = 1

    private let storageRoot: URL
    let home: URL
    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "Snapshot")
    private let fm = FileManager.default

    init(storageRoot: URL? = nil, home: URL? = nil) {
        if let storageRoot {
            self.storageRoot = storageRoot
        } else {
            let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            self.storageRoot = support.appendingPathComponent("AutoBrew/Snapshots", isDirectory: true)
        }
        self.home = home ?? FileManager.default.homeDirectoryForCurrentUser
        try? fm.createDirectory(at: self.storageRoot, withIntermediateDirectories: true)
    }

    func createSnapshot(bundleID: String, displayName: String, caskToken: String?, sourceAppVersion: String?) async throws -> AppSnapshot {
        let id = UUID()
        let timestamp = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: ":", with: "-")
        let bundleDir = storageRoot.appendingPathComponent("\(bundleID)/\(timestamp)_\(id.uuidString.prefix(8))", isDirectory: true)
        let dataDir = bundleDir.appendingPathComponent("data", isDirectory: true)
        try fm.createDirectory(at: dataDir, withIntermediateDirectories: true)

        let resolver = SnapshotPathResolver(bundleID: bundleID, home: home)
        let homeURL = home

        var succeeded = false
        defer {
            if !succeeded {
                try? fm.removeItem(at: bundleDir)
                let parent = bundleDir.deletingLastPathComponent()
                if let remaining = try? fm.contentsOfDirectory(at: parent, includingPropertiesForKeys: nil), remaining.isEmpty {
                    try? fm.removeItem(at: parent)
                }
            }
        }

        let copyResult = try await Task.detached(priority: .userInitiated) {
            try Self.copyComponents(resolver: resolver, home: homeURL, dataDir: dataDir)
        }.value

        let manifest = SnapshotManifest(
            id: id,
            bundleID: bundleID,
            displayName: displayName,
            caskToken: caskToken,
            sourceAppVersion: sourceAppVersion,
            createdAt: Date(),
            originHost: ProcessInfo.processInfo.hostName,
            originUser: NSUserName(),
            schemaVersion: Self.schemaVersion,
            components: copyResult.components
        )
        let manifestData = try JSONEncoder.snapshotEncoder().encode(manifest)
        try manifestData.write(to: bundleDir.appendingPathComponent("manifest.json"))

        succeeded = true
        logger.info("Created snapshot \(bundleID, privacy: .public) with \(copyResult.components.count) components (\(copyResult.totalBytes) bytes)")

        return AppSnapshot(
            id: id, bundleID: bundleID, displayName: displayName,
            createdAt: manifest.createdAt, caskToken: caskToken,
            sourceAppVersion: sourceAppVersion, totalBytes: copyResult.totalBytes,
            bundleURL: bundleDir
        )
    }

    func listSnapshots() throws -> [AppSnapshot] {
        guard fm.fileExists(atPath: storageRoot.path) else { return [] }
        var result: [AppSnapshot] = []
        let bundleDirs = try fm.contentsOfDirectory(at: storageRoot, includingPropertiesForKeys: nil)
        for bundleDir in bundleDirs {
            let timestampDirs = (try? fm.contentsOfDirectory(at: bundleDir, includingPropertiesForKeys: nil)) ?? []
            for tsDir in timestampDirs {
                let manifestURL = tsDir.appendingPathComponent("manifest.json")
                guard fm.fileExists(atPath: manifestURL.path) else { continue }
                guard let data = try? Data(contentsOf: manifestURL),
                      let manifest = try? JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: data) else { continue }
                let total = manifest.components.reduce(Int64(0)) { $0 + $1.byteSize }
                result.append(AppSnapshot(
                    id: manifest.id,
                    bundleID: manifest.bundleID,
                    displayName: manifest.displayName,
                    createdAt: manifest.createdAt,
                    caskToken: manifest.caskToken,
                    sourceAppVersion: manifest.sourceAppVersion,
                    totalBytes: total,
                    bundleURL: tsDir
                ))
            }
        }
        return result.sorted { $0.createdAt > $1.createdAt }
    }

    func deleteSnapshot(_ snapshot: AppSnapshot) throws {
        try fm.removeItem(at: snapshot.bundleURL)
        let parent = snapshot.bundleURL.deletingLastPathComponent()
        if let remaining = try? fm.contentsOfDirectory(at: parent, includingPropertiesForKeys: nil), remaining.isEmpty {
            try? fm.removeItem(at: parent)
        }
    }

    func restoreSnapshot(_ snapshot: AppSnapshot, terminateApp: Bool = false) async throws {
        if terminateApp {
            try await AppQuitter.quit(bundleID: snapshot.bundleID)
        }
        let manifestData = try Data(contentsOf: snapshot.manifestURL)
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: manifestData)
        let dataDir = snapshot.dataDir
        let homeURL = home
        let components = manifest.components

        try await Task.detached(priority: .userInitiated) {
            try Self.restoreComponents(components, dataDir: dataDir, home: homeURL)
        }.value

        logger.info("Restored snapshot \(snapshot.bundleID, privacy: .public)")
    }

    // MARK: - Export / Import

    func exportSnapshot(_ snapshot: AppSnapshot, to destination: URL) async throws {
        if fm.fileExists(atPath: destination.path) {
            try fm.removeItem(at: destination)
        }
        try await SnapshotArchiver.zip(directory: snapshot.bundleURL, to: destination)
    }

    func importSnapshot(from archiveURL: URL) async throws -> AppSnapshot {
        let extractRoot = storageRoot.appendingPathComponent("_import_\(UUID().uuidString)", isDirectory: true)
        try fm.createDirectory(at: extractRoot, withIntermediateDirectories: true)
        try await SnapshotArchiver.unzip(archiveURL, to: extractRoot)

        let manifestURL = extractRoot.appendingPathComponent("manifest.json")
        guard fm.fileExists(atPath: manifestURL.path) else {
            try? fm.removeItem(at: extractRoot)
            throw NSError(domain: "Snapshot", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid snapshot bundle"])
        }
        let manifestData = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: manifestData)

        let timestamp = ISO8601DateFormatter().string(from: manifest.createdAt).replacingOccurrences(of: ":", with: "-")
        let target = storageRoot.appendingPathComponent("\(manifest.bundleID)/\(timestamp)_\(manifest.id.uuidString.prefix(8))", isDirectory: true)
        try fm.createDirectory(at: target.deletingLastPathComponent(), withIntermediateDirectories: true)
        if fm.fileExists(atPath: target.path) { try fm.removeItem(at: target) }
        try fm.moveItem(at: extractRoot, to: target)

        let total = manifest.components.reduce(Int64(0)) { $0 + $1.byteSize }
        return AppSnapshot(
            id: manifest.id, bundleID: manifest.bundleID, displayName: manifest.displayName,
            createdAt: manifest.createdAt, caskToken: manifest.caskToken,
            sourceAppVersion: manifest.sourceAppVersion, totalBytes: total, bundleURL: target
        )
    }

    func exportRestoreList(snapshots: [AppSnapshot], to directory: URL) async throws {
        if fm.fileExists(atPath: directory.path) { try fm.removeItem(at: directory) }
        try fm.createDirectory(at: directory, withIntermediateDirectories: true)

        var entries: [RestoreList.Entry] = []
        for snap in snapshots {
            let filename = "\(snap.bundleID)_\(snap.id.uuidString.prefix(8)).autobrewsnapshot"
            let outURL = directory.appendingPathComponent(filename)
            try await exportSnapshot(snap, to: outURL)
            entries.append(.init(bundleID: snap.bundleID, caskToken: snap.caskToken, archiveFilename: filename))
        }

        let list = RestoreList(
            schemaVersion: Self.schemaVersion,
            createdAt: Date(),
            originHost: Host.current().localizedName ?? "Unknown",
            entries: entries
        )
        let data = try JSONEncoder.snapshotEncoder().encode(list)
        try data.write(to: directory.appendingPathComponent("restore_list.json"))
    }

    func importRestoreList(from directory: URL) async throws -> (list: RestoreList, imported: [AppSnapshot]) {
        let manifestData = try Data(contentsOf: directory.appendingPathComponent("restore_list.json"))
        let list = try JSONDecoder.snapshotDecoder().decode(RestoreList.self, from: manifestData)
        var imported: [AppSnapshot] = []
        for entry in list.entries {
            let url = directory.appendingPathComponent(entry.archiveFilename)
            let snap = try await importSnapshot(from: url)
            imported.append(snap)
        }
        return (list, imported)
    }

    // MARK: - Nonisolated file operations

    private nonisolated static func encodeOriginalPath(_ src: URL, home: URL) -> String {
        let homePath = home.path.hasSuffix("/") ? home.path : home.path + "/"
        if src.path.hasPrefix(homePath) {
            return "~/" + src.path.dropFirst(homePath.count)
        }
        return src.path
    }

    private nonisolated static func copyComponents(
        resolver: SnapshotPathResolver,
        home: URL,
        dataDir: URL
    ) throws -> (components: [SnapshotComponent], totalBytes: Int64) {
        let fm = FileManager.default
        var components: [SnapshotComponent] = []
        var totalBytes: Int64 = 0

        let homePrefix = home.path.hasSuffix("/") ? home.path : home.path + "/"

        for src in resolver.existingPaths() {
            let rel: String
            if src.path.hasPrefix(homePrefix) {
                rel = String(src.path.dropFirst(homePrefix.count))
            } else {
                rel = src.lastPathComponent
            }
            let dest = dataDir.appendingPathComponent(rel)
            try fm.createDirectory(at: dest.deletingLastPathComponent(), withIntermediateDirectories: true)

            var isDir: ObjCBool = false
            fm.fileExists(atPath: src.path, isDirectory: &isDir)
            if isDir.boolValue {
                try fm.copyItem(at: src, to: dest)
                let size = try directorySize(at: dest)
                totalBytes += size
                components.append(SnapshotComponent(
                    originalPath: encodeOriginalPath(src, home: home),
                    relativeArchivePath: rel,
                    kind: .directory,
                    sha256: nil,
                    byteSize: size
                ))
            } else {
                try fm.copyItem(at: src, to: dest)
                let attrs = try fm.attributesOfItem(atPath: dest.path)
                let size = (attrs[.size] as? Int64) ?? 0
                let hash = try Sha256Hasher.hash(file: dest)
                totalBytes += size
                components.append(SnapshotComponent(
                    originalPath: encodeOriginalPath(src, home: home),
                    relativeArchivePath: rel,
                    kind: .file,
                    sha256: hash,
                    byteSize: size
                ))
            }
        }
        return (components, totalBytes)
    }

    private nonisolated static func restoreComponents(
        _ components: [SnapshotComponent],
        dataDir: URL,
        home: URL
    ) throws {
        let fm = FileManager.default
        for component in components {
            let src = dataDir.appendingPathComponent(component.relativeArchivePath)
            let destPath = component.originalPath.replacingOccurrences(of: "~", with: home.path)
            let dest = URL(fileURLWithPath: destPath)

            try fm.createDirectory(at: dest.deletingLastPathComponent(), withIntermediateDirectories: true)

            let backup = dest.deletingLastPathComponent()
                .appendingPathComponent(".\(dest.lastPathComponent).autobrewbackup-\(UUID().uuidString.prefix(8))")
            let hadExisting = fm.fileExists(atPath: dest.path)
            if hadExisting {
                try fm.moveItem(at: dest, to: backup)
            }
            do {
                try fm.copyItem(at: src, to: dest)
                if hadExisting {
                    try? fm.removeItem(at: backup)
                }
            } catch {
                if hadExisting {
                    try? fm.removeItem(at: dest)
                    try? fm.moveItem(at: backup, to: dest)
                }
                throw error
            }
        }
    }

    private nonisolated static func directorySize(at url: URL) throws -> Int64 {
        let fm = FileManager.default
        var total: Int64 = 0
        guard let enumerator = fm.enumerator(at: url, includingPropertiesForKeys: [.fileSizeKey]) else { return 0 }
        for case let item as URL in enumerator {
            let attrs = try item.resourceValues(forKeys: [.fileSizeKey])
            total += Int64(attrs.fileSize ?? 0)
        }
        return total
    }
}
