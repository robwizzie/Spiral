//
//  InterventionView.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI

struct InterventionView: View {
    @StateObject var viewModel: InterventionViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color.deepPurple, Color.neonPurple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Spiral animation - breaking state
                SpiralAnimation(state: .breaking, size: 200)

                // Header
                Text(viewModel.interventionHeader)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                // Duration message
                Text(viewModel.durationMessage)
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))

                // Roast message
                Text(viewModel.roastMessage)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.electricBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)

                // Mode-specific content
                if viewModel.mode == .accountability && viewModel.waitTime > 0 {
                    accountabilityTimerView
                } else if viewModel.mode == .lockdown && !viewModel.taskCompleted {
                    lockdownChallengeView
                } else {
                    quickResponseButtons
                }

                // Optional note (only for gentle and accountability after timer)
                if viewModel.mode != .lockdown || viewModel.taskCompleted {
                    optionalNoteField
                }

                Spacer()

                // Bottom actions
                bottomActions
            }
            .padding()
        }
        .onAppear {
            viewModel.triggerHaptics()
            viewModel.playSound()
        }
    }

    // MARK: - Quick Response Buttons

    private var quickResponseButtons: some View {
        VStack(spacing: 12) {
            responseButton("Worth it - saw good stuff ✓", type: .worthIt)
            responseButton("Total waste - help me stop 🛑", type: .waste)
            responseButton("Just taking a break 😌", type: .justBreak)
        }
        .padding(.horizontal)
    }

    private func responseButton(_ text: String, type: ResponseType) -> some View {
        Button(action: {
            viewModel.recordResponse(type, note: viewModel.note)
        }) {
            HStack {
                Text(text)
                    .font(.system(size: 17, weight: .medium))
                Spacer()
                if viewModel.selectedResponse == type {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(
                viewModel.selectedResponse == type
                    ? Color("ElectricBlue").opacity(0.3)
                    : Color.white.opacity(0.1)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        viewModel.selectedResponse == type ? Color("ElectricBlue") : Color.clear,
                        lineWidth: 2
                    )
            )
        }
    }

    // MARK: - Accountability Mode Timer

    private var accountabilityTimerView: some View {
        VStack(spacing: 16) {
            Text("Dismiss available in \(viewModel.waitTime)s")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 8)
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.waitTime) / CGFloat(AppConstants.accountabilityWaitTime))
                    .stroke(Color("ElectricBlue"), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                Text("\(viewModel.waitTime)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }

            if viewModel.dismissalsToday > 0 {
                Text("Dismissals today: \(viewModel.dismissalsToday)/\(AppConstants.maxDismissalsPerDay)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
    }

    // MARK: - Lockdown Mode Challenge

    private var lockdownChallengeView: some View {
        VStack(spacing: 20) {
            Text("Complete a task to continue")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            // Math challenge
            VStack(spacing: 12) {
                Text(viewModel.lockdownChallenge)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                TextField("Your answer", text: $viewModel.userAnswer)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 150)
                    .onChange(of: viewModel.userAnswer) { _, _ in
                        viewModel.checkAnswer()
                    }
            }

            Text("OR")
                .foregroundColor(.white.opacity(0.5))

            // Wait timer option
            Button(action: {
                viewModel.startWaitTimer()
            }) {
                Text("Wait 60 seconds")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
            }
            .disabled(viewModel.waitTime > 0)

            if viewModel.waitTime > 0 {
                Text("Wait time: \(viewModel.waitTime)s")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }

    // MARK: - Optional Note Field

    private var optionalNoteField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Want to note what you saw? (Optional)")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.7))

            TextField("Type here...", text: $viewModel.note)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }

    // MARK: - Bottom Actions

    private var bottomActions: some View {
        HStack(spacing: 16) {
            Button("Share this roast") {
                // TODO: Phase 3 - Share functionality
            }
            .buttonStyle(SecondaryButtonStyle())

            Button("Dismiss") {
                viewModel.dismiss()
                dismiss()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(!viewModel.canDismiss)
        }
        .padding(.horizontal)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(
                LinearGradient(
                    colors: [Color("ElectricBlue"), Color("NeonPurple")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(Color("ElectricBlue"))
            .padding(.vertical, 14)
            .padding(.horizontal, 22)
            .background(
                Color.white.opacity(configuration.isPressed ? 0.1 : 0.05)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("ElectricBlue"), lineWidth: 2)
            )
            .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    InterventionView(
        viewModel: InterventionViewModel(
            mode: .gentle,
            duration: 1680,
            interventionsToday: 2
        )
    )
}
