import SwiftUI

@main
struct LeverApp: App {
    @State private var appState: AppState

    init() {
        let state = AppState()
        if let savedState = StorageService.shared.load() {
            state.load(from: savedState)
        }
        _appState = State(initialValue: state)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Task") {
                    NotificationCenter.default.post(name: .addNewTask, object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
    }
}

extension Notification.Name {
    static let addNewTask = Notification.Name("addNewTask")
}
