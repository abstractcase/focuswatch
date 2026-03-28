import Foundation
import AppKit

class FocusStealer {
    static func stealFocus() {
        let app = NSApplication.shared
        app.activate(ignoringOtherApps: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            app.hide(nil)
        }
    }
}

print("Focus Stealer Test - This will steal focus briefly")
print("Run this while FocusWatch is monitoring to see it detect the steal")

for i in 1...5 {
    print("Stealing focus in \(6-i) seconds...")
    sleep(1)
}

print("Stealing focus now!")
FocusStealer.stealFocus()

print("Focus steal complete - check FocusWatch for detection")