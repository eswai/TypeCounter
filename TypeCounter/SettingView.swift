import SwiftUI

struct SettingView: View {

    var body: some View {
        TabView {
            StatsView()
                .tabItem { Label("Statistics", systemImage: "keyboard") }
                .frame(minWidth: 400, minHeight: 400)
            OptionsView()
                .tabItem { Label("Setting", systemImage: "slider.horizontal.2.square.on.square") }
                .frame(minWidth: 400, minHeight: 100)
        }
    }
}

struct StatsView: View {
    @State var keys: [KeyCount] = []
    @State var total_count = 0
    @State private var showAlert = false

    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    let timerSave = Timer.publish(every: 3 * 60, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Total number of keys typed \(total_count)")
            Table(keys) {
                TableColumn("Key") { key in
                    Text(String(key.keychar()))
                }
                TableColumn("Typed") { key in
                    Text("\(key.count)")
                }
            }.onReceive(timer) { _ in
                if stat_changed {
                    keys = []
                    total_count = 0
                    for (k, v) in keystats {
                        keys.append(KeyCount(keycode: k, count: v))
                        total_count += v
                    }
                    keys.sort { $0.count > $1.count }
                    stat_changed = false
                }
            }.onReceive(timerSave) { _ in
                CSV.write(data: keystats, filename: "keystats.csv")
            }
            Button("Reset statistics") {
                showAlert = true
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure to reset the statistics?"),
                    primaryButton: .default(Text("Yes"), action: {
                        keystats.removeAll()
                        stat_changed = true
                        CSV.write(data: keystats, filename: "keystats.csv")
                    }),
                    secondaryButton: .cancel(Text("No"))
                )
            }
        }
        .padding()
    }
}

struct OptionsView: View {
//    @State private var isChecked = false
    
    var body: some View {
        VStack {
            Button("Open location of recorded data") {
                openFinder()
            }
        }
        .padding()
    }
    
    func openFinder() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            NSWorkspace.shared.open(dir)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
