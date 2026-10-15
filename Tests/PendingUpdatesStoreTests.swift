import XCTest
@testable import AutoBrew

@MainActor
final class PendingUpdatesStoreTests: XCTestCase {
    private var tempURL: URL!
    private var store: PendingUpdatesStore!

    override func setUp() async throws {
        try await super.setUp()
        tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("PendingUpdatesStoreTests-\(UUID().uuidString).json")
        store = PendingUpdatesStore(fileURL: tempURL)
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tempURL)
        try await super.tearDown()
    }

    private func make(_ token: String, version: String, decision: ApprovalDecision = .pending,
                      kind: PackageKind = .cask) -> PendingUpdate {
        PendingUpdate(
            token: token,
            displayName: token,
            kind: kind,
            currentVersion: "1.0.0",
            availableVersion: version,
            bumpType: .major,
            firstSeen: Date(),
            decision: decision
        )
    }

    func testReplaceKeepsExistingDecisionWhenVersionMatches() {
        let approved = make("vscode", version: "2.0.0", decision: .approved(at: Date()))
        store.replace(with: [approved])
        XCTAssertEqual(store.updates.first?.decision.isApproved, true)

        // Same incoming version arrives again from the evaluator with .pending —
        // the store keeps the prior approval.
        let incoming = make("vscode", version: "2.0.0", decision: .pending)
        store.replace(with: [incoming])
        XCTAssertEqual(store.updates.count, 1)
        XCTAssertEqual(store.updates.first?.decision.isApproved, true)
    }

    func testReplaceResetsDecisionWhenVersionChanges() {
        let approved = make("vscode", version: "2.0.0", decision: .approved(at: Date()))
        store.replace(with: [approved])
        let newer = make("vscode", version: "3.0.0", decision: .pending)
        store.replace(with: [newer])
        XCTAssertEqual(store.updates.count, 1)
        XCTAssertEqual(store.updates.first?.availableVersion, "3.0.0")
        XCTAssertTrue(store.updates.first?.decision.isPending ?? false)
    }

    func testApproveAndRejectFlipDecision() {
        let entry = make("vscode", version: "2.0.0")
        store.replace(with: [entry])
        let id = store.updates.first!.id

        store.approve(id)
        XCTAssertTrue(store.updates.first?.decision.isApproved ?? false)

        store.reject(id)
        XCTAssertTrue(store.updates.first?.decision.isRejected ?? false)

        store.resetDecision(id)
        XCTAssertTrue(store.updates.first?.decision.isPending ?? false)
    }

    func testRemoveDropsListedKeysOnly() {
        // A cask and a formula may share a token; removing the cask's
        // entry must leave the formula's decision alone.
        store.replace(with: [
            make("node", version: "2.0.0", decision: .approved(at: Date()), kind: .cask),
            make("node", version: "22.0.0", decision: .rejected(at: Date()), kind: .formula),
            make("docker", version: "5.0.0")
        ])
        store.remove(keys: [PendingUpdatesStore.key(kind: .cask, token: "node")])
        XCTAssertEqual(store.updates.map(\.token), ["node", "docker"])
        XCTAssertEqual(store.updates.first?.kind, .formula)
        XCTAssertTrue(store.updates.first?.decision.isRejected ?? false)
    }

    func testPendingCountOnlyCountsPendingDecisions() {
        let approved = make("vscode", version: "2.0.0", decision: .approved(at: Date()))
        let pending = make("docker", version: "5.0.0")
        store.replace(with: [approved, pending])
        XCTAssertEqual(store.pendingCount, 1)
    }

    func testApprovedKeysAreBuiltFromApprovedEntries() {
        store.replace(with: [
            make("vscode", version: "2.0.0", decision: .approved(at: Date())),
            make("docker", version: "5.0.0", decision: .pending)
        ])
        XCTAssertEqual(store.approvedKeys, [PendingUpdatesStore.key(kind: .cask, token: "vscode")])
    }

    func testPersistsAcrossInstances() {
        store.replace(with: [make("vscode", version: "2.0.0", decision: .approved(at: Date()))])
        let reloaded = PendingUpdatesStore(fileURL: tempURL)
        XCTAssertEqual(reloaded.updates.count, 1)
        XCTAssertEqual(reloaded.updates.first?.token, "vscode")
        XCTAssertTrue(reloaded.updates.first?.decision.isApproved ?? false)
    }
}
