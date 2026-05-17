import AppKit

extension NSSavePanel {
    // NSOpenPanel is a subclass of NSSavePanel, so this single extension covers both.
    @MainActor
    func runModalAsync() async -> NSApplication.ModalResponse {
        if let window = NSApp.keyWindow {
            return await withCheckedContinuation { cont in
                self.beginSheetModal(for: window) { cont.resume(returning: $0) }
            }
        } else {
            return await withCheckedContinuation { cont in
                self.begin { cont.resume(returning: $0) }
            }
        }
    }
}
