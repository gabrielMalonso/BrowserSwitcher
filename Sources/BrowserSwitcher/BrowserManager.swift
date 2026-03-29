import AppKit
import UniformTypeIdentifiers

struct BrowserInfo: Identifiable, Hashable {
    let id: String // bundle identifier
    let name: String
    let url: URL
    let icon: NSImage

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: BrowserInfo, rhs: BrowserInfo) -> Bool {
        lhs.id == rhs.id
    }
}

@MainActor
class BrowserManager {
    static let shared = BrowserManager()

    func installedBrowsers() -> [BrowserInfo] {
        guard let httpsURL = URL(string: "https:") else { return [] }

        let httpsApps = NSWorkspace.shared.urlsForApplications(toOpen: httpsURL)
        let htmlApps = NSWorkspace.shared.urlsForApplications(toOpen: .html)

        // Intersection: apps that handle both HTTPS and HTML = real browsers
        let browserURLs = Set(httpsApps).intersection(htmlApps)

        return browserURLs.compactMap { appURL in
            guard let bundle = Bundle(url: appURL),
                  let bundleID = bundle.bundleIdentifier else { return nil }

            let name = bundle.infoDictionary?["CFBundleDisplayName"] as? String
                ?? bundle.infoDictionary?["CFBundleName"] as? String
                ?? appURL.deletingPathExtension().lastPathComponent

            let icon = NSWorkspace.shared.icon(forFile: appURL.path)
            icon.size = NSSize(width: 32, height: 32)

            return BrowserInfo(id: bundleID, name: name, url: appURL, icon: icon)
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func currentDefaultBrowserID() -> String? {
        guard let url = URL(string: "https://example.com"),
              let appURL = NSWorkspace.shared.urlForApplication(toOpen: url),
              let bundle = Bundle(url: appURL) else { return nil }
        return bundle.bundleIdentifier
    }

    func currentDefaultBrowserName() -> String {
        guard let url = URL(string: "https://example.com"),
              let appURL = NSWorkspace.shared.urlForApplication(toOpen: url),
              let bundle = Bundle(url: appURL) else { return "Unknown" }

        return bundle.infoDictionary?["CFBundleDisplayName"] as? String
            ?? bundle.infoDictionary?["CFBundleName"] as? String
            ?? "Unknown"
    }

    func setDefaultBrowser(_ browser: BrowserInfo, completion: @escaping (Bool) -> Void) {
        // Setting "http" is enough - macOS links http, https, and public.html together
        NSWorkspace.shared.setDefaultApplication(
            at: browser.url,
            toOpenURLsWithScheme: "http"
        ) { error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }
    }
}
