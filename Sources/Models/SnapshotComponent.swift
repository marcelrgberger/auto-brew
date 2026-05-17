import Foundation

struct SnapshotComponent: Codable, Hashable, Sendable {
    enum Kind: String, Codable, Sendable { case file, directory }
    let originalPath: String       // mit ~ als Home-Platzhalter
    let relativeArchivePath: String // Pfad innerhalb data/
    let kind: Kind
    let sha256: String?            // nur bei Dateien
    let byteSize: Int64
}
