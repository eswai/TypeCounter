import SwiftUI

struct MenuView: View {
    var body: some View {
        Button("Statistics...") {
            showSettingsWindow()
        }
        Divider()
        Button("About TypeCounter") {
            showAbout()
        }
        Button("Quit TypeCounter") {
            quitApp()
        }
        .keyboardShortcut("Q")
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

private func showSettingsWindow() {
    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    NSApp.activate(ignoringOtherApps: true)
}

private func showAbout() {
    NSApp.activate(ignoringOtherApps: true)
    NSApp.orderFrontStandardAboutPanel()
}

private func quitApp() {
    NSApplication.shared.terminate(nil)
}
