import SwiftUI

var keystats: [Int: Int] = [:]
var stat_changed = true

@main
struct TypeCounterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            SettingView()
        }
        MenuBarExtra("TypeCounter", systemImage: "keyboard.badge.eye") {
            MenuView()
        }
    }
}
