import Foundation
import os
import CryptoKit

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

enum SnapshotError: LocalizedError {
    case pathTraversal(String)
    case invalidManifest(String)
    case unsupportedSchemaVersion(Int)

    var errorDescription: String? {
        switch self {
        case .pathTraversal(let p): String(localized: "Path traversal blocked: \(p)")
        case .invalidManifest(let r): String(localized: "Invalid snapshot manifest: \(r)")
        case .unsupportedSchemaVersion(let v): String(localized: "Unsupported snapshot schema version: \(v)")
        }
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
        guard Self.isValidBundleID(bundleID) else {
            throw SnapshotError.invalidManifest("Invalid bundleID: \(bundleID)")
        }
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

        // Empty snapshots are never useful — they create entries in the UI that
        // restore to nothing — so refuse to create one. The defer cleans up the
        // partially created bundle directory.
        guard !copyResult.components.isEmpty else {
            throw SnapshotError.invalidManifest("No data found for bundleID \(bundleID) — nothing to snapshot")
        }

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
                let total = Self.safeTotalBytes(manifest.components)
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

    func cleanup(olderThanDays days: Int) throws {
        guard days > 0 else { return }
        let snapshots = try listSnapshots()
        let cutoff = Date().addingTimeInterval(-Double(days) * 86_400)
        for snap in snapshots where snap.createdAt < cutoff {
            try deleteSnapshot(snap)
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

        var moved = false
        defer {
            if !moved { try? fm.removeItem(at: extractRoot) }
        }

        try await SnapshotArchiver.unzip(archiveURL, to: extractRoot)

        let manifestURL = extractRoot.appendingPathComponent("manifest.json")
        guard fm.fileExists(atPath: manifestURL.path) else {
            throw SnapshotError.invalidManifest("Missing manifest.json")
        }
        let manifestData = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: manifestData)

        guard manifest.schemaVersion <= Self.schemaVersion else {
            throw SnapshotError.unsupportedSchemaVersion(manifest.schemaVersion)
        }

        guard Self.isValidBundleID(manifest.bundleID) else {
            throw SnapshotError.invalidManifest("Invalid bundleID in manifest: \(manifest.bundleID)")
        }

        guard !manifest.components.isEmpty else {
            throw SnapshotError.invalidManifest("Imported snapshot has no components")
        }

        guard manifest.components.allSatisfy({ $0.byteSize >= 0 }) else {
            throw SnapshotError.invalidManifest("Negative byteSize in manifest")
        }

        let timestamp = ISO8601DateFormatter().string(from: manifest.createdAt).replacingOccurrences(of: ":", with: "-")
        let target = storageRoot.appendingPathComponent("\(manifest.bundleID)/\(timestamp)_\(manifest.id.uuidString.prefix(8))", isDirectory: true)
        try fm.createDirectory(at: target.deletingLastPathComponent(), withIntermediateDirectories: true)

        // Move an already-present target out of the way instead of deleting it
        // outright. If the move-in of the new payload fails, the previous snapshot
        // is restored so a broken import never destroys existing data.
        let existingBackup = target.deletingLastPathComponent()
            .appendingPathComponent(".\(target.lastPathComponent).autobrewbackup-\(UUID().uuidString.prefix(8))")
        let hadExisting = fm.fileExists(atPath: target.path)
        if hadExisting {
            try fm.moveItem(at: target, to: existingBackup)
        }
        do {
            try fm.moveItem(at: extractRoot, to: target)
            if hadExisting { try? fm.removeItem(at: existingBackup) }
            moved = true
        } catch {
            if hadExisting { Self.rollbackBackup(existingBackup, to: target) }
            throw error
        }

        let total = Self.safeTotalBytes(manifest.components)
        return AppSnapshot(
            id: manifest.id, bundleID: manifest.bundleID, displayName: manifest.displayName,
            createdAt: manifest.createdAt, caskToken: manifest.caskToken,
            sourceAppVersion: manifest.sourceAppVersion, totalBytes: total, bundleURL: target
        )
    }

    func exportRestoreList(snapshots: [AppSnapshot], to directory: URL) async throws {
        if fm.fileExists(atPath: directory.path) {
            throw SnapshotError.invalidManifest("Export target already exists: \(directory.path)")
        }
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
            originHost: ProcessInfo.processInfo.hostName,
            entries: entries
        )
        let data = try JSONEncoder.snapshotEncoder().encode(list)
        try data.write(to: directory.appendingPathComponent("restore_list.json"))
    }

    func importRestoreList(from directory: URL) async throws -> (list: RestoreList, imported: [AppSnapshot]) {
        let manifestData = try Data(contentsOf: directory.appendingPathComponent("restore_list.json"))
        let list = try JSONDecoder.snapshotDecoder().decode(RestoreList.self, from: manifestData)

        guard list.schemaVersion <= Self.schemaVersion else {
            throw SnapshotError.unsupportedSchemaVersion(list.schemaVersion)
        }

        var imported: [AppSnapshot] = []
        for entry in list.entries {
            let filename = entry.archiveFilename
            guard !filename.isEmpty,
                  !filename.contains("/"),
                  !filename.contains("\\"),
                  !filename.contains(".."),
                  filename.hasSuffix(".autobrewsnapshot")
            else {
                throw SnapshotError.invalidManifest("Invalid archiveFilename: \(filename)")
            }
            let url = directory.appendingPathComponent(filename)
            let snap = try await importSnapshot(from: url)
            imported.append(snap)
        }
        return (list, imported)
    }

    // MARK: - Nonisolated file operations

    /// Sum `byteSize` values without trapping on overflow. A malicious manifest
    /// that declares `Int64.max` for every component would otherwise crash the
    /// reduce. Negative entries are clamped to zero and overflow saturates to
    /// `Int64.max` so the UI still gets a meaningful "huge" number.
    private nonisolated static func safeTotalBytes(_ components: [SnapshotComponent]) -> Int64 {
        var total: Int64 = 0
        for c in components {
            let (sum, overflow) = total.addingReportingOverflow(max(0, c.byteSize))
            if overflow { return Int64.max }
            total = sum
        }
        return total
    }

    private nonisolated static func isValidBundleID(_ id: String) -> Bool {
        !id.isEmpty &&
        id.range(of: #"^[a-zA-Z0-9][a-zA-Z0-9._-]*$"#, options: .regularExpression) != nil
    }

    private nonisolated static func encodeOriginalPath(_ src: URL, home: URL) -> String {
        let homePath = home.path.hasSuffix("/") ? home.path : home.path + "/"
        if src.path.hasPrefix(homePath) {
            return "~/" + src.path.dropFirst(homePath.count)
        }
        return src.path
    }

    private nonisolated static func decodeOriginalPath(_ encoded: String, home: URL) throws -> URL {
        let resolvedPath: String
        if encoded.hasPrefix("~/") {
            resolvedPath = home.path + "/" + encoded.dropFirst(2)
        } else if encoded == "~" {
            resolvedPath = home.path
        } else {
            resolvedPath = encoded
        }
        // Normalize and verify containment within home to defeat path-traversal payloads.
        let standardized = (resolvedPath as NSString).standardizingPath
        let homeStandardized = (home.path as NSString).standardizingPath
        let homeWithSlash = homeStandardized.hasSuffix("/") ? homeStandardized : homeStandardized + "/"
        guard standardized == homeStandardized || standardized.hasPrefix(homeWithSlash) else {
            throw SnapshotError.pathTraversal(encoded)
        }
        return URL(fileURLWithPath: standardized)
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
                let treeHash = try directoryTreeHash(at: dest)
                totalBytes += size
                components.append(SnapshotComponent(
                    originalPath: encodeOriginalPath(src, home: home),
                    relativeArchivePath: rel,
                    kind: .directory,
                    sha256: treeHash,
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
        let dataDirStandardized = (dataDir.path as NSString).standardizingPath
        let dataDirWithSlash = dataDirStandardized.hasSuffix("/") ? dataDirStandardized : dataDirStandardized + "/"

        struct Plan {
            let component: SnapshotComponent
            let src: URL
            let dest: URL
            let backup: URL
        }

        // Phase 1: validate every source up-front so a missing or traversal-laden
        // component aborts the whole operation before we touch any live data.
        var plans: [Plan] = []
        for component in components {
            let src = dataDir.appendingPathComponent(component.relativeArchivePath)
            let srcStandardized = (src.path as NSString).standardizingPath
            guard srcStandardized.hasPrefix(dataDirWithSlash) else {
                throw SnapshotError.pathTraversal(component.relativeArchivePath)
            }
            guard fm.fileExists(atPath: src.path) else {
                throw SnapshotError.invalidManifest("Missing component: \(component.relativeArchivePath)")
            }
            // Detect on-disk tampering of snapshot payloads before we let them
            // overwrite live user data.
            if component.kind == .file, let expectedHash = component.sha256 {
                let actualHash = try Sha256Hasher.hash(file: src)
                guard actualHash == expectedHash else {
                    throw SnapshotError.invalidManifest("Hash mismatch for \(component.relativeArchivePath)")
                }
            }
            if component.kind == .directory, let expectedHash = component.sha256 {
                let actualHash = try Self.directoryTreeHash(at: src)
                guard actualHash == expectedHash else {
                    throw SnapshotError.invalidManifest("Tree hash mismatch for \(component.relativeArchivePath)")
                }
            }
            let dest = try decodeOriginalPath(component.originalPath, home: home)
            let backup = dest.deletingLastPathComponent()
                .appendingPathComponent(".\(dest.lastPathComponent).autobrewbackup-\(UUID().uuidString.prefix(8))")
            plans.append(Plan(component: component, src: src, dest: dest, backup: backup))
        }

        // Phase 2a: move every existing destination to its backup path so a failure
        // anywhere in the apply step can rewind every component, not just the last one.
        var madeBackups: [(backup: URL, dest: URL)] = []
        do {
            for plan in plans {
                try fm.createDirectory(at: plan.dest.deletingLastPathComponent(), withIntermediateDirectories: true)
                if fm.fileExists(atPath: plan.dest.path) {
                    try fm.moveItem(at: plan.dest, to: plan.backup)
                    madeBackups.append((plan.backup, plan.dest))
                }
            }
        } catch {
            for entry in madeBackups.reversed() {
                Self.rollbackBackup(entry.backup, to: entry.dest)
            }
            throw error
        }

        // Phase 2b: copy every component, then re-verify its hash at the
        // destination to close the TOCTOU gap between Phase 1's pre-check and
        // the actual write. The pre-check still fast-fails before any
        // destructive work; the post-check guarantees the bytes that landed on
        // disk are the bytes we hashed. On failure, remove what we already
        // copied and restore every backup before reporting the error.
        var copiedDests: [URL] = []
        do {
            for plan in plans {
                try fm.copyItem(at: plan.src, to: plan.dest)
                copiedDests.append(plan.dest)
                if plan.component.kind == .file, let expectedHash = plan.component.sha256 {
                    let actualHash = try Sha256Hasher.hash(file: plan.dest)
                    guard actualHash == expectedHash else {
                        throw SnapshotError.invalidManifest("Post-copy hash mismatch for \(plan.component.relativeArchivePath)")
                    }
                }
                if plan.component.kind == .directory, let expectedHash = plan.component.sha256 {
                    let actualHash = try Self.directoryTreeHash(at: plan.dest)
                    guard actualHash == expectedHash else {
                        throw SnapshotError.invalidManifest("Post-copy tree hash mismatch for \(plan.component.relativeArchivePath)")
                    }
                }
            }
        } catch {
            for dest in copiedDests.reversed() {
                try? fm.removeItem(at: dest)
            }
            for entry in madeBackups.reversed() {
                Self.rollbackBackup(entry.backup, to: entry.dest)
            }
            throw error
        }

        // Success: discard backups.
        for entry in madeBackups {
            try? fm.removeItem(at: entry.backup)
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

    /// Restore a backup to its original destination, detecting collisions that may
    /// have been caused by a racing writer recreating the destination during restore.
    /// The rollback path must never throw — otherwise it would shadow the original
    /// error that triggered the rollback. If the backup can't be restored, we log
    /// to stderr so the user has a path to recover manually.
    private nonisolated static func rollbackBackup(_ backup: URL, to dest: URL) {
        let fm = FileManager.default
        if fm.fileExists(atPath: dest.path) {
            // Collision: a racing writer recreated dest while we were restoring.
            // Remove the raced-in dest first so the move-back can succeed.
            try? fm.removeItem(at: dest)
        }
        do {
            try fm.moveItem(at: backup, to: dest)
        } catch {
            // Last resort: backup is stranded. Log so the user can recover manually.
            let msg = "BACKUP STRANDED at \(backup.path) — could not restore to \(dest.path): \(error.localizedDescription)\n"
            FileHandle.standardError.write(Data(msg.utf8))
        }
    }

    /// Deterministic hash over every entry inside `url`. Used so tampering inside
    /// a snapshot's directory components is detectable on restore. Entries are
    /// sorted by relative path before hashing so the result is stable across
    /// filesystems with different enumeration order.
    ///
    /// Encoding is length-prefixed binary framing so filenames that contain the
    /// previous separator characters (":" or "\n", both legal in HFS+/APFS) can
    /// no longer collide with a different tree. macOS only forbids "/" and NUL in
    /// filenames, so we cannot rely on textual separators for injectivity.
    private nonisolated static func directoryTreeHash(at url: URL) throws -> String {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey, .isDirectoryKey, .isSymbolicLinkKey]) else {
            return emptyTreeHash()
        }

        enum EntryKind: UInt8 {
            case file = 0x01
            case directory = 0x02
        }

        struct Entry {
            let relPath: String
            let kind: EntryKind
            let fileHash: String?  // hex, only for file
        }

        let rootPath = (url.path as NSString).standardizingPath
        let rootWithSlash = rootPath.hasSuffix("/") ? rootPath : rootPath + "/"

        var entries: [Entry] = []
        for case let item as URL in enumerator {
            let attrs = try item.resourceValues(forKeys: [.isRegularFileKey, .isDirectoryKey, .isSymbolicLinkKey])
            // Reject symlinks — a malicious snapshot could otherwise smuggle
            // pointers to live filesystem locations into the verified set.
            if attrs.isSymbolicLink == true {
                throw SnapshotError.invalidManifest("Symlink not allowed in snapshot directory: \(item.lastPathComponent)")
            }
            let stdPath = (item.path as NSString).standardizingPath
            let relPath = stdPath.hasPrefix(rootWithSlash) ? String(stdPath.dropFirst(rootWithSlash.count)) : item.lastPathComponent
            if attrs.isRegularFile == true {
                let hash = try Sha256Hasher.hash(file: item)
                entries.append(Entry(relPath: relPath, kind: .file, fileHash: hash))
            } else if attrs.isDirectory == true {
                entries.append(Entry(relPath: relPath, kind: .directory, fileHash: nil))
            } else {
                // Reject FIFOs, sockets, character/block devices — they have no
                // place inside an Application Support payload and could mask
                // tampering by being non-hashable.
                throw SnapshotError.invalidManifest("Unsupported file type in snapshot directory: \(item.lastPathComponent)")
            }
        }
        entries.sort { $0.relPath < $1.relPath }

        var hasher = SHA256()
        for entry in entries {
            let pathBytes = Array(entry.relPath.utf8)
            var lenBE = UInt64(pathBytes.count).bigEndian
            withUnsafeBytes(of: &lenBE) { hasher.update(data: Data($0)) }
            hasher.update(data: Data(pathBytes))
            hasher.update(data: Data([entry.kind.rawValue]))
            if entry.kind == .file, let hexHash = entry.fileHash {
                // Convert hex hash to raw bytes so the framing covers exactly
                // 32 bytes of content digest, not its 64-char textual form.
                var raw = [UInt8]()
                raw.reserveCapacity(32)
                var iterator = hexHash.makeIterator()
                while let hi = iterator.next(), let lo = iterator.next() {
                    if let byte = UInt8(String([hi, lo]), radix: 16) { raw.append(byte) }
                }
                hasher.update(data: Data(raw))
            }
        }
        return hasher.finalize().map { String(format: "%02x", $0) }.joined()
    }

    private nonisolated static func emptyTreeHash() -> String {
        SHA256.hash(data: Data()).map { String(format: "%02x", $0) }.joined()
    }
}
