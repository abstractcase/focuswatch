import SwiftUI

@main
struct SimpleFocusApp: App {
    private var menuBarController = SimpleMenuBarController()

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}