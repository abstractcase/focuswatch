import Foundation
import AppKit
import SwiftUI

class FocusTestSimulator: ObservableObject {
    private var testWindow: NSWindow?
    @Published var isTestMode = false
    private var testTimer: Timer?

    func simulateFocusSteal() {
        guard !isTestMode else { return }

        // Clean up any existing test
        cleanupTest()

        isTestMode = true

        // Simple single window show/hide instead of complex sequence
        DispatchQueue.main.async { [weak self] in
            self?.createAndShowStealerWindow()
        }

        // Auto cleanup after 2 seconds
        testTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.cleanupTest()
        }
    }

    func simulateMultipleThefts() {
        // For now, just do a single test to avoid complexity
        simulateFocusSteal()
    }

    private func createAndShowStealerWindow() {
        guard testWindow == nil else { return }

        let contentRect = NSRect(x: 0, y: 0, width: 300, height: 200)

        testWindow = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        guard let window = testWindow else { return }

        window.title = "Focus Stealer Test"
        window.center()
        window.level = .floating
        window.makeKeyAndOrderFront(nil)

        // Simple text view instead of SwiftUI hosting view to avoid complexity
        let textField = NSTextField(labelWithString: "🔍 Focus Steal Test\n\nThis window briefly steals focus.\nCheck FocusCop for detection!")
        textField.frame = NSRect(x: 20, y: 20, width: 260, height: 160)
        textField.alignment = .center
        textField.backgroundColor = NSColor.controlBackgroundColor
        window.contentView?.addSubview(textField)

        // Hide after a brief moment to simulate focus stealing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.testWindow?.orderOut(nil)
        }
    }

    private func cleanupTest() {
        testTimer?.invalidate()
        testTimer = nil

        if let window = testWindow {
            window.close()
            testWindow = nil
        }

        isTestMode = false
    }

    deinit {
        cleanupTest()
    }
}