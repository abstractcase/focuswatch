import Foundation
import Cocoa

// Simplified, safer version
class SimpleFocusMonitor {
    private var observer: NSObjectProtocol?
    var events: [String] = []
    private let maxEvents = 50
    private var lastAppName: String?
    private var lastSwitchTime: Date?
    private let suspiciousThreshold: TimeInterval = 2.0

    func startMonitoring() {
        stopMonitoring() // Clean up first

        observer = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] notification in
            self?.handleAppChange(notification)
        }

        print("FocusWatch: Enhanced monitoring started")
    }

    func stopMonitoring() {
        if let obs = observer {
            NSWorkspace.shared.notificationCenter.removeObserver(obs)
            observer = nil
        }
    }

    private func handleAppChange(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }

        let appName = app.localizedName ?? "Unknown"
        let bundleId = app.bundleIdentifier ?? "unknown.app"
        let now = Date()

        // Format timestamp
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        let timestamp = formatter.string(from: now)

        // Check for focus theft (quick return to previous app)
        var suspiciousFlag = ""
        if let lastApp = lastAppName,
           let lastTime = lastSwitchTime,
           now.timeIntervalSince(lastTime) < suspiciousThreshold,
           lastApp != appName {
            // Quick switch - might be suspicious
            suspiciousFlag = " 🔍"
        }

        // Format event with better presentation (include bundle ID for export)
        let event = "[\(timestamp)] \(appName)\(suspiciousFlag)\n   └─ \(bundleId)"

        events.insert(event, at: 0)
        if events.count > maxEvents {
            events = Array(events.prefix(maxEvents))
        }

        // Update tracking
        lastAppName = appName
        lastSwitchTime = now

        print("FocusWatch: \(appName)\(suspiciousFlag)")
    }

    // Helper functions for stats
    func getTotalEvents() -> Int {
        return events.count
    }

    func getMostActiveApps() -> [(String, Int)] {
        var appCounts: [String: Int] = [:]

        for event in events {
            // Extract app name from formatted event
            let lines = event.components(separatedBy: "\n")
            if let firstLine = lines.first {
                let parts = firstLine.components(separatedBy: "] ")
                if parts.count > 1 {
                    let appName = parts[1].components(separatedBy: " 🔍").first ?? parts[1]
                    appCounts[appName, default: 0] += 1
                }
            }
        }

        return Array(appCounts.sorted { $0.value > $1.value }.prefix(5))
    }

    func exportEventsToCSV() -> String {
        var csv = "Timestamp,App Name,Bundle ID,Quick Switch\n"

        for event in events.reversed() { // Chronological order for export
            let lines = event.components(separatedBy: "\n")
            if lines.count >= 2 {
                let firstLine = lines[0]
                let bundleLine = lines[1]

                // Extract timestamp
                let timestampEnd = firstLine.range(of: "] ")?.lowerBound
                let timestamp = timestampEnd != nil ? String(firstLine[firstLine.index(after: firstLine.startIndex)..<timestampEnd!]) : ""

                // Extract app name and quick switch flag
                let appPart = timestampEnd != nil ? String(firstLine[firstLine.index(timestampEnd!, offsetBy: 2)...]) : ""
                let isQuickSwitch = appPart.contains("🔍")
                let appName = appPart.replacingOccurrences(of: " 🔍", with: "")

                // Extract bundle ID
                let bundleID = bundleLine.replacingOccurrences(of: "   └─ ", with: "")

                csv += "\"\(timestamp)\",\"\(appName)\",\"\(bundleID)\",\(isQuickSwitch)\n"
            }
        }

        return csv
    }

    deinit {
        stopMonitoring()
    }
}