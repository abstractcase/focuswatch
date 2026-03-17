import AppKit
import Foundation

class FocusWindow: NSWindow {
    private weak var monitor: SimpleFocusMonitor?
    private var textView: NSTextView!
    private var scrollView: NSScrollView!
    private var refreshTimer: Timer?

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
        title = "FocusCop - Focus Monitor"
        center()
        minSize = NSSize(width: 400, height: 300)
        isReleasedWhenClosed = false
        level = .floating
    }

    private func setupSimpleUI() {
        guard let contentView = contentView else { return }

        // Create simple text view instead of complex table view
        scrollView = NSScrollView()
        scrollView.frame = NSRect(x: 10, y: 50, width: 480, height: 340)
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = false
        scrollView.autoresizingMask = [.width, .height]

        textView = NSTextView()
        textView.isEditable = false
        textView.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
        textView.textColor = .labelColor
        textView.backgroundColor = .textBackgroundColor

        scrollView.documentView = textView
        contentView.addSubview(scrollView)

        // Create simple buttons
        let testButton = NSButton(frame: NSRect(x: 10, y: 10, width: 120, height: 30))
        testButton.title = "Test Focus Steal"
        testButton.bezelStyle = .rounded
        testButton.target = self
        testButton.action = #selector(testFocusSteal)
        contentView.addSubview(testButton)

        let clearButton = NSButton(frame: NSRect(x: 140, y: 10, width: 100, height: 30))
        clearButton.title = "Clear Events"
        clearButton.bezelStyle = .rounded
        clearButton.target = self
        clearButton.action = #selector(clearEvents)
        contentView.addSubview(clearButton)

        let statusLabel = NSTextField(frame: NSRect(x: 250, y: 15, width: 200, height: 20))
        statusLabel.stringValue = "Real-time monitoring active"
        statusLabel.isEditable = false
        statusLabel.isBordered = false
        statusLabel.backgroundColor = .clear
        statusLabel.font = NSFont.systemFont(ofSize: 11)
        statusLabel.textColor = .secondaryLabelColor
        contentView.addSubview(statusLabel)
    }

    @objc private func testFocusSteal() {
        // Create a temporary window that steals focus
        let testWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )

        testWindow.title = "Focus Steal Test"
        testWindow.center()
        testWindow.level = .floating

        let label = NSTextField(labelWithString: "🔍 Testing Focus Steal\n\nThis window will close automatically.")
        label.frame = NSRect(x: 20, y: 20, width: 260, height: 110)
        label.alignment = .center
        label.backgroundColor = .controlBackgroundColor
        label.isBordered = false
        label.isEditable = false
        testWindow.contentView?.addSubview(label)

        testWindow.makeKeyAndOrderFront(nil)

        // Close after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            testWindow.close()
        }
    }

    @objc private func clearEvents() {
        monitor?.events.removeAll()
        updateTextView()
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
        let eventsText = monitor.events.joined(separator: "\n")
        textView?.string = eventsText.isEmpty ? "No events recorded yet...\nSwitch between apps to see focus changes." : eventsText

        // Auto-scroll to bottom
        if let textView = textView {
            let range = NSRange(location: textView.string.count, length: 0)
            textView.scrollRangeToVisible(range)
        }
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