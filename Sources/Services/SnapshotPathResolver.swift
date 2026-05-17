import Foundation

struct SnapshotPathResolver: Sendable {
    let bundleID: String
    let home: URL

    init(bundleID: String, home: URL = FileManager.default.homeDirectoryForCurrentUser) {
        self.bundleID = bundleID
        self.home = home
    }

    var groupContainerSearchRoot: URL { home.appendingPathComponent("Library/Group Containers") }

    func candidatePaths() -> [URL] {
        let lib = home.appendingPathComponent("Library")
        return [
            lib.appendingPathComponent("Preferences/\(bundleID).plist"),
            lib.appendingPathComponent("Application Support/\(bundleID)"),
            lib.appendingPathComponent("Containers/\(bundleID)"),
            lib.appendingPathComponent("Saved Application State/\(bundleID).savedState"),
            lib.appendingPathComponent("Caches/\(bundleID)"),
            lib.appendingPathComponent("WebKit/\(bundleID)"),
            lib.appendingPathComponent("HTTPStorages/\(bundleID)"),
            lib.appendingPathComponent("HTTPStorages/\(bundleID).binarycookies"),
            lib.appendingPathComponent("Cookies/\(bundleID).binarycookies")
        ]
    }

    func groupContainerPaths() -> [URL] {
        let root = groupContainerSearchRoot
        guard let contents = try? FileManager.default.contentsOfDirectory(at: root, includingPropertiesForKeys: nil) else {
            return []
        }
        return contents.filter { url in
            let name = url.lastPathComponent
            return name.contains(bundleID) ||
                   (bundleID.split(separator: ".").last.map { name.contains(String($0)) } ?? false)
        }
    }

    func existingPaths() -> [URL] {
        let all = candidatePaths() + groupContainerPaths()
        return all.filter { FileManager.default.fileExists(atPath: $0.path) }
    }
}
