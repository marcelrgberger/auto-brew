import Foundation

struct SnapshotManifest: Codable, Sendable {
    let id: UUID
    let bundleID: String
    let displayName: String
    let caskToken: String?
    let sourceAppVersion: String?
    let createdAt: Date
    let originHost: String
    let originUser: String
    let schemaVersion: Int
    let components: [SnapshotComponent]
}
