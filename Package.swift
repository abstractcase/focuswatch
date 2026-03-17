// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FocusCop",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "FocusCop", targets: ["FocusCop"])
    ],
    targets: [
        .executableTarget(
            name: "FocusCop",
            path: "FocusCop",
            sources: [
                "FocusCoApp.swift",
                "ContentView.swift",
                "FocusMonitor.swift",
                "FocusEvent.swift",
                "MenuBarController.swift",
                "PermissionsManager.swift"
            ]
        )
    ]
)