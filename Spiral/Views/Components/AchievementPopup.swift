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
            // Blurred background
            Color.black.opacity(0.75)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            // Popup card
            VStack(spacing: 20) {
                // Trophy icon with subtle glow
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    (achievement.isPositive ? Color.successGreen : Color.warningOrange).opacity(0.2),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 30,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .subtlePulse(duration: 2.0)

                    Text("🏆")
                        .font(.system(size: 64))
                }

                // Achievement unlocked text
                Text("ACHIEVEMENT UNLOCKED")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .tracking(3)
                    .foregroundColor(achievement.isPositive ? .successGreen : .warningOrange)

                // Achievement name with emoji
                VStack(spacing: 8) {
                    Text(achievement.emoji)
                        .font(.system(size: 40))

                    Text(achievement.displayName)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }

                // Description
                Text(achievement.description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, 10)

                // Divider
                Divider()
                    .background(Color.white.opacity(0.2))
                    .padding(.horizontal, 20)

                // Rarity/Type indicator
                Text(achievement.isPositive ? "You're crushing it! 💪" : "Uhh... congrats? 😅")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill((achievement.isPositive ? Color.successGreen : Color.warningOrange).opacity(0.15))
                    )

                // Action buttons
                VStack(spacing: 10) {
                    Button(action: {
                        HapticsManager.shared.mediumImpact()
                        onShare()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 15, weight: .semibold))
                            Text("Share Achievement")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [.electricBlue, .neonPurple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }

                    Button(action: {
                        HapticsManager.shared.lightTap()
                        dismiss()
                    }) {
                        Text("Cool, thanks")
                            .font(.system(size: 15, weight: .medium))
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
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemGray6).opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 30)
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
