import SwiftUI

struct TaskListView: View {
    @Environment(AppState.self) private var appState
    @State private var newTaskTitle = ""
    @State private var isAddingTask = false
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("Today's Levers")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                if appState.tasks.count < 3 && !isAddingTask {
                    Button(action: {
                        isAddingTask = true
                        isTextFieldFocused = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .help("Add task (⌘N)")
                }
            }

            // Task list
            VStack(spacing: 8) {
                ForEach(appState.tasks) { task in
                    TaskRowView(task: task)
                }

                // Add task field
                if isAddingTask {
                    HStack(spacing: 12) {
                        Circle()
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
                            .frame(width: 20, height: 20)

                        TextField("What's your lever?", text: $newTaskTitle)
                            .textFieldStyle(.plain)
                            .font(.system(size: 15))
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                addTask()
                            }

                        Button("Cancel") {
                            cancelAddTask()
                        }
                        .buttonStyle(.plain)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.secondary.opacity(0.05))
                    .cornerRadius(8)
                }

                // Empty state
                if appState.tasks.isEmpty && !isAddingTask {
                    VStack(spacing: 8) {
                        Text("No lever tasks yet")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)

                        Button("Add your first task") {
                            isAddingTask = true
                            isTextFieldFocused = true
                        }
                        .buttonStyle(.plain)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.accentColor)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            }
            .padding(12)
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)

            // Complete day button
            if appState.allTasksCompleted && !appState.isTodayCompleted {
                Button(action: {
                    appState.markTodayComplete()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Complete Day \(appState.currentDay)")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .background(Color.accentColor)
                .cornerRadius(8)
            }

            if appState.isTodayCompleted {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.accentColor)
                    Text("Day \(appState.currentDay) completed!")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .padding(.horizontal, 24)
        .onReceive(NotificationCenter.default.publisher(for: .addNewTask)) { _ in
            if appState.tasks.count < 3 {
                isAddingTask = true
                isTextFieldFocused = true
            }
        }
    }

    private func addTask() {
        guard !newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            cancelAddTask()
            return
        }
        appState.addTask(newTaskTitle.trimmingCharacters(in: .whitespaces))
        newTaskTitle = ""
        isAddingTask = false
    }

    private func cancelAddTask() {
        newTaskTitle = ""
        isAddingTask = false
        isTextFieldFocused = false
    }
}

struct TaskRowView: View {
    @Environment(AppState.self) private var appState
    let task: LeverTask
    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: {
                appState.toggleTask(task)
            }) {
                ZStack {
                    Circle()
                        .stroke(task.isCompleted ? Color.accentColor : Color.secondary.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 20, height: 20)

                    if task.isCompleted {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 20, height: 20)

                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)

            // Task title
            Text(task.title)
                .font(.system(size: 15))
                .foregroundStyle(task.isCompleted ? .secondary : .primary)
                .strikethrough(task.isCompleted, color: .secondary)

            Spacer()

            // Delete button (on hover)
            if isHovering {
                Button(action: {
                    appState.deleteTask(task)
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(isHovering ? Color.secondary.opacity(0.08) : Color.clear)
        .cornerRadius(8)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

#Preview {
    let state = AppState()
    state.tasks = [
        LeverTask(title: "Write 500 words"),
        LeverTask(title: "Ship feature update", isCompleted: true),
        LeverTask(title: "Review analytics")
    ]
    return TaskListView()
        .environment(state)
        .frame(width: 480)
}
