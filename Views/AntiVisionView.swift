import SwiftUI

struct AntiVisionView: View {
    @Environment(AppState.self) private var appState
    @Binding var isExpanded: Bool
    @State private var isEditing = false
    @State private var editedAntiVision = ""

    var body: some View {
        VStack(spacing: 8) {
            // Header (always visible)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 12))
                        .foregroundStyle(.orange.opacity(0.8))

                    Text("Anti-Vision")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            // Expanded content
            if isExpanded {
                if isEditing {
                    VStack(spacing: 8) {
                        TextField("What you want to avoid...", text: $editedAntiVision, axis: .vertical)
                            .textFieldStyle(.plain)
                            .font(.system(size: 14, design: .serif))
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                            .onSubmit {
                                saveAntiVision()
                            }
                            .onAppear {
                                editedAntiVision = appState.antiVision
                            }

                        HStack(spacing: 12) {
                            Button("Cancel") {
                                isEditing = false
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.secondary)
                            .font(.system(size: 12))

                            Button("Save") {
                                saveAntiVision()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                        }
                    }
                    .padding(.top, 8)
                } else {
                    Text(appState.antiVision)
                        .font(.system(size: 14, design: .serif))
                        .foregroundStyle(.secondary)
                        .italic()
                        .onTapGesture {
                            editedAntiVision = appState.antiVision
                            isEditing = true
                        }
                        .help("Click to edit your anti-vision")
                        .padding(.top, 4)
                }
            }
        }
        .padding(.horizontal, 24)
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    }

    private func saveAntiVision() {
        appState.updateAntiVision(editedAntiVision)
        isEditing = false
    }
}

#Preview {
    @Previewable @State var isExpanded = true
    let state = AppState()
    state.antiVision = "Stuck in the same place, doing the same things, never growing or improving."
    return AntiVisionView(isExpanded: $isExpanded)
        .environment(state)
}
