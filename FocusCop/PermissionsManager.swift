import Foundation
import ApplicationServices
import Cocoa

class PermissionsManager: ObservableObject {
    @Published var hasAccessibilityPermission = false

    init() {
        checkAccessibilityPermission()
    }

    func checkAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: false]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)

        DispatchQueue.main.async {
            self.hasAccessibilityPermission = accessEnabled
        }
    }

    func requestAccessibilityPermission() {
        let alert = NSAlert()
        alert.messageText = "FocusCop needs Accessibility permissions"
        alert.informativeText = """
        FocusCop requires Accessibility permissions to monitor application focus changes and detect focus stealing.

        Click "Open System Preferences" to grant permissions, then restart FocusCop.

        Without these permissions, FocusCop will work in limited mode using only basic app activation notifications.
        """
        alert.addButton(withTitle: "Open System Preferences")
        alert.addButton(withTitle: "Continue without permissions")
        alert.alertStyle = .informational

        let response = alert.runModal()

        if response == .alertFirstButtonReturn {
            openAccessibilityPreferences()
        }
    }

    private func openAccessibilityPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }

    func recheckPermissions() {
        checkAccessibilityPermission()
    }
}