import os

enum AppLogger {
    static let subsystem = "za.co.digitalfreedom.AutoBrew"

    static func logger(category: String) -> Logger {
        Logger(subsystem: subsystem, category: category)
    }
}
