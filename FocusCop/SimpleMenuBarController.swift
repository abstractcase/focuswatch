import AppKit

class SimpleMenuBarController {
    private var statusItem: NSStatusItem?
    private var monitor = SimpleFocusMonitor()
    private var menu = NSMenu()

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
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
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
        let statusItem = NSMenuItem(title: "✅ Monitoring Active • \(eventCount) events", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)

        menu.addItem(NSMenuItem.separator())

        let showEventsItem = NSMenuItem(title: "📊 Show Events & Stats", action: #selector(showEventsWindow), keyEquivalent: "e")
        showEventsItem.target = self
        menu.addItem(showEventsItem)

        let testItem = NSMenuItem(title: "🧪 Test Focus Detection", action: #selector(runTest), keyEquivalent: "t")
        testItem.target = self
        menu.addItem(testItem)

        let exportItem = NSMenuItem(title: "📤 Export Events to CSV", action: #selector(exportEvents), keyEquivalent: "x")
        exportItem.target = self
        menu.addItem(exportItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit FocusWatch", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quitItem)
    }

    @objc private func showEventsWindow() {
        let totalEvents = monitor.getTotalEvents()
        let topApps = monitor.getMostActiveApps()

        // Build statistics section
        var statsSection = "📊 STATISTICS\n"
        statsSection += "Total Events: \(totalEvents)\n"

        if !topApps.isEmpty {
            statsSection += "Most Active Apps:\n"
            for (app, count) in topApps {
                statsSection += "  • \(app): \(count) switches\n"
            }
        }

        statsSection += "\n🔍 FOCUS EVENTS (🔍 = Quick Switch)\n"

        // Get recent events
        let events = monitor.events.prefix(25).joined(separator: "\n")
        let eventsSection = events.isEmpty ? "No events recorded yet.\n\nSwitch between apps to see focus changes here." : events

        let fullMessage = statsSection + eventsSection

        let alert = NSAlert()
        alert.messageText = "FocusWatch - Focus Monitor"
        alert.informativeText = fullMessage
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Close")
        alert.addButton(withTitle: "Clear All Events")

        let response = alert.runModal()

        // If user clicked "Clear All Events"
        if response == .alertSecondButtonReturn {
            clearEvents()
        }
    }

    @objc private func runTest() {
        // Add a test event manually to show the system works
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        monitor.events.insert("[\(timestamp)] TEST: Manual test entry - system is working", at: 0)

        // Show instruction for real testing
        let alert = NSAlert()
        alert.messageText = "Test Instructions"
        alert.informativeText = """
        Test entry added successfully!

        To see real focus detection in action:
        1. Click OK to close this dialog
        2. Switch to another app (⌘+Tab or click dock)
        3. Come back to check 'Show Focus Events'

        You should see the manual test entry plus real app switches.

        The focus monitoring is working - try switching between apps!
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK - Got it!")
        alert.runModal()
    }

    @objc private func clearEvents() {
        monitor.events.removeAll()

        let alert = NSAlert()
        alert.messageText = "Events Cleared"
        alert.informativeText = "All focus events have been cleared."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
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

    deinit {
        statusItem = nil
        monitor.stopMonitoring()
    }
}