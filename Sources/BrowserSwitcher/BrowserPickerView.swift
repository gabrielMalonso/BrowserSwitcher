import SwiftUI

struct BrowserPickerView: View {
    let onDismiss: () -> Void

    @State private var browsers: [BrowserInfo] = []
    @State private var currentBrowserID: String?
    @State private var switchingTo: String?
    @State private var feedback: String?

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "globe")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("Switch Default Browser")
                    .font(.headline)
                Spacer()
                Text("ESC to close")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()

            Divider()

            // Browser list
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(browsers) { browser in
                        BrowserRow(
                            browser: browser,
                            isDefault: browser.id == currentBrowserID,
                            isSwitching: switchingTo == browser.id
                        ) {
                            switchTo(browser)
                        }
                    }
                }
                .padding(8)
            }

            // Feedback
            if let feedback {
                Divider()
                Text(feedback)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            }
        }
        .frame(width: 340, height: 420)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear(perform: loadBrowsers)
        .onKeyPress(.escape) {
            onDismiss()
            return .handled
        }
    }

    private func loadBrowsers() {
        browsers = BrowserManager.shared.installedBrowsers()
        currentBrowserID = BrowserManager.shared.currentDefaultBrowserID()
    }

    private func switchTo(_ browser: BrowserInfo) {
        guard browser.id != currentBrowserID else { return }
        switchingTo = browser.id
        feedback = nil

        BrowserManager.shared.setDefaultBrowser(browser) { success in
            switchingTo = nil
            if success {
                currentBrowserID = browser.id
                feedback = "\(browser.name) is now your default browser"

                // Auto-dismiss after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    onDismiss()
                }
            } else {
                feedback = "Change cancelled or failed"
            }
        }
    }
}

struct BrowserRow: View {
    let browser: BrowserInfo
    let isDefault: Bool
    let isSwitching: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                Image(nsImage: browser.icon)
                    .resizable()
                    .frame(width: 32, height: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(browser.name)
                        .font(.body)
                        .foregroundStyle(.primary)

                    Text(browser.id)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                if isSwitching {
                    ProgressView()
                        .controlSize(.small)
                } else if isDefault {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title3)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isDefault ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDefault || isSwitching)
    }
}
