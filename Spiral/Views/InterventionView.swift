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
            // Clean background
            CleanBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    Spacer(minLength: 30)

                    // Spiral - stunning breaking animation
                    SpiralAnimation(state: .breaking, size: 180)
                        .padding(.bottom, 10)

                    // Header
                    Text(viewModel.interventionHeader)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Duration message
                    Text(viewModel.durationMessage)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    // Roast message - hero element
                    VStack(spacing: 12) {
                        Text("💬")
                            .font(.system(size: 40))

                        Text(viewModel.roastMessage)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .accentCard(color: .electricBlue, padding: 24)
                    .padding(.horizontal)

                    // Mode-specific content
                    if viewModel.mode == .accountability && viewModel.waitTime > 0 {
                        accountabilityTimerView
                    } else if viewModel.mode == .lockdown && !viewModel.taskCompleted {
                        lockdownChallengeView
                    } else {
                        quickResponseButtons
                    }

                    // Optional note
                    if viewModel.mode != .lockdown || viewModel.taskCompleted {
                        optionalNoteField
                    }

                    Spacer(minLength: 20)

                    // Bottom actions
                    bottomActions

                    Spacer(minLength: 30)
                }
            }
        }
        .onAppear {
            viewModel.triggerHaptics()
            viewModel.playSound()
        }
    }

    // MARK: - Quick Response Buttons

    private var quickResponseButtons: some View {
        VStack(spacing: 12) {
            responseButton("Worth it - saw good stuff ✓", icon: "checkmark.circle.fill", type: .worthIt, color: .successGreen)
            responseButton("Total waste - help me stop 🛑", icon: "hand.raised.fill", type: .waste, color: .alertRed)
            responseButton("Just taking a break 😌", icon: "moon.stars.fill", type: .justBreak, color: .electricBlue)
        }
        .modernCard(padding: 16)
        .padding(.horizontal)
    }

    private func responseButton(_ text: String, icon: String, type: ResponseType, color: Color) -> some View {
        Button(action: {
            HapticsManager.shared.mediumImpact()
            viewModel.recordResponse(type, note: viewModel.note)
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 40, height: 40)

                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                }

                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if viewModel.selectedResponse == type {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(color)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(viewModel.selectedResponse == type ? color.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        viewModel.selectedResponse == type ? color : Color.white.opacity(0.1),
                        lineWidth: viewModel.selectedResponse == type ? 2 : 0.5
                    )
            )
        }
    }

    // MARK: - Accountability Mode Timer

    private var accountabilityTimerView: some View {
        VStack(spacing: 20) {
            Text("THINK ABOUT IT")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .tracking(2)
                .foregroundColor(.secondary)

            // Clean timer display
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 10)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.waitTime) / CGFloat(AppConstants.accountabilityWaitTime))
                    .stroke(Color.warningOrange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(viewModel.waitTime)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("seconds")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }

            Text("Dismiss available soon")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)

            if viewModel.dismissalsToday > 0 {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 12))
                    Text("Dismissals today: \(viewModel.dismissalsToday)/\(AppConstants.maxDismissalsPerDay)")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundColor(.warningOrange)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.warningOrange.opacity(0.15))
                )
            }
        }
        .modernCard(padding: 24)
        .padding(.horizontal)
    }

    // MARK: - Lockdown Mode Challenge

    private var lockdownChallengeView: some View {
        VStack(spacing: 20) {
            Text("🔒 LOCKDOWN MODE")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .tracking(2)
                .foregroundColor(.alertRed)

            Text("Complete a task to continue")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)

            // Math challenge
            VStack(spacing: 16) {
                Text("🧮")
                    .font(.system(size: 36))

                Text(viewModel.lockdownChallenge)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.electricBlue)

                TextField("", text: $viewModel.userAnswer)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .frame(width: 150)
                    .onChange(of: viewModel.userAnswer) { _, _ in
                        viewModel.checkAnswer()
                    }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.alertRed.opacity(0.1))
            )

            // OR divider
            HStack {
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                Text("OR")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 10)
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
            }

            // Wait timer option
            Button(action: {
                HapticsManager.shared.mediumImpact()
                viewModel.startWaitTimer()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 16, weight: .medium))

                    Text(viewModel.waitTime > 0 ? "Waiting... \(viewModel.waitTime)s" : "Wait 60 seconds instead")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(viewModel.waitTime > 0 ? .warningOrange : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            viewModel.waitTime > 0 ? Color.warningOrange : Color.white.opacity(0.2),
                            lineWidth: 1
                        )
                )
            }
            .disabled(viewModel.waitTime > 0)

            if viewModel.waitTime > 0 {
                ProgressView(value: 1.0 - Double(viewModel.waitTime) / 60.0)
                    .tint(.warningOrange)
            }
        }
        .modernCard(padding: 24)
        .padding(.horizontal)
    }

    // MARK: - Optional Note Field

    private var optionalNoteField: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "note.text")
                    .font(.system(size: 14, weight: .medium))
                Text("Optional Note")
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(.secondary)

            TextField("What did you see or learn?", text: $viewModel.note, axis: .vertical)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
                .lineLimit(3...5)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.05))
                )
        }
        .modernCard(padding: 16)
        .padding(.horizontal)
    }

    // MARK: - Bottom Actions

    private var bottomActions: some View {
        VStack(spacing: 12) {
            // Primary dismiss button
            Button(action: {
                HapticsManager.shared.success()
                viewModel.dismiss()
                dismiss()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: viewModel.canDismiss ? "checkmark.circle.fill" : "lock.fill")
                        .font(.system(size: 16, weight: .semibold))

                    Text(viewModel.canDismiss ? "Continue" : "Complete Task First")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    viewModel.canDismiss ?
                    LinearGradient(
                        colors: [.electricBlue, .neonPurple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .disabled(!viewModel.canDismiss)

            // Secondary share button
            Button(action: {
                HapticsManager.shared.lightTap()
                // TODO: Phase 3 - Share functionality
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14, weight: .medium))

                    Text("Share this roast")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(.electricBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.electricBlue.opacity(0.5), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal)
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
