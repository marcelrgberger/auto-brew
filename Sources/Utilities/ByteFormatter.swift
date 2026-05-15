import Foundation

enum ByteFormatter {
    static func string(_ bytes: Int64) -> String {
        let fmt = ByteCountFormatter()
        fmt.allowedUnits = [.useAll]
        fmt.countStyle = .file
        return fmt.string(fromByteCount: bytes)
    }
}
