import XCTest
@testable import AutoBrew

final class RestoreListTests: XCTestCase {
    func testRoundTripJSON() throws {
        let list = RestoreList(
            schemaVersion: 1,
            createdAt: Date(timeIntervalSince1970: 1_700_000_000),
            originHost: "MacA",
            entries: [
                .init(bundleID: "com.a.b", caskToken: "abc", archiveFilename: "com.a.b.autobrewsnapshot")
            ]
        )
        let data = try JSONEncoder.snapshotEncoder().encode(list)
        let back = try JSONDecoder.snapshotDecoder().decode(RestoreList.self, from: data)
        XCTAssertEqual(back.entries.count, 1)
        XCTAssertEqual(back.entries.first?.bundleID, "com.a.b")
    }
}
