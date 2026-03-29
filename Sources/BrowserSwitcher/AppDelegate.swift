import AppKit
import SwiftUI
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let switchBrowser = Self(
        "switchBrowser",
        default: .init(.b, modifiers: [.command, .shift, .option])
    )
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: FloatingPanel?
    private var isShowing = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        if let icnsURL = Bundle.module.url(forResource: "AppIcon", withExtension: "icns"),
           let icon = NSImage(contentsOf: icnsURL) {
            NSApp.applicationIconImage = icon
        }

        KeyboardShortcuts.onKeyDown(for: .switchBrowser) { [weak self] in
            self?.togglePanel()
        }
    }

    /// Called when the user re-opens the app (e.g. from Spotlight) while it's already running.
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        togglePanel()
        return false
    }

    func togglePanel() {
        if isShowing, let panel {
            panel.close()
            isShowing = false
            return
        }

        let panel = FloatingPanel {
            BrowserPickerView {
                self.closePanel()
            }
        }
        self.panel = panel

        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let panelFrame = panel.frame
            let x = screenFrame.midX - panelFrame.width / 2
            let y = screenFrame.midY - panelFrame.height / 2
            panel.setFrameOrigin(NSPoint(x: x, y: y))
        }

        panel.orderFrontRegardless()
        panel.makeKey()
        NSApp.activate()
        isShowing = true
    }

    private func closePanel() {
        panel?.close()
        panel = nil
        isShowing = false
    }
}
