import Foundation

enum SnapshotArchiver {
    enum ArchiveError: LocalizedError {
        case zipFailed(String)
        case unzipFailed(String)

        var errorDescription: String? {
            switch self {
            case .zipFailed(let m): String(localized: "Zip failed: \(m)")
            case .unzipFailed(let m): String(localized: "Unzip failed: \(m)")
            }
        }
    }

    static func zip(directory: URL, to destination: URL) async throws {
        try await run(executable: "/usr/bin/ditto",
                      arguments: ["-c", "-k", "--sequesterRsrc", "--keepParent", directory.path, destination.path],
                      errorMap: ArchiveError.zipFailed)
    }

    static func unzip(_ archive: URL, to destination: URL) async throws {
        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        try await run(executable: "/usr/bin/ditto",
                      arguments: ["-x", "-k", archive.path, destination.path],
                      errorMap: ArchiveError.unzipFailed)
        // ditto packs with --keepParent into a single nested directory — flatten:
        let items = (try? FileManager.default.contentsOfDirectory(at: destination, includingPropertiesForKeys: nil)) ?? []
        if items.count == 1, let only = items.first,
           (try? only.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true {
            let children = (try? FileManager.default.contentsOfDirectory(at: only, includingPropertiesForKeys: nil)) ?? []
            for child in children {
                try FileManager.default.moveItem(at: child, to: destination.appendingPathComponent(child.lastPathComponent))
            }
            try FileManager.default.removeItem(at: only)
        }
    }

    private static func run(executable: String, arguments: [String], errorMap: @escaping @Sendable (String) -> ArchiveError) async throws {
        try await Task.detached(priority: .userInitiated) {
            let process = Process()
            let stderr = Pipe()
            process.executableURL = URL(fileURLWithPath: executable)
            process.arguments = arguments
            process.standardError = stderr
            process.standardOutput = Pipe()
            try process.run()
            process.waitUntilExit()
            if process.terminationStatus != 0 {
                let data = stderr.fileHandleForReading.readDataToEndOfFile()
                let msg = String(data: data, encoding: .utf8) ?? "exit \(process.terminationStatus)"
                throw errorMap(msg)
            }
        }.value
    }
}
