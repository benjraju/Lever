import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                MainView()
            } else {
                OnboardingView()
            }
        }
        .frame(minWidth: 400, idealWidth: 480, maxWidth: 600,
               minHeight: 500, idealHeight: 640, maxHeight: 900)
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
