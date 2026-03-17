import Foundation

struct AppInfo {
    let bundleIdentifier: String
    let displayName: String
    let processIdentifier: pid_t

    init(bundleIdentifier: String?, displayName: String?, processIdentifier: pid_t) {
        self.bundleIdentifier = bundleIdentifier ?? "unknown"
        self.displayName = displayName ?? "Unknown App"
        self.processIdentifier = processIdentifier
    }
}

struct FocusEvent {
    let id = UUID()
    let timestamp: Date
    let fromApp: AppInfo
    let toApp: AppInfo
    let isSteal: Bool

    var displayText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none

        let timeString = formatter.string(from: timestamp)
        let stealMark = isSteal ? " 🔴" : ""

        return "\(timeString): \(fromApp.displayName) → \(toApp.displayName)\(stealMark)"
    }
}

class SuspectApp: ObservableObject, Identifiable {
    let id = UUID()
    let bundleIdentifier: String
    let displayName: String
    @Published var stealCount: Int = 0
    @Published var lastStealTime: Date?

    init(bundleIdentifier: String, displayName: String) {
        self.bundleIdentifier = bundleIdentifier
        self.displayName = displayName
    }

    func recordSteal() {
        stealCount += 1
        lastStealTime = Date()
    }
}