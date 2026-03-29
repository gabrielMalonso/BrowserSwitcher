// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "BrowserSwitcher",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/sindresorhus/KeyboardShortcuts", from: "2.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "BrowserSwitcher",
            dependencies: ["KeyboardShortcuts"],
            resources: [
                .copy("Resources/MenuBarIcon.svg"),
                .copy("Resources/AppIcon.icns"),
            ]
        ),
    ]
)
