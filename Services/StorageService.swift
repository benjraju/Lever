import Foundation

final class StorageService {
    static let shared = StorageService()

    private let fileName = "lever-data.json"

    private var fileURL: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectory = appSupport.appendingPathComponent("Lever", isDirectory: true)

        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: appDirectory.path) {
            try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        }

        return appDirectory.appendingPathComponent(fileName)
    }

    private init() {}

    func save(_ appState: AppState) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(appState.toCodable())
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save app state: \(error)")
        }
    }

    func load() -> AppState.CodableState? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let data = try Data(contentsOf: fileURL)
            return try decoder.decode(AppState.CodableState.self, from: data)
        } catch {
            print("Failed to load app state: \(error)")
            return nil
        }
    }

    func exportToMarkdown(_ appState: AppState) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long

        var markdown = """
        # Lever - Daily Focus

        ## Vision
        \(appState.vision)

        ## Anti-Vision
        \(appState.antiVision)

        ## Progress
        - **Start Date:** \(dateFormatter.string(from: appState.startDate))
        - **Current Day:** Day \(appState.currentDay) of 365
        - **Current Streak:** \(appState.currentStreak) days

        ## Today's Lever Tasks
        """

        for task in appState.tasks {
            let checkbox = task.isCompleted ? "[x]" : "[ ]"
            markdown += "\n- \(checkbox) \(task.title)"
        }

        markdown += "\n\n---\n*Exported from Lever on \(dateFormatter.string(from: Date()))*"

        return markdown
    }
}
