import SwiftUI

struct TimerView: View {
    @Environment(AppState.self) private var appState
    var timerService: TimerService?

    var body: some View {
        VStack(spacing: 20) {
            // Timer display
            ZStack {
                // Background ring
                Circle()
                    .stroke(Color.accentColor.opacity(0.2), lineWidth: 8)
                    .frame(width: 180, height: 180)

                // Progress ring
                Circle()
                    .trim(from: 0, to: appState.timerState.progress)
                    .stroke(
                        Color.accentColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: appState.timerState.progress)

                // Time display
                VStack(spacing: 4) {
                    Text(appState.timerState.formattedRemaining)
                        .font(.system(size: 48, weight: .light, design: .monospaced))
                        .foregroundStyle(.primary)

                    if appState.timerState.isComplete {
                        Text("Complete!")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }

            // Control buttons
            HStack(spacing: 16) {
                if appState.timerState.elapsed > 0 {
                    Button(action: {
                        timerService?.reset()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(Circle())
                }

                Button(action: {
                    timerService?.toggle()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: appState.timerState.isRunning ? "pause.fill" : "play.fill")
                        Text(appState.timerState.isRunning ? "Pause" : "Start")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 120, height: 44)
                }
                .buttonStyle(.plain)
                .background(Color.accentColor)
                .clipShape(Capsule())
            }
        }
        .keyboardShortcut(.space, modifiers: [])
    }
}

#Preview {
    let state = AppState()
    state.timerState.elapsed = 1200
    return TimerView(timerService: nil)
        .environment(state)
}
