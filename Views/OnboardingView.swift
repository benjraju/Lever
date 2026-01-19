import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var currentStep = 0
    @State private var vision = ""
    @State private var antiVision = ""
    @State private var startDate = Date()

    private let steps = ["Welcome", "Vision", "Anti-Vision", "Start Date"]

    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            HStack(spacing: 8) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Circle()
                        .fill(index <= currentStep ? Color.accentColor : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 32)

            // Content
            TabView(selection: $currentStep) {
                WelcomeStep(onContinue: nextStep)
                    .tag(0)

                VisionStep(vision: $vision, onContinue: nextStep, onBack: previousStep)
                    .tag(1)

                AntiVisionStep(antiVision: $antiVision, onContinue: nextStep, onBack: previousStep)
                    .tag(2)

                StartDateStep(startDate: $startDate, onComplete: completeOnboarding, onBack: previousStep)
                    .tag(3)
            }
            .tabViewStyle(.automatic)
        }
        .background(Color(NSColor.windowBackgroundColor))
    }

    private func nextStep() {
        withAnimation {
            currentStep = min(currentStep + 1, steps.count - 1)
        }
    }

    private func previousStep() {
        withAnimation {
            currentStep = max(currentStep - 1, 0)
        }
    }

    private func completeOnboarding() {
        appState.completeOnboarding(
            vision: vision,
            antiVision: antiVision,
            startDate: startDate
        )
    }
}

// MARK: - Onboarding Steps

struct WelcomeStep: View {
    var onContinue: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "arrow.up.right.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.accentColor)

            VStack(spacing: 12) {
                Text("Welcome to Lever")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                Text("Focus on what moves the needle.\nOne hour. Three tasks. Every day.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            Button(action: onContinue) {
                Text("Get Started")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.plain)
            .background(Color.accentColor)
            .cornerRadius(10)
            .padding(.horizontal, 48)
            .padding(.bottom, 32)
        }
    }
}

struct VisionStep: View {
    @Binding var vision: String
    var onContinue: () -> Void
    var onBack: () -> Void
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Text("What's your vision?")
                    .font(.system(size: 24, weight: .bold, design: .rounded))

                Text("What are you working towards?\nThis will keep you motivated every day.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            TextField("e.g., Build something meaningful that helps others", text: $vision, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 16, design: .serif))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 48)
                .focused($isFocused)

            Spacer()

            HStack(spacing: 16) {
                Button(action: onBack) {
                    Text("Back")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.plain)

                Button(action: onContinue) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
                .background(vision.isEmpty ? Color.secondary : Color.accentColor)
                .cornerRadius(10)
                .disabled(vision.isEmpty)
            }
            .padding(.horizontal, 48)
            .padding(.bottom, 32)
        }
        .onAppear {
            isFocused = true
        }
    }
}

struct AntiVisionStep: View {
    @Binding var antiVision: String
    var onContinue: () -> Void
    var onBack: () -> Void
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Text("What's your anti-vision?")
                    .font(.system(size: 24, weight: .bold, design: .rounded))

                Text("What do you want to avoid?\nThis is what happens if you don't take action.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            TextField("e.g., Stuck in the same place, never growing or improving", text: $antiVision, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 16, design: .serif))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 48)
                .focused($isFocused)

            Spacer()

            HStack(spacing: 16) {
                Button(action: onBack) {
                    Text("Back")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.plain)

                Button(action: onContinue) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
                .background(antiVision.isEmpty ? Color.secondary : Color.accentColor)
                .cornerRadius(10)
                .disabled(antiVision.isEmpty)
            }
            .padding(.horizontal, 48)
            .padding(.bottom, 32)
        }
        .onAppear {
            isFocused = true
        }
    }
}

struct StartDateStep: View {
    @Binding var startDate: Date
    var onComplete: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Text("When did you start?")
                    .font(.system(size: 24, weight: .bold, design: .rounded))

                Text("Set your Day 1. This tracks your 365-day journey.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            DatePicker("", selection: $startDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding(.horizontal, 48)

            Spacer()

            HStack(spacing: 16) {
                Button(action: onBack) {
                    Text("Back")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.plain)

                Button(action: onComplete) {
                    Text("Start Journey")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
                .background(Color.accentColor)
                .cornerRadius(10)
            }
            .padding(.horizontal, 48)
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    OnboardingView()
        .environment(AppState())
        .frame(width: 480, height: 640)
}
