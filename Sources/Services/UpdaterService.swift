import Foundation
import Sparkle

@MainActor
final class UpdaterService {
    static let shared = UpdaterService()

    let updaterController: SPUStandardUpdaterController

    var canCheckForUpdates: Bool {
        updaterController.updater.canCheckForUpdates
    }

    func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }

    private init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }
}
