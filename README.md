# HermesHQ

<p align="center">
  <img src="assets/icon.png" width="128" alt="HermesHQ">
</p>

**Native macOS & iOS companion for [Hermes Agent](https://github.com/NousResearch/hermes-agent).**

Displays your Hermes dashboard in a native WebView with connectivity
monitoring, menubar status, and notifications — no browser needed.

## Why HermesHQ?

You run Hermes on a VPS behind Tailscale. The official dashboard works in
a browser, but you want:

- A real app in your Dock with its own icon
- Menubar status indicator (green = server up, red = down)
- Desktop notifications when the server goes offline or comes back
- Configurable server URL (your IP, your port)
- Open source, MIT licensed

HermesHQ is a thin native wrapper around the dashboard WebUI. No extra
backend, no sync layer, no Electron bloat — just Swift + WebKit.

## Features

| Feature | macOS | iOS |
|---|---|---|
| Dashboard in WebView | ✅ | ✅ |
| Menubar status | ✅ | — |
| Server health check | ✅ | ✅ |
| Push notifications | ✅ | ✅ |
| Configurable URL | ✅ | ✅ |
| Dark/light mode | ✅ | ✅ |
| Open source (MIT) | ✅ | ✅ |

## Install

### macOS

Download the latest DMG from [Releases](https://github.com/example-user/hermeshq/releases):

1. Open `HermesHQ.dmg`
2. Drag `HermesHQ.app` to `/Applications`
3. Right-click → Open (first launch, ad-hoc signed)

### iOS

Build from source with Xcode:

```bash
git clone https://github.com/example-user/hermeshq.git
cd hermeshq
flutter pub get
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode and deploy to your device.

## Configuration

On first launch, HermesHQ connects to `http://127.0.0.1:9119` (default).

Tap the ⚙️ button to change the server URL — use your Tailscale IP or hostname.

**Requirements:**
- Tailscale connected on your device
- Hermes Agent dashboard running on the target server
- `hermes dashboard --host <tailscale-ip> --port 9119 --no-open --insecure`

## Build from Source

```bash
# Requirements: Flutter 3.27+, macOS 14+

git clone https://github.com/example-user/hermeshq.git
cd hermeshq
flutter pub get
flutter run -d macos
```

To build DMG:

```bash
flutter build macos --release
brew install create-dmg
create-dmg --volname "HermesHQ" dist/HermesHQ.dmg build/macos/Build/Products/Release/HermesHQ.app
```

## Architecture

```
┌─ Your Mac / iPhone ───────────────────────┐
│  HermesHQ (Flutter + WKWebView)            │
│  ├─ Dashboard WebView                      │
│  ├─ ConnectivityService (ping /api/health) │
│  ├─ NotificationService (local notifs)     │
│  └─ StatusIndicator (menubar bar)          │
│         │                                  │
│     Tailscale                              │
│         │                                  │
└─────────┼──────────────────────────────────┘
          │  Tailscale mesh (127.0.0.1)
┌─────────┼──────────────────────────────────┐
│  VPS    │                                  │
│  hermes dashboard --host 100.x.x.x         │
│  ~/.hermes/                                │
└────────────────────────────────────────────┘
```

## License

MIT © 2026 Example Author
