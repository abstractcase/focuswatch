// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FocusWatch",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "FocusWatch", targets: ["FocusWatch"])
    ],
    targets: [
        .executableTarget(
            name: "FocusWatch",
            path: "FocusWatch",
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