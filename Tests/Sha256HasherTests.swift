import XCTest
@testable import AutoBrew

final class Sha256HasherTests: XCTestCase {
    func testEmptyDataHash() throws {
        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try Data().write(to: tmp)
        defer { try? FileManager.default.removeItem(at: tmp) }
        let hash = try Sha256Hasher.hash(file: tmp)
        XCTAssertEqual(hash, "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    }

    func testKnownContent() throws {
        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try "hello".data(using: .utf8)!.write(to: tmp)
        defer { try? FileManager.default.removeItem(at: tmp) }
        let hash = try Sha256Hasher.hash(file: tmp)
        XCTAssertEqual(hash, "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824")
    }
}
