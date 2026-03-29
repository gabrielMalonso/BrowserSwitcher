# BrowserSwitcher

A lightweight macOS menu bar utility to switch your default browser with a global keyboard shortcut.

![macOS 14+](https://img.shields.io/badge/macOS-14%2B-blue)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange)
![License: MIT](https://img.shields.io/badge/License-MIT-green)

## Features

- Lives in the menu bar -- no Dock icon, no Cmd+Tab clutter
- Global keyboard shortcut to open the browser picker from anywhere
- Shows all installed browsers with their icons
- Highlights the current default browser
- Customizable shortcut via Settings
- Built with SwiftUI and AppKit

## Screenshot

<p align="center">
  <img src="assets/screenshot.png" width="360" alt="BrowserSwitcher popup showing installed browsers">
</p>

## Installation

### From source

```bash
git clone https://github.com/gabrielMalonso/BrowserSwitcher.git
cd BrowserSwitcher
swift build -c release
cp .build/release/BrowserSwitcher /usr/local/bin/
```

Then run `BrowserSwitcher` from the terminal. It will appear in your menu bar.

### From Xcode

1. Clone the repository
2. Open `Package.swift` in Xcode
3. Build and run (Cmd+R)

## Usage

| Action | How |
|---|---|
| Open browser picker | **Cmd + Shift + Option + B** (default) |
| Close picker | **ESC** or click outside |
| Switch browser | Click on the desired browser |
| Change shortcut | Menu bar icon > Settings |
| Quit | Menu bar icon > Quit |

> **Note:** macOS shows a native confirmation dialog when changing the default browser. This is a system-level protection and cannot be bypassed.

## Requirements

- macOS 14 (Sonoma) or later
- The app must run **outside** the sandbox (it cannot be distributed via the Mac App Store)

## How it works

- Uses `NSWorkspace.urlsForApplications(toOpen:)` to discover installed browsers by intersecting apps that handle both `https:` URLs and `.html` content types
- Uses `NSWorkspace.setDefaultApplication(at:toOpenURLsWithScheme:completion:)` to change the default browser (setting `http` is enough -- macOS links `http`, `https`, and `public.html` together)
- Uses [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts) by [@sindresorhus](https://github.com/sindresorhus) for global hotkey registration without requiring Accessibility permissions
- Uses a floating `NSPanel` for the picker popup

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
