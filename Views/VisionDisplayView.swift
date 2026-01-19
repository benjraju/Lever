import SwiftUI

struct VisionDisplayView: View {
    @Environment(AppState.self) private var appState
    @State private var isEditing = false
    @State private var editedVision = ""

    var body: some View {
        VStack(spacing: 8) {
            if isEditing {
                TextField("Your vision...", text: $editedVision, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .onSubmit {
                        saveVision()
                    }
                    .onAppear {
                        editedVision = appState.vision
                    }

                HStack(spacing: 12) {
                    Button("Cancel") {
                        isEditing = false
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)

                    Button("Save") {
                        saveVision()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            } else {
                Text("\"\(appState.vision)\"")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundStyle(.primary.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .onTapGesture {
                        editedVision = appState.vision
                        isEditing = true
                    }
                    .help("Click to edit your vision")
            }
        }
        .padding(.horizontal, 32)
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    }

    private func saveVision() {
        appState.updateVision(editedVision)
        isEditing = false
    }
}

#Preview {
    let state = AppState()
    state.vision = "Build something meaningful that helps others"
    return VisionDisplayView()
        .environment(state)
}
