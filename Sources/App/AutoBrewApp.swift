import SwiftUI

@main
struct AutoBrewApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var scheduler = SchedulerService.shared

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
        } label: {
            MenuBarIcon(state: scheduler.state)
                .modifier(OpenWindowOnNotification(windowID: "brewstore"))
        }
        .menuBarExtraStyle(.window)

        Window("BrewStore", id: "brewstore") {
            BrewStoreWindow()
                .modifier(OpenWindowOnNotification(windowID: "brewstore"))
        }
        .defaultSize(width: 1000, height: 680)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}

private struct OpenWindowOnNotification: ViewModifier {
    let windowID: String
    @Environment(\.openWindow) private var openWindow

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: .openBrewStoreWindow)) { _ in
                openWindow(id: windowID)
            }
    }
}
