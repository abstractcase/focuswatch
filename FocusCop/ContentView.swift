import SwiftUI

struct ContentView: View {
    @ObservedObject var focusMonitor: FocusMonitor
    @ObservedObject var permissionsManager: PermissionsManager
    @StateObject private var testSimulator = FocusTestSimulator()
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            headerView

            TabView(selection: $selectedTab) {
                focusLogView
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Log")
                    }
                    .tag(0)

                suspectsView
                    .tabItem {
                        Image(systemName: "exclamationmark.triangle")
                        Text("Suspects")
                    }
                    .tag(1)

                testView
                    .tabItem {
                        Image(systemName: "testtube.2")
                        Text("Test")
                    }
                    .tag(2)
            }
            .frame(height: 400)
        }
        .frame(width: 400, height: 500)
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "eye.circle.fill")
                    .foregroundColor(.blue)
                Text("FocusCop")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: focusMonitor.toggleMonitoring) {
                    Image(systemName: focusMonitor.isMonitoring ? "pause.circle.fill" : "play.circle.fill")
                        .foregroundColor(focusMonitor.isMonitoring ? .orange : .green)
                }
                .buttonStyle(PlainButtonStyle())
                .help(focusMonitor.isMonitoring ? "Pause monitoring" : "Resume monitoring")
            }

            HStack {
                statusIndicator
                Spacer()
                if !permissionsManager.hasAccessibilityPermission {
                    Button("Grant Permissions") {
                        permissionsManager.requestAccessibilityPermission()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.orange)
                }
            }

            Divider()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var statusIndicator: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(focusMonitor.isMonitoring ? .green : .gray)
                .frame(width: 8, height: 8)

            Text(focusMonitor.isMonitoring ? "Monitoring" : "Paused")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var focusLogView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Recent Focus Changes")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    focusMonitor.clearEvents()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            if focusMonitor.events.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "eye.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No focus changes detected")
                        .foregroundColor(.secondary)
                    Text("App switches will appear here")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(focusMonitor.events, id: \.id) { event in
                            FocusEventRow(event: event)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private var suspectsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Focus Stealing Apps")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    focusMonitor.clearSuspects()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            if focusMonitor.suspects.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.shield")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    Text("No focus stealing detected")
                        .foregroundColor(.secondary)
                    Text("Suspicious apps will appear here")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(focusMonitor.suspects, id: \.id) { suspect in
                            SuspectRow(suspect: suspect)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private var testView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Image(systemName: "testtube.2")
                    .font(.largeTitle)
                    .foregroundColor(.blue)

                Text("Focus Theft Testing")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Use these buttons to simulate focus stealing and see FocusCop in action")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            VStack(spacing: 16) {
                Button(action: {
                    testSimulator.simulateFocusSteal()
                }) {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("Single Focus Steal Test")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(testSimulator.isTestMode)

                Button(action: {
                    testSimulator.simulateMultipleThefts()
                }) {
                    HStack {
                        Image(systemName: "repeat")
                        Text("Multiple Theft Test")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(testSimulator.isTestMode)
            }
            .padding(.horizontal)

            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                    Text("How it works:")
                        .font(.headline)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("• A test window will appear and steal focus")
                    Text("• It will hide and show rapidly (< 750ms)")
                    Text("• Check the Log tab for red-highlighted events")
                    Text("• The test app will appear in Suspects")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.top)

            Spacer()
        }
        .padding(.vertical)
    }
}

struct FocusEventRow: View {
    let event: FocusEvent

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(timeString)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if event.isSteal {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Spacer()
                }

                HStack {
                    Text(event.fromApp.displayName)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Image(systemName: "arrow.right")
                        .foregroundColor(.secondary)
                        .font(.caption)

                    Text(event.toApp.displayName)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .fontWeight(event.isSteal ? .medium : .regular)
                        .foregroundColor(event.isSteal ? .red : .primary)
                }
                .font(.system(size: 12))
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(event.isSteal ? Color.red.opacity(0.1) : Color.clear)
        )
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: event.timestamp)
    }
}

struct SuspectRow: View {
    @ObservedObject var suspect: SuspectApp

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(suspect.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)

                Text(suspect.bundleIdentifier)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(suspect.stealCount)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.red)

                if let lastSteal = suspect.lastStealTime {
                    Text(lastStealTimeString(lastSteal))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.red.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func lastStealTimeString(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}