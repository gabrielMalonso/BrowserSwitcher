import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    @State private var launchAtLogin = LaunchAtLogin.isEnabled
    @AppStorage("showMenuBarIcon") private var showMenuBarIcon = true

    var body: some View {
        Form {
            Section("General") {
                Toggle("Launch at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, newValue in
                        do {
                            if newValue {
                                try LaunchAtLogin.enable()
                            } else {
                                try LaunchAtLogin.disable()
                            }
                        } catch {
                            launchAtLogin = !newValue
                        }
                    }

                Toggle("Show menu bar icon", isOn: $showMenuBarIcon)

                KeyboardShortcuts.Recorder("Switch Browser:", name: .switchBrowser)
                    .padding(.vertical, 4)
            }

            Section("About") {
                Text("If the menu bar icon is hidden, use the global shortcut or reopen the app from Spotlight to access this panel.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                LabeledContent("Version", value: "1.0.0")
            }
        }
        .formStyle(.grouped)
        .frame(width: 400, height: 400)
    }
}
