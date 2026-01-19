import Foundation
import SwiftUI

@Observable
final class AppState {
    // MARK: - Vision & Anti-Vision
    var vision: String = ""
    var antiVision: String = ""

    // MARK: - Progress Tracking
    var startDate: Date = Date()
    var completedDays: Set<String> = []  // Store as ISO date strings for Codable

    // MARK: - Tasks
    var tasks: [LeverTask] = []

    // MARK: - Timer
    var timerState: TimerState = TimerState()

    // MARK: - App State
    var hasCompletedOnboarding: Bool = false

    // MARK: - Computed Properties

    var currentDay: Int {
        let calendar = Calendar.current
        let startOfStart = calendar.startOfDay(for: startDate)
        let startOfToday = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: startOfStart, to: startOfToday)
        return (components.day ?? 0) + 1
    }

    var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())

        // If today is completed, count it
        if isDayCompleted(checkDate) {
            streak = 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }

        // Count consecutive completed days going backwards
        while isDayCompleted(checkDate) {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }

        return streak
    }

    var todayKey: String {
        dateKey(for: Date())
    }

    var isTodayCompleted: Bool {
        completedDays.contains(todayKey)
    }

    var allTasksCompleted: Bool {
        !tasks.isEmpty && tasks.allSatisfy { $0.isCompleted }
    }

    // MARK: - Methods

    func dateKey(for date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: Calendar.current.startOfDay(for: date))
    }

    func isDayCompleted(_ date: Date) -> Bool {
        completedDays.contains(dateKey(for: date))
    }

    func markTodayComplete() {
        completedDays.insert(todayKey)
        StorageService.shared.save(self)
    }

    func addTask(_ title: String) {
        guard !title.isEmpty, tasks.count < 3 else { return }
        let task = LeverTask(title: title)
        tasks.append(task)
        StorageService.shared.save(self)
    }

    func toggleTask(_ task: LeverTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            StorageService.shared.save(self)
        }
    }

    func deleteTask(_ task: LeverTask) {
        tasks.removeAll { $0.id == task.id }
        StorageService.shared.save(self)
    }

    func resetTasksForNewDay() {
        // Reset all tasks to incomplete for a new day
        for index in tasks.indices {
            tasks[index].isCompleted = false
        }
        StorageService.shared.save(self)
    }

    func updateVision(_ newVision: String) {
        vision = newVision
        StorageService.shared.save(self)
    }

    func updateAntiVision(_ newAntiVision: String) {
        antiVision = newAntiVision
        StorageService.shared.save(self)
    }

    func completeOnboarding(vision: String, antiVision: String, startDate: Date) {
        self.vision = vision
        self.antiVision = antiVision
        self.startDate = startDate
        self.hasCompletedOnboarding = true
        StorageService.shared.save(self)
    }

    func resetTimer() {
        timerState = TimerState()
        StorageService.shared.save(self)
    }
}

// MARK: - Codable Support

extension AppState {
    struct CodableState: Codable {
        var vision: String
        var antiVision: String
        var startDate: Date
        var completedDays: Set<String>
        var tasks: [LeverTask]
        var timerState: TimerState
        var hasCompletedOnboarding: Bool
    }

    func toCodable() -> CodableState {
        CodableState(
            vision: vision,
            antiVision: antiVision,
            startDate: startDate,
            completedDays: completedDays,
            tasks: tasks,
            timerState: timerState,
            hasCompletedOnboarding: hasCompletedOnboarding
        )
    }

    func load(from codable: CodableState) {
        vision = codable.vision
        antiVision = codable.antiVision
        startDate = codable.startDate
        completedDays = codable.completedDays
        tasks = codable.tasks
        timerState = codable.timerState
        hasCompletedOnboarding = codable.hasCompletedOnboarding
    }
}
