import Foundation

struct OutdatedPackage: Identifiable, Sendable {
    let name: String
    let currentVersion: String
    let newVersion: String
    let isCask: Bool

    var id: String { name }
}
