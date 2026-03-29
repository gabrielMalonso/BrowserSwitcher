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
        // Hide from Dock and Cmd+Tab
        NSApp.setActivationPolicy(.accessory)

        KeyboardShortcuts.onKeyDown(for: .switchBrowser) { [weak self] in
            self?.togglePanel()
        }
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

        // Center on the active screen
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
