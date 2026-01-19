import Foundation

struct TimerState: Codable, Equatable {
    var duration: TimeInterval  // Default 60 minutes
    var elapsed: TimeInterval
    var isRunning: Bool

    init(duration: TimeInterval = 60 * 60, elapsed: TimeInterval = 0, isRunning: Bool = false) {
        self.duration = duration
        self.elapsed = elapsed
        self.isRunning = isRunning
    }

    var remaining: TimeInterval {
        max(0, duration - elapsed)
    }

    var progress: Double {
        guard duration > 0 else { return 0 }
        return min(1.0, elapsed / duration)
    }

    var isComplete: Bool {
        elapsed >= duration
    }

    var formattedRemaining: String {
        let totalSeconds = Int(remaining)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
