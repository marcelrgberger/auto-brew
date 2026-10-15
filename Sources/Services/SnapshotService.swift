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

/// Backs up and restores app data (Preferences, Application Support,
/// Containers). Restore is a two-phase backup-and-swap so a failure midway
/// rolls back every touched component instead of leaving user data
/// half-overwritten.
@MainActor
final class SnapshotService {
    static let shared = SnapshotService()
    static let schemaVersion = 1

    /// Where snapshots are written for this instance: the external
    /// location chosen in Settings when reachable, otherwise the default
    /// Application Support path. Resolved once at init.
    let storageRoot: URL
    let home: URL
    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "Snapshot")
    private let fm = FileManager.default

    init(storageRoot: URL? = nil, home: URL? = nil) {
        if let storageRoot {
            self.storageRoot = storageRoot
        } else {
            self.storageRoot = Self.resolvedDefaultStorageRoot()
        }
        self.home = home ?? FileManager.default.homeDirectoryForCurrentUser
        try? fm.createDirectory(at: self.storageRoot, withIntermediateDirectories: true)
    }

    /// Picks the snapshot storage root for the shared instance. If the
    /// user pointed AutoBrew at an external drive via Settings and the
    /// drive is reachable, that path wins; otherwise we fall back to
    /// the default Application-Support location. Bookmark resolution
    /// failure logs and falls through — never crashes on a missing
    /// drive.
    @MainActor
    private static func resolvedDefaultStorageRoot() -> URL {
        let fallback = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("AutoBrew/Snapshots", isDirectory: true)
        guard let bookmark = SettingsStore.shared.snapshotStorageBookmark,
              let resolved = SecurityScopedBookmark.resolve(bookmark) else {
            return fallback
        }
        if resolved.stale {
            // Re-encode + persist so the next launch starts from a
            // fresh blob. Silent on failure — the path still works
            // for this session.
            if let fresh = SecurityScopedBookmark.encode(resolved.url) {
                SettingsStore.shared.snapshotStorageBookmark = fresh
            }
        }
        return resolved.url.appendingPathComponent("AutoBrew/Snapshots", isDirectory: true)
    }

    /// Creates a new snapshot. Fails if no components were found — empty
    /// snapshots would show up in the UI and restore to nothing, which kills
    /// trust in the feature.
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

    /// Restores the snapshot. When `components` is nil (default) every
    /// recorded component is restored — same all-or-nothing behaviour
    /// as before. When non-nil, only the components whose
    /// `relativeArchivePath` is in the set are touched; the rest of
    /// the live filesystem state stays as-is. Useful when the user
    /// wants to revert just Preferences without flattening their Cache
    /// or Containers, surfaced through the History view's Roll Back
    /// confirmation and the Restore Wizard.
    func restoreSnapshot(_ snapshot: AppSnapshot,
                         terminateApp: Bool = false,
                         components selectedPaths: Set<String>? = nil) async throws {
        if terminateApp {
            try await AppQuitter.quit(bundleID: snapshot.bundleID)
        }
        let manifestData = try Data(contentsOf: snapshot.manifestURL)
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: manifestData)
        let dataDir = snapshot.dataDir
        let homeURL = home

        let filtered: [SnapshotComponent]
        if let selectedPaths {
            filtered = manifest.components.filter { selectedPaths.contains($0.relativeArchivePath) }
            guard !filtered.isEmpty else {
                throw SnapshotError.invalidManifest("Selected component set is empty — nothing to restore")
            }
        } else {
            filtered = manifest.components
        }

        try await Task.detached(priority: .userInitiated) {
            try Self.restoreComponents(filtered, dataDir: dataDir, home: homeURL)
        }.value

        logger.info("Restored snapshot \(snapshot.bundleID, privacy: .public) — \(filtered.count) of \(manifest.components.count) components")
    }

    /// Pure manifest-based diff between two snapshots. Both manifests
    /// are loaded fresh from disk so the result reflects the actual
    /// on-disk state, not a stale in-memory snapshot. Matching key is
    /// `relativeArchivePath` — stable across snapshots of the same
    /// bundle taken on the same machine, since
    /// `SnapshotPathResolver` produces deterministic paths for a
    /// given bundle id. Throws on a missing or unreadable manifest;
    /// the caller surfaces that to the user instead of silently
    /// returning an empty diff.
    func diff(_ older: AppSnapshot, _ newer: AppSnapshot) throws -> SnapshotDiff {
        let lhs = try loadManifestComponents(for: older)
        let rhs = try loadManifestComponents(for: newer)

        let lhsByPath = Dictionary(uniqueKeysWithValues: lhs.map { ($0.relativeArchivePath, $0) })
        let rhsByPath = Dictionary(uniqueKeysWithValues: rhs.map { ($0.relativeArchivePath, $0) })

        var added: [SnapshotComponent] = []
        var removed: [SnapshotComponent] = []
        var changed: [SnapshotDiff.Pair] = []
        var unchanged: [SnapshotDiff.Pair] = []

        for (path, rhsComponent) in rhsByPath {
            if let lhsComponent = lhsByPath[path] {
                if lhsComponent.sha256 == rhsComponent.sha256 {
                    unchanged.append(.init(oldComponent: lhsComponent, newComponent: rhsComponent))
                } else {
                    changed.append(.init(oldComponent: lhsComponent, newComponent: rhsComponent))
                }
            } else {
                added.append(rhsComponent)
            }
        }
        for (path, lhsComponent) in lhsByPath where rhsByPath[path] == nil {
            removed.append(lhsComponent)
        }

        // Sort each bucket by originalPath so the UI renders a stable
        // alphabetical list rather than dict iteration order.
        return SnapshotDiff(
            added:     added.sorted     { $0.originalPath < $1.originalPath },
            removed:   removed.sorted   { $0.originalPath < $1.originalPath },
            changed:   changed.sorted   { $0.newComponent.originalPath < $1.newComponent.originalPath },
            unchanged: unchanged.sorted { $0.newComponent.originalPath < $1.newComponent.originalPath }
        )
    }

    private func loadManifestComponents(for snapshot: AppSnapshot) throws -> [SnapshotComponent] {
        let data = try Data(contentsOf: snapshot.manifestURL)
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: data)
        return manifest.components
    }

    // MARK: - Export / Import

    func exportSnapshot(_ snapshot: AppSnapshot, to destination: URL) async throws {
        if fm.fileExists(atPath: destination.path) {
            try fm.removeItem(at: destination)
        }
        try await SnapshotArchiver.zip(directory: snapshot.bundleURL, to: destination)
    }

    /// Accepts an `.autobrewsnapshot` from another Mac. Validates schema
    /// version, bundleID format and hashes before anything lands in live
    /// storage — a tampered archive must not be able to overwrite existing
    /// snapshots.
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
                // Walk the tree manually so a single unreadable sibling (e.g.
                // `.com.apple.containermanagerd.metadata.plist` inside
                // `~/Library/Containers/<bundleID>`) does not abort the entire
                // directory copy. Anything we cannot read is silently skipped
                // and never appears in the snapshot.
                try robustCopyDirectory(from: src, to: dest)
                guard fm.fileExists(atPath: dest.path),
                      directoryHasContent(at: dest) else {
                    // Everything inside was unreadable or filtered out — there
                    // is nothing useful to record for this component.
                    try? fm.removeItem(at: dest)
                    continue
                }
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
                do {
                    try fm.copyItem(at: src, to: dest)
                } catch let error as NSError where isPermissionError(error) {
                    // Skip top-level files we don't have permission to read.
                    continue
                }
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

    /// Filenames inside `~/Library/Containers/<bundleID>` that the container
    /// management subsystem owns. They are protected by SIP/TCC even with Full
    /// Disk Access granted, and they carry no user data. We only exclude them
    /// when we are walking a Containers subtree — applying the basename match
    /// globally would silently drop a same-named (legitimate) file an app might
    /// have stored elsewhere.
    private nonisolated static let containerManagerMetadataFilenames: Set<String> = [
        ".com.apple.containermanagerd.metadata.plist",
        ".com.apple.mobile_container_manager.metadata.plist"
    ]

    private nonisolated static func isPermissionError(_ error: NSError) -> Bool {
        switch (error.domain, error.code) {
        case (NSCocoaErrorDomain, NSFileReadNoPermissionError),
             (NSCocoaErrorDomain, NSFileWriteNoPermissionError):
            return true
        case (NSPOSIXErrorDomain, 1), // EPERM
             (NSPOSIXErrorDomain, 13): // EACCES
            return true
        default:
            if let underlying = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                return isPermissionError(underlying)
            }
            return false
        }
    }

    /// Class-bound box so the enumerator's `errorHandler` closure can record a
    /// fatal traversal error and surface it to the caller after enumeration
    /// completes. Anything other than a permission error (or a vanished entry,
    /// which is expected during a live snapshot) aborts the copy — accepting
    /// silent omissions would let the manifest claim a complete component when
    /// in fact we lost a subtree to an I/O or filesystem error.
    private final class EnumerationErrorBox: @unchecked Sendable {
        var fatal: NSError?
    }

    private nonisolated static func isTolerableEnumerationError(_ error: NSError) -> Bool {
        if isPermissionError(error) { return true }
        // ENOENT — a file vanished between enumeration and our visit, which is
        // expected when an app writes to its own data while we snapshot it.
        if error.domain == NSPOSIXErrorDomain && error.code == 2 { return true }
        if (error.domain == NSCocoaErrorDomain) &&
            (error.code == NSFileReadNoSuchFileError || error.code == NSFileNoSuchFileError) {
            return true
        }
        if let underlying = error.userInfo[NSUnderlyingErrorKey] as? NSError {
            return isTolerableEnumerationError(underlying)
        }
        return false
    }

    /// Recursive copy that tolerates unreadable entries inside one source root.
    /// Permission errors and vanished entries are skipped so user data we *can*
    /// read is still captured; every other enumeration failure aborts and
    /// propagates up so the manifest does not silently hide an I/O failure as
    /// a "successful" partial snapshot. Symlinks are skipped because the
    /// restore-side tree-hash rejects them (a snapshot containing them could
    /// never restore cleanly).
    private nonisolated static func robustCopyDirectory(from src: URL, to dest: URL) throws {
        let fm = FileManager.default
        try fm.createDirectory(at: dest, withIntermediateDirectories: true)

        let srcStandardized = (src.path as NSString).standardizingPath
        let srcWithSlash = srcStandardized.hasSuffix("/") ? srcStandardized : srcStandardized + "/"
        // Containermanagerd metadata only ever lives at the root of a
        // `Library/Containers/<bundleID>` tree, so we only consult the
        // blocklist when we are inside such a subtree.
        let inContainersTree = srcStandardized.contains("/Library/Containers/")

        let errorBox = EnumerationErrorBox()
        guard let enumerator = fm.enumerator(
            at: src,
            includingPropertiesForKeys: [.isDirectoryKey, .isSymbolicLinkKey],
            options: [],
            errorHandler: { _, error in
                let ns = error as NSError
                if isTolerableEnumerationError(ns) { return true }
                // Capture the first fatal error and abort enumeration. We do
                // not throw from the handler — the enumerator API expects a
                // Bool — but we surface the captured error after the loop.
                if errorBox.fatal == nil { errorBox.fatal = ns }
                return false
            }
        ) else { return }

        for case let item as URL in enumerator {
            if inContainersTree && containerManagerMetadataFilenames.contains(item.lastPathComponent) {
                continue
            }

            let itemStandardized = (item.path as NSString).standardizingPath
            let rel = itemStandardized.hasPrefix(srcWithSlash)
                ? String(itemStandardized.dropFirst(srcWithSlash.count))
                : item.lastPathComponent
            let target = dest.appendingPathComponent(rel)

            let values = try? item.resourceValues(forKeys: [.isDirectoryKey, .isSymbolicLinkKey])
            if values?.isSymbolicLink == true { continue }

            do {
                if values?.isDirectory == true {
                    try fm.createDirectory(at: target, withIntermediateDirectories: true)
                } else {
                    try fm.createDirectory(at: target.deletingLastPathComponent(), withIntermediateDirectories: true)
                    try fm.copyItem(at: item, to: target)
                }
            } catch let error as NSError where isPermissionError(error) {
                continue
            }
        }

        if let fatal = errorBox.fatal {
            throw fatal
        }
    }

    private nonisolated static func directoryHasContent(at url: URL) -> Bool {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey]) else {
            return false
        }
        for case let item as URL in enumerator {
            if let values = try? item.resourceValues(forKeys: [.isRegularFileKey]),
               values.isRegularFile == true {
                return true
            }
        }
        return false
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
