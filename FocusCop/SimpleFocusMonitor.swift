import Foundation
import Cocoa

struct FocusRecord {
    let timestamp: Date
    let appName: String
    let bundleID: String
    let isQuickSwitch: Bool

    var displayText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        let timeStr = formatter.string(from: timestamp)
        let flag = isQuickSwitch ? " 🔍" : ""
        return "[\(timeStr)] \(appName)\(flag)\n   └─ \(bundleID)"
    }
}

// Simplified, safer version
class SimpleFocusMonitor {
    private var observer: NSObjectProtocol?
    private(set) var records: [FocusRecord] = []
    private let maxEvents = 200
    private var lastAppName: String?
    private var lastSwitchTime: Date?
    private let suspiciousThreshold: TimeInterval = 2.0

    var events: [String] {
        records.map { $0.displayText }
    }

    func addManualEvent(appName: String) {
        let record = FocusRecord(timestamp: Date(), appName: appName, bundleID: "com.focuswatch.test", isQuickSwitch: false)
        records.insert(record, at: 0)
    }

    func clearAll() {
        records.removeAll()
    }

    func startMonitoring() {
        stopMonitoring()

        observer = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] notification in
            self?.handleAppChange(notification)
        }

        print("FocusWatch: Monitoring started")
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
        let bundleID = app.bundleIdentifier ?? "unknown.app"
        let now = Date()

        // Detect quick switch (potential focus theft)
        var isQuick = false
        if let lastTime = lastSwitchTime,
           let lastName = lastAppName,
           lastName != appName,
           now.timeIntervalSince(lastTime) < suspiciousThreshold {
            isQuick = true
        }

        let record = FocusRecord(timestamp: now, appName: appName, bundleID: bundleID, isQuickSwitch: isQuick)
        records.insert(record, at: 0)
        if records.count > maxEvents {
            records = Array(records.prefix(maxEvents))
        }

        lastAppName = appName
        lastSwitchTime = now

        print("FocusWatch: \(appName)\(isQuick ? " 🔍" : "")")
    }

    func getTotalEvents() -> Int {
        return records.count
    }

    func getMostActiveApps() -> [(String, Int)] {
        var counts: [String: Int] = [:]
        for record in records {
            counts[record.appName, default: 0] += 1
        }
        return Array(counts.sorted { $0.value > $1.value }.prefix(5))
    }

    func exportEventsToCSV() -> String {
        var csv = "Timestamp,App Name,Bundle ID,Quick Switch\n"
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium

        for record in records.reversed() { // chronological order
            let timestamp = formatter.string(from: record.timestamp)
            let appName = record.appName.replacingOccurrences(of: "\"", with: "\"\"")
            let bundleID = record.bundleID.replacingOccurrences(of: "\"", with: "\"\"")
            csv += "\"\(timestamp)\",\"\(appName)\",\"\(bundleID)\",\(record.isQuickSwitch)\n"
        }
        return csv
    }

    deinit {
        stopMonitoring()
    }
}
