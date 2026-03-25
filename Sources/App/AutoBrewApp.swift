import SwiftUI

@main
struct AutoBrewApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        MenuBarExtra("AutoBrew", systemImage: "mug.fill") {
            MenuBarView()
        }
        .menuBarExtraStyle(.window)
    }
}
