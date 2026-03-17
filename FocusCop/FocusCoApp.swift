import SwiftUI

@main
struct FocusCoApp: App {
    private var menuBarController = SimpleMenuBarController()

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}