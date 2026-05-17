import AppKit
import os
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let logger = Logger(subsystem: "za.co.digitalfreedom.AutoBrew", category: "AppDelegate")

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleURLEvent(_:replyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )

        SupportPromptStore.shared.ensureInstallDate()

        Task { @MainActor in
            await NotificationManager.shared.requestAuthorization()
            if BrewManager.shared.isHomebrewInstalled {
                SchedulerService.shared.start()
            }
            logger.info("AutoBrew started (homebrew installed: \(BrewManager.shared.isHomebrewInstalled))")
        }
    }

    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue,
              let url = URL(string: urlString),
              url.scheme == "autobrew" else { return }
        logger.info("Handling URL: \(url.absoluteString, privacy: .public)")
        handle(url: url)
    }

    private func handle(url: URL) {
        switch url.host {
        case "open":
            requestOpenWindow()
        case "install":
            if let token = url.pathComponents.dropFirst().first,
               !token.isEmpty,
               isValidCaskToken(token) {
                Task {
                    await self.confirmAndInstall(token: token)
                }
                requestOpenWindow()
            } else {
                logger.warning("Rejected install URL with invalid token")
            }
        default:
            requestOpenWindow()
        }
    }

    private func isValidCaskToken(_ token: String) -> Bool {
        token.range(of: #"^[a-zA-Z0-9][a-zA-Z0-9._-]*$"#, options: .regularExpression) != nil
    }

    /// Prompt the user before running brew install in response to an external
    /// `autobrew://install/<token>` request. Without this guard a webpage could
    /// silently trigger installs simply by linking to the URL scheme.
    @MainActor
    private func confirmAndInstall(token: String) async {
        let alert = NSAlert()
        alert.messageText = String(localized: "Install \(token) via Homebrew?")
        alert.informativeText = String(localized: "An external request asked to install the cask \"\(token)\". Approve only if you trust the source.")
        alert.alertStyle = .warning
        alert.addButton(withTitle: String(localized: "Install"))
        alert.addButton(withTitle: String(localized: "Cancel"))

        NSApp.activate(ignoringOtherApps: true)
        let response = alert.runModal()
        guard response == .alertFirstButtonReturn else {
            logger.info("User declined URL-scheme install of \(token, privacy: .public)")
            return
        }
        do {
            try await BrewInstaller().install(token: token)
        } catch {
            logger.error("URL-scheme install failed for '\(token, privacy: .public)': \(error.localizedDescription, privacy: .public)")
        }
    }

    private func requestOpenWindow() {
        NSApp.activate(ignoringOtherApps: true)
        NotificationCenter.default.post(name: .openBrewStoreWindow, object: nil)
    }
}

extension Notification.Name {
    static let openBrewStoreWindow = Notification.Name("openBrewStoreWindow")
}
