import XCTest
@testable import AutoBrew

final class SnapshotServiceTests: XCTestCase {
    private var tmp: URL!

    override func setUp() {
        super.setUp()
        tmp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
    }
    override func tearDown() { try? FileManager.default.removeItem(at: tmp); super.tearDown() }

    @MainActor
    func testCreateSnapshotCopiesExistingComponents() async throws {
        let home = tmp.appendingPathComponent("home")
        let bundleID = "com.example.test"
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try "<plist></plist>".data(using: .utf8)!.write(to: prefs.appendingPathComponent("\(bundleID).plist"))

        let appSupport = home.appendingPathComponent("Library/Application Support/\(bundleID)")
        try FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
        try "config".write(to: appSupport.appendingPathComponent("config.json"), atomically: true, encoding: .utf8)

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snapshots"), home: home)
        let snap = try await svc.createSnapshot(bundleID: bundleID, displayName: "Test", caskToken: "test-app", sourceAppVersion: "1.0")

        XCTAssertTrue(FileManager.default.fileExists(atPath: snap.manifestURL.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: snap.dataDir.appendingPathComponent("Library/Preferences/\(bundleID).plist").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: snap.dataDir.appendingPathComponent("Library/Application Support/\(bundleID)/config.json").path))

        let manifestData = try Data(contentsOf: snap.manifestURL)
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: manifestData)
        XCTAssertEqual(manifest.bundleID, bundleID)
        XCTAssertEqual(manifest.caskToken, "test-app")
        XCTAssertGreaterThan(manifest.components.count, 0)
    }

    @MainActor
    func testListReturnsCreatedSnapshots() async throws {
        let home = tmp.appendingPathComponent("home")
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try Data().write(to: prefs.appendingPathComponent("com.example.test.plist"))

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snapshots"), home: home)
        _ = try await svc.createSnapshot(bundleID: "com.example.test", displayName: "Test", caskToken: nil, sourceAppVersion: nil)

        let list = try svc.listSnapshots()
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.bundleID, "com.example.test")
    }

    @MainActor
    func testDeleteSnapshot() async throws {
        let home = tmp.appendingPathComponent("home")
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try Data().write(to: prefs.appendingPathComponent("com.example.del.plist"))

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snapshots"), home: home)
        let snap = try await svc.createSnapshot(bundleID: "com.example.del", displayName: "Del", caskToken: nil, sourceAppVersion: nil)

        XCTAssertTrue(FileManager.default.fileExists(atPath: snap.bundleURL.path))
        try svc.deleteSnapshot(snap)
        XCTAssertFalse(FileManager.default.fileExists(atPath: snap.bundleURL.path))
    }

    @MainActor
    func testRestoreCopiesBackToOriginalPaths() async throws {
        let home = tmp.appendingPathComponent("home")
        let bundleID = "com.example.restore"
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try "original".write(to: prefs.appendingPathComponent("\(bundleID).plist"), atomically: true, encoding: .utf8)

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snapshots"), home: home)
        let snap = try await svc.createSnapshot(bundleID: bundleID, displayName: "X", caskToken: nil, sourceAppVersion: nil)

        try "MODIFIED".write(to: prefs.appendingPathComponent("\(bundleID).plist"), atomically: true, encoding: .utf8)
        try await svc.restoreSnapshot(snap)

        let restored = try String(contentsOf: prefs.appendingPathComponent("\(bundleID).plist"))
        XCTAssertEqual(restored, "original")
    }

    @MainActor
    func testRestoreLeavesOriginalIntactWhenSourceMissing() async throws {
        let home = tmp.appendingPathComponent("home")
        let bundleID = "com.example.partial"
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try "live".write(to: prefs.appendingPathComponent("\(bundleID).plist"), atomically: true, encoding: .utf8)

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snap"), home: home)
        let snap = try await svc.createSnapshot(bundleID: bundleID, displayName: "X", caskToken: nil, sourceAppVersion: nil)

        // Sabotage: remove the snapshot's data file so restore tries to copy from a missing source.
        let sourceFile = snap.dataDir.appendingPathComponent("Library/Preferences/\(bundleID).plist")
        try FileManager.default.removeItem(at: sourceFile)

        do {
            try await svc.restoreSnapshot(snap)
            XCTFail("Restore should have thrown")
        } catch {
            // expected
        }

        // The live data must still be intact (not destroyed by removeItem).
        let stillThere = try String(contentsOf: prefs.appendingPathComponent("\(bundleID).plist"))
        XCTAssertEqual(stillThere, "live")
    }

    @MainActor
    func testExportImportRoundTrip() async throws {
        let home = tmp.appendingPathComponent("home")
        let bundleID = "com.example.export"
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try "value".write(to: prefs.appendingPathComponent("\(bundleID).plist"), atomically: true, encoding: .utf8)

        let svcA = SnapshotService(storageRoot: tmp.appendingPathComponent("snap-a"), home: home)
        let snap = try await svcA.createSnapshot(bundleID: bundleID, displayName: "Exp", caskToken: nil, sourceAppVersion: nil)

        let exportURL = tmp.appendingPathComponent("export.autobrewsnapshot")
        try await svcA.exportSnapshot(snap, to: exportURL)
        XCTAssertTrue(FileManager.default.fileExists(atPath: exportURL.path))

        let svcB = SnapshotService(storageRoot: tmp.appendingPathComponent("snap-b"), home: home)
        let imported = try await svcB.importSnapshot(from: exportURL)
        XCTAssertEqual(imported.bundleID, bundleID)
        XCTAssertEqual(imported.displayName, "Exp")
        XCTAssertTrue(FileManager.default.fileExists(atPath: imported.manifestURL.path))
    }

    @MainActor
    func testRestoreRejectsPathTraversalManifest() async throws {
        let home = tmp.appendingPathComponent("home")
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try Data().write(to: prefs.appendingPathComponent("com.test.attack.plist"))

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snap"), home: home)
        let snap = try await svc.createSnapshot(bundleID: "com.test.attack", displayName: "X", caskToken: nil, sourceAppVersion: nil)

        // Tamper the manifest to add a malicious component.
        let manifestData = try Data(contentsOf: snap.manifestURL)
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: manifestData)
        let evil = SnapshotComponent(
            originalPath: "~/../../etc/evil",
            relativeArchivePath: "Library/Preferences/com.test.attack.plist",
            kind: .file,
            sha256: nil,
            byteSize: 0
        )
        let tampered = SnapshotManifest(
            id: manifest.id, bundleID: manifest.bundleID, displayName: manifest.displayName,
            caskToken: manifest.caskToken, sourceAppVersion: manifest.sourceAppVersion,
            createdAt: manifest.createdAt, originHost: manifest.originHost, originUser: manifest.originUser,
            schemaVersion: manifest.schemaVersion, components: manifest.components + [evil]
        )
        try JSONEncoder.snapshotEncoder().encode(tampered).write(to: snap.manifestURL)

        do {
            try await svc.restoreSnapshot(snap)
            XCTFail("Restore should have thrown for path-traversal manifest")
        } catch {
            XCTAssertTrue(String(describing: error).contains("traversal") || String(describing: error).contains("Traversal"))
        }
    }

    @MainActor
    func testExportMultiRestoreList() async throws {
        let home = tmp.appendingPathComponent("home")
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try Data().write(to: prefs.appendingPathComponent("com.x.a.plist"))
        try Data().write(to: prefs.appendingPathComponent("com.x.b.plist"))

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snap"), home: home)
        let s1 = try await svc.createSnapshot(bundleID: "com.x.a", displayName: "A", caskToken: "a", sourceAppVersion: nil)
        let s2 = try await svc.createSnapshot(bundleID: "com.x.b", displayName: "B", caskToken: "b", sourceAppVersion: nil)

        let exportDir = tmp.appendingPathComponent("multi.autobrewbundle")
        try await svc.exportRestoreList(snapshots: [s1, s2], to: exportDir)

        let manifestData = try Data(contentsOf: exportDir.appendingPathComponent("restore_list.json"))
        let manifest = try JSONDecoder.snapshotDecoder().decode(RestoreList.self, from: manifestData)
        XCTAssertEqual(manifest.entries.count, 2)
        XCTAssertTrue(FileManager.default.fileExists(atPath: exportDir.appendingPathComponent(manifest.entries[0].archiveFilename).path))
    }

    @MainActor
    func testAutoCleanupRemovesOldSnapshots() async throws {
        let home = tmp.appendingPathComponent("home")
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try Data().write(to: prefs.appendingPathComponent("com.test.old.plist"))

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snap"), home: home)
        let snap = try await svc.createSnapshot(bundleID: "com.test.old", displayName: "Old", caskToken: nil, sourceAppVersion: nil)

        // Manifest auf 100 Tage zurückdatieren
        let oldDate = Date().addingTimeInterval(-100 * 86_400)
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: Data(contentsOf: snap.manifestURL))
        let updated = SnapshotManifest(
            id: manifest.id, bundleID: manifest.bundleID, displayName: manifest.displayName,
            caskToken: manifest.caskToken, sourceAppVersion: manifest.sourceAppVersion,
            createdAt: oldDate, originHost: manifest.originHost, originUser: manifest.originUser,
            schemaVersion: manifest.schemaVersion, components: manifest.components
        )
        try JSONEncoder.snapshotEncoder().encode(updated).write(to: snap.manifestURL)

        try svc.cleanup(olderThanDays: 90)
        let remaining = try svc.listSnapshots()
        XCTAssertEqual(remaining.count, 0)
    }

    @MainActor
    func testCreateSnapshotRejectsEmptyApp() async throws {
        let home = tmp.appendingPathComponent("home")
        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snap"), home: home)
        do {
            _ = try await svc.createSnapshot(bundleID: "com.example.nonexistent", displayName: "Empty", caskToken: nil, sourceAppVersion: nil)
            XCTFail("Should have rejected empty snapshot")
        } catch {
            XCTAssertTrue(String(describing: error).contains("No data"))
        }
    }

    @MainActor
    func testRestoreDetectsTamperedFileContents() async throws {
        let home = tmp.appendingPathComponent("home")
        let bundleID = "com.test.tamper"
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try "original".write(to: prefs.appendingPathComponent("\(bundleID).plist"), atomically: true, encoding: .utf8)

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snap"), home: home)
        let snap = try await svc.createSnapshot(bundleID: bundleID, displayName: "Tamper", caskToken: nil, sourceAppVersion: nil)

        // Tamper the file inside the snapshot
        let archivedFile = snap.dataDir.appendingPathComponent("Library/Preferences/\(bundleID).plist")
        try "TAMPERED".write(to: archivedFile, atomically: true, encoding: .utf8)

        do {
            try await svc.restoreSnapshot(snap)
            XCTFail("Restore should have detected tampered file")
        } catch {
            XCTAssertTrue(String(describing: error).contains("Hash mismatch") || String(describing: error).contains("mismatch"))
        }
        // Original must be untouched
        let stillThere = try String(contentsOf: prefs.appendingPathComponent("\(bundleID).plist"))
        XCTAssertEqual(stillThere, "original")
    }

    @MainActor
    func testRestoreDetectsTamperedDirectoryContents() async throws {
        let home = tmp.appendingPathComponent("home")
        let bundleID = "com.test.dirtamper"
        let appSupport = home.appendingPathComponent("Library/Application Support/\(bundleID)")
        try FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
        try "original".write(to: appSupport.appendingPathComponent("file1.txt"), atomically: true, encoding: .utf8)
        try "original2".write(to: appSupport.appendingPathComponent("file2.txt"), atomically: true, encoding: .utf8)

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snap"), home: home)
        let snap = try await svc.createSnapshot(bundleID: bundleID, displayName: "DirTamper", caskToken: nil, sourceAppVersion: nil)

        // Tamper a file inside the snapshot directory
        let archivedFile = snap.dataDir.appendingPathComponent("Library/Application Support/\(bundleID)/file1.txt")
        try "TAMPERED".write(to: archivedFile, atomically: true, encoding: .utf8)

        do {
            try await svc.restoreSnapshot(snap)
            XCTFail("Restore should have detected tampered directory contents")
        } catch {
            XCTAssertTrue(String(describing: error).contains("Tree hash") || String(describing: error).contains("mismatch"))
        }
        // Original must be untouched
        let stillThere = try String(contentsOf: appSupport.appendingPathComponent("file1.txt"))
        XCTAssertEqual(stillThere, "original")
    }

    @MainActor
    func testTreeHashRejectsFilenameWithControlCharacters() async throws {
        let home = tmp.appendingPathComponent("home")
        let bundleID = "com.test.injectivity"
        let appSupport = home.appendingPathComponent("Library/Application Support/\(bundleID)")
        try FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
        // A filename containing the old hash separator ":" and a newline — would have collided in v1 encoding
        try "x".write(to: appSupport.appendingPathComponent("a:b\nc.txt"), atomically: true, encoding: .utf8)
        try "y".write(to: appSupport.appendingPathComponent("a.txt"), atomically: true, encoding: .utf8)

        let svc = SnapshotService(storageRoot: tmp.appendingPathComponent("snap"), home: home)
        let snap = try await svc.createSnapshot(bundleID: bundleID, displayName: "Inj", caskToken: nil, sourceAppVersion: nil)

        // Snapshot was created with new encoding — replace file contents to force a mismatch
        let archivedFile = snap.dataDir.appendingPathComponent("Library/Application Support/\(bundleID)/a.txt")
        try "DIFFERENT".write(to: archivedFile, atomically: true, encoding: .utf8)

        do {
            try await svc.restoreSnapshot(snap)
            XCTFail("Tree hash should detect content change")
        } catch {
            XCTAssertTrue(String(describing: error).contains("Tree hash") || String(describing: error).contains("mismatch"))
        }
    }

    @MainActor
    func testImportRejectsEmptyManifest() async throws {
        let home = tmp.appendingPathComponent("home")
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try Data().write(to: prefs.appendingPathComponent("com.test.empty.plist"))

        let svcA = SnapshotService(storageRoot: tmp.appendingPathComponent("snap-a"), home: home)
        let snap = try await svcA.createSnapshot(bundleID: "com.test.empty", displayName: "E", caskToken: nil, sourceAppVersion: nil)

        // Export then tamper to clear components
        let exportURL = tmp.appendingPathComponent("e.autobrewsnapshot")
        try await svcA.exportSnapshot(snap, to: exportURL)

        let extractDir = tmp.appendingPathComponent("extract-e")
        try FileManager.default.createDirectory(at: extractDir, withIntermediateDirectories: true)
        try await SnapshotArchiver.unzip(exportURL, to: extractDir)
        let manifestURL = extractDir.appendingPathComponent("manifest.json")
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: Data(contentsOf: manifestURL))
        let tampered = SnapshotManifest(
            id: manifest.id, bundleID: manifest.bundleID, displayName: manifest.displayName,
            caskToken: manifest.caskToken, sourceAppVersion: manifest.sourceAppVersion,
            createdAt: manifest.createdAt, originHost: manifest.originHost, originUser: manifest.originUser,
            schemaVersion: manifest.schemaVersion, components: []
        )
        try JSONEncoder.snapshotEncoder().encode(tampered).write(to: manifestURL)

        let tamperedZip = tmp.appendingPathComponent("e-tampered.autobrewsnapshot")
        try await SnapshotArchiver.zip(directory: extractDir, to: tamperedZip)

        let svcB = SnapshotService(storageRoot: tmp.appendingPathComponent("snap-b"), home: home)
        do {
            _ = try await svcB.importSnapshot(from: tamperedZip)
            XCTFail("Should reject empty manifest on import")
        } catch {
            XCTAssertTrue(String(describing: error).contains("no components"))
        }
    }

    @MainActor
    func testImportRejectsBundleIDPathTraversal() async throws {
        let home = tmp.appendingPathComponent("home")
        let prefs = home.appendingPathComponent("Library/Preferences")
        try FileManager.default.createDirectory(at: prefs, withIntermediateDirectories: true)
        try Data().write(to: prefs.appendingPathComponent("com.test.bid.plist"))

        let svcA = SnapshotService(storageRoot: tmp.appendingPathComponent("snap-a"), home: home)
        let snap = try await svcA.createSnapshot(bundleID: "com.test.bid", displayName: "X", caskToken: nil, sourceAppVersion: nil)

        // Export valid snapshot to archive
        let exportURL = tmp.appendingPathComponent("bad.autobrewsnapshot")
        try await svcA.exportSnapshot(snap, to: exportURL)

        // Tamper: extract, rewrite manifest bundleID to a traversal payload, re-zip
        let extractDir = tmp.appendingPathComponent("extract")
        try FileManager.default.createDirectory(at: extractDir, withIntermediateDirectories: true)
        try await SnapshotArchiver.unzip(exportURL, to: extractDir)

        let manifestURL = extractDir.appendingPathComponent("manifest.json")
        let manifest = try JSONDecoder.snapshotDecoder().decode(SnapshotManifest.self, from: Data(contentsOf: manifestURL))
        let tampered = SnapshotManifest(
            id: manifest.id, bundleID: "../../../tmp/evil", displayName: manifest.displayName,
            caskToken: manifest.caskToken, sourceAppVersion: manifest.sourceAppVersion,
            createdAt: manifest.createdAt, originHost: manifest.originHost, originUser: manifest.originUser,
            schemaVersion: manifest.schemaVersion, components: manifest.components
        )
        try JSONEncoder.snapshotEncoder().encode(tampered).write(to: manifestURL)

        let tamperedZip = tmp.appendingPathComponent("tampered.autobrewsnapshot")
        try await SnapshotArchiver.zip(directory: extractDir, to: tamperedZip)

        let svcB = SnapshotService(storageRoot: tmp.appendingPathComponent("snap-b"), home: home)
        do {
            _ = try await svcB.importSnapshot(from: tamperedZip)
            XCTFail("Import should have rejected the tampered bundleID")
        } catch {
            let msg = String(describing: error)
            XCTAssertTrue(msg.contains("Invalid bundleID") || msg.contains("invalid"))
        }
    }
}
