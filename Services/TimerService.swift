import Foundation
import Combine

@MainActor
final class TimerService: ObservableObject {
    private var timer: Timer?
    private weak var appState: AppState?

    init(appState: AppState) {
        self.appState = appState
    }

    func start() {
        guard let appState = appState, !appState.timerState.isRunning else { return }

        appState.timerState.isRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    func pause() {
        guard let appState = appState else { return }

        timer?.invalidate()
        timer = nil
        appState.timerState.isRunning = false
        StorageService.shared.save(appState)
    }

    func reset() {
        guard let appState = appState else { return }

        timer?.invalidate()
        timer = nil
        appState.timerState = TimerState()
        StorageService.shared.save(appState)
    }

    func toggle() {
        guard let appState = appState else { return }

        if appState.timerState.isRunning {
            pause()
        } else {
            start()
        }
    }

    private func tick() {
        guard let appState = appState, appState.timerState.isRunning else { return }

        appState.timerState.elapsed += 1

        if appState.timerState.isComplete {
            pause()
            // Could trigger notification here
        }
    }

    deinit {
        timer?.invalidate()
    }
}
