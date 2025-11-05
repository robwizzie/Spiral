//
//  AchievementPopup.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI

struct AchievementPopup: View {
    let achievement: Achievement
    let onShare: () -> Void
    let onDismiss: () -> Void

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Blurred background with animated gradient
            ZStack {
                AnimatedGradientBackground(speed: 15.0)
                    .blur(radius: 20)
                Color.black.opacity(0.6)
            }
            .ignoresSafeArea()
            .onTapGesture {
                dismiss()
            }

            // Popup card with enhanced visuals
            VStack(spacing: 24) {
                // Massive trophy icon with glow and pulse
                ZStack {
                    // Outer glow ring
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    (achievement.isPositive ? Color.successGreen : Color.warningOrange).opacity(0.4),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 50,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                        .pulse(from: 0.9, to: 1.1, duration: 2)

                    Text("🏆")
                        .font(.system(size: 90))
                        .shadow(color: (achievement.isPositive ? Color.successGreen : Color.warningOrange).opacity(0.8), radius: 30)
                }

                // Achievement unlocked text with gradient and glow
                Text("ACHIEVEMENT UNLOCKED")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .tracking(4)
                    .gradientForeground(colors: [
                        achievement.isPositive ? .successGreen : .warningOrange,
                        .electricBlue
                    ])
                    .neonGlow(color: achievement.isPositive ? .successGreen : .warningOrange, radius: 12)

                // Achievement name with emoji - BIGGER
                VStack(spacing: 10) {
                    Text(achievement.emoji)
                        .font(.system(size: 56))

                    Text(achievement.displayName)
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                // Description with better styling
                Text(achievement.description)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 10)

                // Divider
                Divider()
                    .background(Color.white.opacity(0.3))
                    .padding(.horizontal, 20)

                // Rarity/Type indicator with badge
                Text(achievement.isPositive ? "You're crushing it! 💪" : "Uhh... congrats? 😅")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill((achievement.isPositive ? Color.successGreen : Color.warningOrange).opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(achievement.isPositive ? Color.successGreen : Color.warningOrange, lineWidth: 2)
                            )
                    )

                // Action buttons with enhanced styling
                VStack(spacing: 12) {
                    // Share button with shimmer
                    Button(action: {
                        HapticsManager.shared.mediumImpact()
                        onShare()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18, weight: .bold))
                            Text("Share Achievement")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .tracking(1)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            ZStack {
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
                            }
                        )
                        .cornerRadius(16)
                        .neonGlow(color: .electricBlue, radius: 12)
                    }

                    // Dismiss button
                    Button(action: {
                        HapticsManager.shared.lightTap()
                        dismiss()
                    }) {
                        Text("Cool, thanks")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.electricBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.electricBlue.opacity(0.5), lineWidth: 2)
                                    )
                            )
                    }
                }
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 30)
            .glassmorphicCard(cornerRadius: 28, shadowRadius: 40)
            .padding(.horizontal, 35)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }

            // Haptic feedback and sound
            HapticsManager.shared.playAchievementPattern()
            SoundManager.shared.play(.achievement)
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            scale = 0.9
            opacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onDismiss()
        }
    }
}

#Preview {
    AchievementPopup(
        achievement: .weekWarrior,
        onShare: {},
        onDismiss: {}
    )
}
