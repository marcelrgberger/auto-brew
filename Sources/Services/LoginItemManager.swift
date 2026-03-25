import Foundation
import ServiceManagement
import os

enum LoginItemManager: Sendable {
    private static let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "LoginItem")

    static var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    static func setEnabled(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
                logger.info("Login item registered")
            } else {
                try SMAppService.mainApp.unregister()
                logger.info("Login item unregistered")
            }
        } catch {
            logger.error("Login item toggle failed: \(error.localizedDescription)")
        }
    }
}
