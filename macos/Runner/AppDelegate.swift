import Cocoa
import FlutterMacOS

class AppDelegate: FlutterAppDelegate {
  private var statusItem: NSStatusItem?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    // Register for the menubar channel
    if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "hermeshq/menubar",
        binaryMessenger: controller.engine.binaryMessenger
      )

      channel.setMethodCallHandler { [weak self] (call, result) in
        switch call.method {
        case "showMenubar":
          if let args = call.arguments as? [String: Any],
             let title = args["title"] as? String {
            self?.setupMenubar(title: title)
          }
          result(nil)
        case "updateMenubarTitle":
          if let args = call.arguments as? [String: Any],
             let title = args["title"] as? String {
            self?.statusItem?.button?.title = title
          }
          result(nil)
        case "hideDockIcon":
          NSApp.setActivationPolicy(.accessory)
          result(nil)
        case "showDockIcon":
          NSApp.setActivationPolicy(.regular)
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    super.applicationDidFinishLaunching(notification)
  }

  private func setupMenubar(title: String) {
    statusItem = NSStatusBar.system.statusItem(
      withLength: NSStatusItem.variableLength
    )
    statusItem?.button?.title = title
    statusItem?.button?.font = NSFont.monospacedDigitSystemFont(
      ofSize: NSFont.smallSystemFontSize,
      weight: .medium
    )
  }

  // Reopen from menubar or dock
  override func applicationShouldHandleReopen(
    _ sender: NSApplication,
    hasVisibleWindows: Bool
  ) -> Bool {
    if !hasVisibleWindows {
      mainFlutterWindow?.makeKeyAndOrderFront(nil)
    }
    return true
  }
}
