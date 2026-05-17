import XCTest
@testable import AutoBrew

final class SnapshotArchiverTests: XCTestCase {
    func testZipRoundTrip() async throws {
        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let src = tmp.appendingPathComponent("source")
        try FileManager.default.createDirectory(at: src, withIntermediateDirectories: true)
        try "hello".write(to: src.appendingPathComponent("a.txt"), atomically: true, encoding: .utf8)
        try FileManager.default.createDirectory(at: src.appendingPathComponent("sub"), withIntermediateDirectories: true)
        try "nested".write(to: src.appendingPathComponent("sub/b.txt"), atomically: true, encoding: .utf8)

        let zipURL = tmp.appendingPathComponent("snap.autobrewsnapshot")
        try await SnapshotArchiver.zip(directory: src, to: zipURL)
        XCTAssertTrue(FileManager.default.fileExists(atPath: zipURL.path))

        let dest = tmp.appendingPathComponent("dest")
        try await SnapshotArchiver.unzip(zipURL, to: dest)

        let a = try String(contentsOf: dest.appendingPathComponent("a.txt"))
        let b = try String(contentsOf: dest.appendingPathComponent("sub/b.txt"))
        XCTAssertEqual(a, "hello")
        XCTAssertEqual(b, "nested")

        try? FileManager.default.removeItem(at: tmp)
    }

    func testRejectsSymlinkInArchive() async throws {
        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let src = tmp.appendingPathComponent("source")
        try FileManager.default.createDirectory(at: src, withIntermediateDirectories: true)
        try "data".write(to: src.appendingPathComponent("real.txt"), atomically: true, encoding: .utf8)
        let symlink = src.appendingPathComponent("link")
        try FileManager.default.createSymbolicLink(at: symlink, withDestinationURL: URL(fileURLWithPath: "/etc/passwd"))

        let zipURL = tmp.appendingPathComponent("evil.autobrewsnapshot")
        try await SnapshotArchiver.zip(directory: src, to: zipURL)

        let dest = tmp.appendingPathComponent("dest")
        do {
            try await SnapshotArchiver.unzip(zipURL, to: dest)
            XCTFail("Should have rejected symlink in archive")
        } catch {
            XCTAssertTrue(String(describing: error).contains("Unsafe") || String(describing: error).contains("symlink"))
        }
        try? FileManager.default.removeItem(at: tmp)
    }
}
