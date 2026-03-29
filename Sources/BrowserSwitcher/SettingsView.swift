import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    var body: some View {
        Form {
            Section("Keyboard Shortcut") {
                KeyboardShortcuts.Recorder("Switch Browser:", name: .switchBrowser)
                    .padding(.vertical, 4)

                Text("Press this shortcut anywhere to open the browser picker.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("About") {
                LabeledContent("Version", value: "1.0.0")
                LabeledContent("Default Shortcut", value: "Cmd + Shift + Option + B")
            }
        }
        .formStyle(.grouped)
        .frame(width: 400, height: 200)
    }
}
