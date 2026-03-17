import Foundation
import Cocoa

class FocusMonitor: ObservableObject {
    @Published var events: [FocusEvent] = []
    @Published var suspects: [SuspectApp] = []
    @Published var isMonitoring = true

    private var lastApp: AppInfo?
    private var lastSwitchTime: Date?
    private let stealDetectionThreshold: TimeInterval = 0.75
    private let maxEvents = 50
    private var notificationObserver: NSObjectProtocol?

    private let systemAllowlist = Set([
        "com.apple.Spotlight",
        "com.apple.controlcenter",
        "com.apple.notificationcenterui",
        "com.apple.systemuiserver",
        "com.apple.dock",
        "com.apple.loginwindow",
        "com.apple.WindowManager",
        "com.apple.finder"
    ])

    init() {
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    private func startMonitoring() {
        stopMonitoring() // Clean up any existing observer

        notificationObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleApplicationActivation(notification)
        }

        if let currentApp = NSWorkspace.shared.frontmostApplication {
            lastApp = AppInfo(
                bundleIdentifier: currentApp.bundleIdentifier,
                displayName: currentApp.localizedName,
                processIdentifier: currentApp.processIdentifier
            )
            lastSwitchTime = Date()
        }
    }

    private func stopMonitoring() {
        if let observer = notificationObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
            notificationObserver = nil
        }
    }

    private func handleApplicationActivation(_ notification: Notification) {
        guard isMonitoring,
              let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
        else { return }

        let newApp = AppInfo(
            bundleIdentifier: app.bundleIdentifier,
            displayName: app.localizedName,
            processIdentifier: app.processIdentifier
        )

        guard let previousApp = lastApp else {
            lastApp = newApp
            lastSwitchTime = Date()
            return
        }

        let now = Date()
        let isSteal = detectSteal(from: previousApp, to: newApp, at: now)

        let event = FocusEvent(
            timestamp: now,
            fromApp: previousApp,
            toApp: newApp,
            isSteal: isSteal
        )

        addEvent(event)

        if isSteal {
            updateSuspects(for: newApp)
        }

        lastApp = newApp
        lastSwitchTime = now
    }

    private func detectSteal(from: AppInfo, to: AppInfo, at time: Date) -> Bool {
        guard let lastSwitch = lastSwitchTime else { return false }

        let timeSinceLastSwitch = time.timeIntervalSince(lastSwitch)

        if timeSinceLastSwitch <= stealDetectionThreshold {
            return false
        }

        if systemAllowlist.contains(to.bundleIdentifier) {
            return false
        }

        if events.count >= 2 {
            let recentEvents = events.suffix(2)
            if let secondLast = recentEvents.first,
               secondLast.toApp.bundleIdentifier == from.bundleIdentifier,
               time.timeIntervalSince(secondLast.timestamp) <= stealDetectionThreshold {
                return true
            }
        }

        return false
    }

    private func addEvent(_ event: FocusEvent) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.events.insert(event, at: 0)

            if self.events.count > self.maxEvents {
                self.events = Array(self.events.prefix(self.maxEvents))
            }
        }
    }

    private func updateSuspects(for app: AppInfo) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let existingSuspect = self.suspects.first(where: { $0.bundleIdentifier == app.bundleIdentifier }) {
                existingSuspect.recordSteal()
            } else {
                let newSuspect = SuspectApp(bundleIdentifier: app.bundleIdentifier, displayName: app.displayName)
                newSuspect.recordSteal()
                self.suspects.append(newSuspect)
            }

            self.suspects.sort { $0.stealCount > $1.stealCount }
        }
    }

    func toggleMonitoring() {
        isMonitoring.toggle()
        if isMonitoring {
            startMonitoring()
        } else {
            stopMonitoring()
        }
    }

    func clearEvents() {
        events.removeAll()
    }

    func clearSuspects() {
        suspects.removeAll()
    }
}