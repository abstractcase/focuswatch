import SwiftUI
import AppKit

class MenuBarController: ObservableObject {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private let focusMonitor: FocusMonitor
    private let permissionsManager: PermissionsManager

    init() {
        self.focusMonitor = FocusMonitor()
        self.permissionsManager = PermissionsManager()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        popover = NSPopover()

        setupStatusItem()
        setupPopover()
        checkInitialPermissions()
    }

    private func setupStatusItem() {
        guard let statusButton = statusItem.button else { return }

        statusButton.image = NSImage(systemSymbolName: "eye.circle", accessibilityDescription: "FocusCop")
        statusButton.image?.size = NSSize(width: 18, height: 18)
        statusButton.target = self
        statusButton.action = #selector(statusButtonClicked)
    }

    private func setupPopover() {
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: ContentView(
                focusMonitor: focusMonitor,
                permissionsManager: permissionsManager
            )
        )
    }

    private func checkInitialPermissions() {
        if !permissionsManager.hasAccessibilityPermission {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.permissionsManager.requestAccessibilityPermission()
            }
        }
    }

    @objc private func statusButtonClicked() {
        guard let statusButton = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: statusButton.bounds, of: statusButton, preferredEdge: .minY)
        }
    }
}