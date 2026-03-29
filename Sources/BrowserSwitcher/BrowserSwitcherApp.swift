import SwiftUI
import KeyboardShortcuts

@main
struct BrowserSwitcherApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Browser Switcher", systemImage: "globe") {
            MenuBarView(appDelegate: appDelegate)
        }

        Settings {
            SettingsView()
        }
    }
}

struct MenuBarView: View {
    let appDelegate: AppDelegate
    @State private var currentBrowser: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Default: \(currentBrowser)")
                .font(.headline)

            Divider()

            Button("Switch Browser...") {
                appDelegate.togglePanel()
            }
            .keyboardShortcut("b", modifiers: [.command])

            Divider()

            SettingsLink {
                Text("Settings...")
            }

            Button("Quit") {
                NSApp.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .onAppear {
            currentBrowser = BrowserManager.shared.currentDefaultBrowserName()
        }
    }
}
