import AppKit
import ServiceManagement

class SimpleMenuBarController {
    private var statusItem: NSStatusItem?
    private var monitor = SimpleFocusMonitor()
    private var menu = NSMenu()
    private var eventsWindow: FocusWindow?
    private var menuRefreshTimer: Timer?

    init() {
        setupMenuBar()
        monitor.startMonitoring()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "binoculars", accessibilityDescription: "FocusWatch")
            button.image?.size = NSSize(width: 18, height: 18)
        }

        setupMenu()
        statusItem?.menu = menu

        // Refresh menu every few seconds to update event count
        menuRefreshTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.setupMenu()
        }
    }

    private func setupMenu() {
        menu.removeAllItems()

        let titleItem = NSMenuItem(title: "FocusWatch - Focus Monitor", action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        menu.addItem(titleItem)

        // Status indicator
        let eventCount = monitor.getTotalEvents()
        let statusItem = NSMenuItem(title: "Monitoring Active • \(eventCount) events", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)

        menu.addItem(NSMenuItem.separator())

        let showEventsItem = NSMenuItem(title: "Show Events & Stats", action: #selector(showEventsWindow), keyEquivalent: "e")
        showEventsItem.target = self
        menu.addItem(showEventsItem)

        let testItem = NSMenuItem(title: "Test Focus Detection", action: #selector(runTest), keyEquivalent: "t")
        testItem.target = self
        menu.addItem(testItem)

        let exportItem = NSMenuItem(title: "Export Events to CSV", action: #selector(exportEvents), keyEquivalent: "x")
        exportItem.target = self
        menu.addItem(exportItem)

        menu.addItem(NSMenuItem.separator())

        let aboutItem = NSMenuItem(title: "About FocusWatch", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)

        menu.addItem(NSMenuItem.separator())

        let launchAtLoginItem = NSMenuItem(
            title: "Launch at Login",
            action: #selector(toggleLaunchAtLogin),
            keyEquivalent: ""
        )
        launchAtLoginItem.target = self
        launchAtLoginItem.state = isLaunchAtLoginEnabled ? .on : .off
        menu.addItem(launchAtLoginItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit FocusWatch", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quitItem)
    }

    @objc private func showEventsWindow() {
        if eventsWindow == nil || !eventsWindow!.isVisible {
            eventsWindow = FocusWindow(monitor: monitor)
        }
        eventsWindow?.makeKeyAndOrderFront(nil)
        if #available(macOS 14.0, *) {
            NSApp.activate()
        } else {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    @objc private func runTest() {
        monitor.addManualEvent(appName: "TEST — Manual test entry")

        let alert = NSAlert()
        alert.messageText = "Test Entry Added"
        alert.informativeText = """
        A test event was added to the log.

        To see real focus detection:
        1. Click OK to close this dialog
        2. Switch to a few other apps (⌘+Tab or Dock)
        3. Open "Show Events & Stats" to see the log

        Quick switches under 2 seconds are marked with *.
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK — Got it!")
        alert.runModal()
    }

    @objc private func exportEvents() {
        let csvData = monitor.exportEventsToCSV()

        if csvData.trimmingCharacters(in: .whitespacesAndNewlines).count <= "Timestamp,App Name,Bundle ID,Quick Switch".count {
            let alert = NSAlert()
            alert.messageText = "No Events to Export"
            alert.informativeText = "There are no focus events recorded yet.\n\nUse FocusWatch for a while, then try exporting again."
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
            return
        }

        let savePanel = NSSavePanel()
        savePanel.title = "Export Focus Events"
        savePanel.nameFieldStringValue = "FocusWatch-Events-\(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none).replacingOccurrences(of: "/", with: "-")).csv"
        savePanel.allowedContentTypes = [.commaSeparatedText]

        let result = savePanel.runModal()

        if result == .OK, let url = savePanel.url {
            do {
                try csvData.write(to: url, atomically: true, encoding: .utf8)

                let alert = NSAlert()
                alert.messageText = "Export Successful"
                alert.informativeText = "Focus events exported to:\n\(url.path)\n\nYou can open this file in Excel, Numbers, or any text editor."
                alert.alertStyle = .informational
                alert.addButton(withTitle: "Open File")
                alert.addButton(withTitle: "Close")

                let response = alert.runModal()
                if response == .alertFirstButtonReturn {
                    NSWorkspace.shared.open(url)
                }
            } catch {
                let alert = NSAlert()
                alert.messageText = "Export Failed"
                alert.informativeText = "Could not save the file:\n\(error.localizedDescription)"
                alert.alertStyle = .critical
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        }
    }

    // MARK: — About

    @objc private func showAbout() {
        if #available(macOS 14.0, *) {
            NSApp.activate()
        } else {
            NSApp.activate(ignoringOtherApps: true)
        }
        NSApp.orderFrontStandardAboutPanel(nil)
    }

    // MARK: — Launch at Login

    private var isLaunchAtLoginEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    @objc private func toggleLaunchAtLogin() {
        do {
            if isLaunchAtLoginEnabled {
                try SMAppService.mainApp.unregister()
            } else {
                try SMAppService.mainApp.register()
            }
        } catch {
            let alert = NSAlert()
            alert.messageText = "Launch at Login Failed"
            alert.informativeText = "Could not update the Launch at Login setting:\n\(error.localizedDescription)"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
        // Rebuild menu so the checkmark reflects the new state
        setupMenu()
    }

    deinit {
        menuRefreshTimer?.invalidate()
        menuRefreshTimer = nil
        statusItem = nil
        monitor.stopMonitoring()
    }
}