import SwiftUI

struct MainView: View {
    @Environment(AppState.self) private var appState
    @State private var timerService: TimerService?
    @State private var showingAntiVision = false

    var body: some View {
        VStack(spacing: 0) {
            // PINNED: Header always visible
            ProgressHeaderView()
                .padding(.bottom, 8)

            // SCROLLABLE: Main content
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    VisionDisplayView()
                        .padding(.top, 16)
                    TimerView(timerService: timerService)
                    TaskListView()
                    AntiVisionView(isExpanded: $showingAntiVision)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.visible)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            timerService = TimerService(appState: appState)
            loadSavedState()
            checkForNewDay()
        }
        .onReceive(NotificationCenter.default.publisher(for: .addNewTask)) { _ in
            // Handle Cmd+N - focus is managed in TaskListView
        }
    }

    private func loadSavedState() {
        if let savedState = StorageService.shared.load() {
            appState.load(from: savedState)
        }
    }

    private func checkForNewDay() {
        // Check if we need to reset tasks for a new day
        let calendar = Calendar.current
        let lastTaskDate = appState.tasks.first?.createdAt ?? Date()

        if !calendar.isDateInToday(lastTaskDate) && !appState.tasks.isEmpty {
            // It's a new day - reset task completion status
            appState.resetTasksForNewDay()
        }
    }
}

#Preview {
    MainView()
        .environment(AppState())
        .frame(minWidth: 400, idealWidth: 480, maxWidth: 600,
               minHeight: 500, idealHeight: 640, maxHeight: 900)
}
