import Foundation

struct AppSnapshot: Identifiable, Hashable, Sendable {
    let id: UUID
    let bundleID: String
    let displayName: String
    let createdAt: Date
    let caskToken: String?
    let sourceAppVersion: String?
    let totalBytes: Int64
    let bundleURL: URL

    var manifestURL: URL { bundleURL.appendingPathComponent("manifest.json") }
    var dataDir: URL { bundleURL.appendingPathComponent("data", isDirectory: true) }
}
