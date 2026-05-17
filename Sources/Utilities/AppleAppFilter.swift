import Foundation

enum AppleAppFilter {
    static func isAppleSystemApp(bundleID: String) -> Bool {
        bundleID.hasPrefix("com.apple.")
    }
}
