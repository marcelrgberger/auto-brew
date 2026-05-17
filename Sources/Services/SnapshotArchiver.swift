import Foundation

enum SnapshotArchiver {
    enum ArchiveError: LocalizedError {
        case zipFailed(String)
        case unzipFailed(String)
        case unsafeContent(String)

        var errorDescription: String? {
            switch self {
            case .zipFailed(let m): String(localized: "Zip failed: \(m)")
            case .unzipFailed(let m): String(localized: "Unzip failed: \(m)")
            case .unsafeContent(let m): String(localized: "Unsafe archive content: \(m)")
            }
        }
    }

    static func zip(directory: URL, to destination: URL) async throws {
        try await run(executable: "/usr/bin/ditto",
                      arguments: ["-c", "-k", "--sequesterRsrc", "--keepParent", directory.path, destination.path],
                      errorMap: { ArchiveError.zipFailed($0) })
    }

    static func unzip(_ archive: URL, to destination: URL) async throws {
        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        try await run(executable: "/usr/bin/ditto",
                      arguments: ["-x", "-k", archive.path, destination.path],
                      errorMap: { ArchiveError.unzipFailed($0) })

        // Defence-in-depth: reject symlinks and any path that resolves outside the destination
        // before any callers can act on the extracted contents.
        do {
            try validateExtraction(at: destination)
        } catch {
            try? FileManager.default.removeItem(at: destination)
            throw error
        }

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

    /// Walk the extracted tree and reject symlinks or paths that resolve outside `root`.
    /// Defeats zip-slip payloads and stops symlink-based traversal during downstream copy operations.
    static func validateExtraction(at root: URL) throws {
        let fm = FileManager.default
        let rootStandardized = (root.path as NSString).standardizingPath
        let rootWithSlash = rootStandardized.hasSuffix("/") ? rootStandardized : rootStandardized + "/"

        guard let enumerator = fm.enumerator(
            at: root,
            includingPropertiesForKeys: [.isSymbolicLinkKey],
            options: [],
            errorHandler: nil
        ) else {
            return
        }

        for case let item as URL in enumerator {
            let values = try item.resourceValues(forKeys: [.isSymbolicLinkKey])
            if values.isSymbolicLink == true {
                throw ArchiveError.unsafeContent("symlink at \(item.path)")
            }
            // Fallback: even if URLResourceValues does not flag a symlink (e.g. dead link),
            // the POSIX attributes do — guard against both representations.
            let attrs = try fm.attributesOfItem(atPath: item.path)
            if let type = attrs[.type] as? FileAttributeType, type == .typeSymbolicLink {
                throw ArchiveError.unsafeContent("symlink at \(item.path)")
            }
            let itemStandardized = (item.path as NSString).standardizingPath
            guard itemStandardized == rootStandardized || itemStandardized.hasPrefix(rootWithSlash) else {
                throw ArchiveError.unsafeContent("path escapes destination: \(itemStandardized)")
            }
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
