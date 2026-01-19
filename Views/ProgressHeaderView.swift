import SwiftUI

struct ProgressHeaderView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        HStack {
            // Day counter
            VStack(alignment: .leading, spacing: 2) {
                Text("Day \(appState.currentDay)")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("of 365")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Streak indicator
            HStack(spacing: 6) {
                ForEach(0..<min(appState.currentStreak, 7), id: \.self) { index in
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 8, height: 8)
                }

                if appState.currentStreak > 7 {
                    Text("+\(appState.currentStreak - 7)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                if appState.currentStreak == 0 {
                    Text("Start your streak!")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

#Preview {
    ProgressHeaderView()
        .environment(AppState())
}
