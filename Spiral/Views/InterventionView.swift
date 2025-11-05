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
            // Animated gradient background
            AnimatedGradientBackground(
                colors: [.deepPurple, .neonPurple, .electricBlue],
                speed: 12.0
            )

            // Floating particles for depth and urgency
            ParticleField(count: 20, colors: [.electricBlue, .neonPurple, .alertRed])
                .opacity(0.5)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    Spacer(minLength: 40)

                    // Dramatic spiral animation with enhanced glow
                    ZStack {
                        // Outer warning pulse
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.alertRed.opacity(0.5),
                                        Color.neonPurple.opacity(0.3),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 100,
                                    endRadius: 220
                                )
                            )
                            .frame(width: 440, height: 440)
                            .pulse(from: 0.85, to: 1.15, duration: 2)

                        // Inner intense glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.electricBlue.opacity(0.8),
                                        Color.neonPurple.opacity(0.4),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 140
                                )
                            )
                            .frame(width: 280, height: 280)
                            .blur(radius: 30)

                        SpiralAnimation(state: .breaking, size: 240)
                            .neonGlow(color: .electricBlue, radius: 35)
                    }
                    .padding(.bottom, 10)

                    // DRAMATIC header with gradient and glow
                    Text(viewModel.interventionHeader)
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .tracking(2)
                        .gradientForeground(colors: [.electricBlue, .neonPurple, .electricBlue])
                        .neonGlow(color: .neonPurple, radius: 18)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Duration message with larger font
                    Text(viewModel.durationMessage)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)

                    // MASSIVE roast message in glassmorphic card
                    VStack(spacing: 12) {
                        Text("💬")
                            .font(.system(size: 50))

                        Text(viewModel.roastMessage)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 25)
                    .glassmorphicCard(cornerRadius: 24, shadowRadius: 30)
                    .padding(.horizontal)

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

                    Spacer(minLength: 20)

                    // Bottom actions
                    bottomActions

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 5)
            }
        }
        .onAppear {
            viewModel.triggerHaptics()
            viewModel.playSound()
        }
    }

    // MARK: - Quick Response Buttons

    private var quickResponseButtons: some View {
        VStack(spacing: 16) {
            Text("HOW WAS IT?")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .tracking(3)
                .foregroundColor(.white.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            VStack(spacing: 14) {
                responseButton("Worth it - saw good stuff ✓", icon: "checkmark.circle.fill", type: .worthIt, color: .successGreen)
                responseButton("Total waste - help me stop 🛑", icon: "hand.raised.fill", type: .waste, color: .alertRed)
                responseButton("Just taking a break 😌", icon: "moon.stars.fill", type: .justBreak, color: .electricBlue)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .glassmorphicCard(cornerRadius: 24, shadowRadius: 25)
        .padding(.horizontal)
    }

    private func responseButton(_ text: String, icon: String, type: ResponseType, color: Color) -> some View {
        Button(action: {
            HapticsManager.shared.mediumImpact()
            viewModel.recordResponse(type, note: viewModel.note)
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(text)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Spacer()

                if viewModel.selectedResponse == type {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(color)
                        .neonGlow(color: color, radius: 8)
                }
            }
            .padding(18)
            .background(
                ZStack {
                    if viewModel.selectedResponse == type {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(color.opacity(0.15))
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(color, lineWidth: 2)
                            .neonGlow(color: color, radius: 6)
                    } else {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.05))
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    }
                }
            )
        }
    }

    // MARK: - Accountability Mode Timer

    private var accountabilityTimerView: some View {
        VStack(spacing: 24) {
            Text("THINK ABOUT IT")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .tracking(3)
                .foregroundColor(.white.opacity(0.7))

            ZStack {
                // Outer glow ring
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.warningOrange.opacity(0.3),
                                .clear
                            ],
                            center: .center,
                            startRadius: 80,
                            endRadius: 140
                        )
                    )
                    .frame(width: 280, height: 280)
                    .pulse(from: 0.9, to: 1.1, duration: 1.5)

                // Background ring
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 14)
                    .frame(width: 200, height: 200)

                // Animated progress ring
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.waitTime) / CGFloat(AppConstants.accountabilityWaitTime))
                    .stroke(
                        AngularGradient(
                            colors: [
                                Color.warningOrange,
                                Color.electricBlue,
                                Color.warningOrange
                            ],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: Color.warningOrange.opacity(0.8), radius: 15)

                // Timer display
                VStack(spacing: 4) {
                    Text("\(viewModel.waitTime)")
                        .font(.system(size: 72, weight: .black, design: .rounded))
                        .gradientForeground(colors: [.warningOrange, .electricBlue])
                        .neonGlow(color: .warningOrange, radius: 12)

                    Text("seconds")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            Text("Dismiss available soon")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))

            if viewModel.dismissalsToday > 0 {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 14))
                    Text("Dismissals today: \(viewModel.dismissalsToday)/\(AppConstants.maxDismissalsPerDay)")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.warningOrange)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.warningOrange.opacity(0.15))
                        .overlay(
                            Capsule()
                                .stroke(Color.warningOrange.opacity(0.5), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .glassmorphicCard(cornerRadius: 24, shadowRadius: 25)
        .padding(.horizontal)
    }

    // MARK: - Lockdown Mode Challenge

    private var lockdownChallengeView: some View {
        VStack(spacing: 28) {
            // Challenge header
            VStack(spacing: 12) {
                Text("🔒 LOCKDOWN MODE")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .tracking(3)
                    .foregroundColor(.alertRed)

                Text("Complete a task to continue")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
            }

            // Math challenge card
            VStack(spacing: 20) {
                Text("🧮")
                    .font(.system(size: 50))

                Text("SOLVE THIS")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.6))

                Text(viewModel.lockdownChallenge)
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .gradientForeground(colors: [.electricBlue, .neonPurple])
                    .neonGlow(color: .electricBlue, radius: 10)

                TextField("", text: $viewModel.userAnswer)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.electricBlue.opacity(0.5), lineWidth: 2)
                            )
                    )
                    .frame(width: 180)
                    .onChange(of: viewModel.userAnswer) { _, _ in
                        viewModel.checkAnswer()
                    }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 25)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.alertRed.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.alertRed.opacity(0.3), lineWidth: 2)
                    )
            )

            // OR divider
            HStack {
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                Text("OR")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.horizontal, 12)
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
            }

            // Wait timer option
            VStack(spacing: 12) {
                Button(action: {
                    HapticsManager.shared.mediumImpact()
                    viewModel.startWaitTimer()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 20, weight: .bold))

                        Text(viewModel.waitTime > 0 ? "Waiting... \(viewModel.waitTime)s" : "Wait 60 seconds instead")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(viewModel.waitTime > 0 ? .warningOrange : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(viewModel.waitTime > 0 ? 0.15 : 0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        viewModel.waitTime > 0 ? Color.warningOrange : Color.white.opacity(0.3),
                                        lineWidth: 2
                                    )
                            )
                    )
                }
                .disabled(viewModel.waitTime > 0)

                if viewModel.waitTime > 0 {
                    // Progress bar for wait time
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 8)

                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [.warningOrange, .electricBlue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geometry.size.width * (1.0 - CGFloat(viewModel.waitTime) / 60.0),
                                    height: 8
                                )
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .glassmorphicCard(cornerRadius: 24, shadowRadius: 25)
        .padding(.horizontal)
    }

    // MARK: - Optional Note Field

    private var optionalNoteField: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "note.text")
                    .font(.system(size: 16, weight: .semibold))
                Text("OPTIONAL NOTE")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .tracking(2)
            }
            .foregroundColor(.white.opacity(0.6))

            TextField("What did you see or learn?", text: $viewModel.note, axis: .vertical)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(3...5)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.electricBlue.opacity(0.3), lineWidth: 1)
                        )
                )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .glassmorphicCard(cornerRadius: 20, shadowRadius: 20)
        .padding(.horizontal)
    }

    // MARK: - Bottom Actions

    private var bottomActions: some View {
        VStack(spacing: 14) {
            // Primary dismiss button
            Button(action: {
                HapticsManager.shared.success()
                viewModel.dismiss()
                dismiss()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: viewModel.canDismiss ? "checkmark.circle.fill" : "lock.fill")
                        .font(.system(size: 20, weight: .bold))

                    Text(viewModel.canDismiss ? "Continue" : "Complete Task First")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .tracking(1)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    ZStack {
                        if viewModel.canDismiss {
                            // Gradient background with shimmer
                            LinearGradient(
                                colors: [Color.electricBlue, Color.neonPurple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )

                            LinearGradient(
                                colors: [
                                    .clear,
                                    .white.opacity(0.3),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .shimmer()
                        } else {
                            // Disabled state
                            LinearGradient(
                                colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        }
                    }
                )
                .cornerRadius(18)
                .neonGlow(color: viewModel.canDismiss ? .electricBlue : .clear, radius: viewModel.canDismiss ? 15 : 0)
            }
            .disabled(!viewModel.canDismiss)

            // Secondary share button
            Button(action: {
                HapticsManager.shared.lightTap()
                // TODO: Phase 3 - Share functionality
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .semibold))

                    Text("Share this roast")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.electricBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.electricBlue.opacity(0.5), lineWidth: 2)
                        )
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
