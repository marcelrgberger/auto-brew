import Foundation

struct RestoreList: Codable, Sendable {
    struct Entry: Codable, Hashable, Sendable {
        let bundleID: String
        let caskToken: String?
        let archiveFilename: String
    }

    let schemaVersion: Int
    let createdAt: Date
    let originHost: String
    let entries: [Entry]
}
