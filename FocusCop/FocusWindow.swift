import AppKit
import Foundation

class FocusWindow: NSWindow {
    private weak var monitor: SimpleFocusMonitor?
    private var textView: NSTextView!
    private var scrollView: NSScrollView!
    private var refreshTimer: Timer?
    private var testStealer: NSWindow?  // Strong ref — prevents double-free when ARC + isReleasedWhenClosed interact

    init(monitor: SimpleFocusMonitor) {
        self.monitor = monitor

        let contentRect = NSRect(x: 0, y: 0, width: 500, height: 400)

        super.init(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )

        setupWindow()
        setupSimpleUI()
        startRefreshTimer()
    }

    private func setupWindow() {
        title = "FocusWatch - Focus Monitor"
        center()
        minSize = NSSize(width: 400, height: 300)
        isReleasedWhenClosed = false
        level = .floating
    }

    private func setupSimpleUI() {
        guard let contentView = contentView else { return }

        // Toolbar area at bottom
        let toolbarHeight: CGFloat = 44
        let windowWidth: CGFloat = 500

        // Scrollable text view for events
        scrollView = NSScrollView()
        scrollView.frame = NSRect(x: 0, y: toolbarHeight, width: windowWidth, height: 400 - toolbarHeight)
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.autoresizingMask = [.width, .height]
        scrollView.borderType = .noBorder

        textView = NSTextView()
        textView.isEditable = false
        textView.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
        textView.textColor = .labelColor
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.textContainerInset = NSSize(width: 8, height: 8)

        scrollView.documentView = textView
        contentView.addSubview(scrollView)

        // Separator line above toolbar (NSBox .separator uses no layers, no recursion)
        let separator = NSBox(frame: NSRect(x: 0, y: toolbarHeight, width: windowWidth, height: 1))
        separator.boxType = .separator
        separator.autoresizingMask = [.width]
        contentView.addSubview(separator)

        // Buttons
        let testButton = NSButton(frame: NSRect(x: 10, y: 8, width: 140, height: 28))
        testButton.title = "🧪 Test Focus Steal"
        testButton.bezelStyle = .rounded
        testButton.target = self
        testButton.action = #selector(testFocusSteal)
        contentView.addSubview(testButton)

        let clearButton = NSButton(frame: NSRect(x: 158, y: 8, width: 110, height: 28))
        clearButton.title = "🗑 Clear Events"
        clearButton.bezelStyle = .rounded
        clearButton.target = self
        clearButton.action = #selector(clearEvents)
        contentView.addSubview(clearButton)

        let exportButton = NSButton(frame: NSRect(x: 276, y: 8, width: 120, height: 28))
        exportButton.title = "📤 Export CSV"
        exportButton.bezelStyle = .rounded
        exportButton.target = self
        exportButton.action = #selector(exportCSV)
        contentView.addSubview(exportButton)
    }

    @objc private func testFocusSteal() {
        // Prevent multiple concurrent tests
        guard testStealer == nil else { return }

        let win = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        // IMPORTANT: must be false in Swift/ARC — the default (true) causes a
        // double-free crash: AppKit releases the window on close, then ARC
        // also releases the instance variable reference.
        win.isReleasedWhenClosed = false
        win.title = "Focus Steal Test"
        win.center()
        win.level = .floating

        let label = NSTextField(labelWithString: "Testing Focus Steal\n\nThis window will close automatically.")
        label.frame = NSRect(x: 20, y: 20, width: 260, height: 110)
        label.alignment = .center
        label.backgroundColor = .controlBackgroundColor
        label.isBordered = false
        label.isEditable = false
        win.contentView?.addSubview(label)

        testStealer = win
        win.makeKeyAndOrderFront(nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.testStealer?.close()
            self?.testStealer = nil   // ARC cleanup — no double-free
        }
    }

    @objc private func clearEvents() {
        monitor?.clearAll()
        updateTextView()
    }

    @objc private func exportCSV() {
        guard let monitor = monitor else { return }
        let csvData = monitor.exportEventsToCSV()

        let headerLine = "Timestamp,App Name,Bundle ID,Quick Switch"
        if csvData.trimmingCharacters(in: .whitespacesAndNewlines).count <= headerLine.count {
            let alert = NSAlert()
            alert.messageText = "No Events to Export"
            alert.informativeText = "There are no focus events recorded yet. Use FocusWatch for a while, then try exporting again."
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
                alert.informativeText = "Focus events exported to:\n\(url.path)\n\nOpen in Excel, Numbers, or any spreadsheet app."
                alert.alertStyle = .informational
                alert.addButton(withTitle: "Open File")
                alert.addButton(withTitle: "Close")
                if alert.runModal() == .alertFirstButtonReturn {
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

    private func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateTextView()
            }
        }
    }

    private func updateTextView() {
        guard let monitor = monitor else { return }

        let totalEvents = monitor.getTotalEvents()
        let topApps = monitor.getMostActiveApps()

        var header = "STATISTICS\n"
        header += "Total Events: \(totalEvents)"

        if !topApps.isEmpty {
            header += "  •  Top Apps: "
            header += topApps.prefix(3).map { "\($0.0) (\($0.1))" }.joined(separator: ", ")
        }
        header += "\nNote: Events are not saved to disk — export before quitting.\n"
        header += "\nFOCUS EVENTS  (* = quick switch under 2s)\n"
        header += String(repeating: "─", count: 60) + "\n"

        let eventsText = monitor.events.isEmpty
            ? "No events recorded yet.\nSwitch between apps to see focus changes here."
            : monitor.events.joined(separator: "\n")

        textView?.string = header + eventsText

        // Scroll to top so newest events (inserted at index 0) are visible
        textView?.scrollToBeginningOfDocument(nil)
    }

    override func close() {
        refreshTimer?.invalidate()
        refreshTimer = nil
        super.close()
    }

    deinit {
        refreshTimer?.invalidate()
    }
}