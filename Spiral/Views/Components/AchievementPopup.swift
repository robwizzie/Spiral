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
            // Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            // Popup card
            VStack(spacing: 20) {
                // Trophy icon
                Text("🏆")
                    .font(.system(size: 60))

                // Achievement unlocked text
                Text("ACHIEVEMENT UNLOCKED")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(2)

                // Achievement name with emoji
                HStack(spacing: 8) {
                    Text(achievement.emoji)
                        .font(.system(size: 32))
                    Text(achievement.displayName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

                // Description
                Text(achievement.description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                // Divider
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                    .padding(.horizontal)

                // Rarity/Type indicator
                Text(achievement.isPositive ? "You're crushing it! 💪" : "Uhh... congrats? 😅")
                    .font(.caption)
                    .foregroundColor(achievement.isPositive ? .successGreen : .warningOrange)

                // Action buttons
                HStack(spacing: 12) {
                    Button(action: onShare) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.electricBlue, Color.neonPurple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }

                    Button(action: dismiss) {
                        Text("Cool, thanks")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.electricBlue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.electricBlue, lineWidth: 2)
                            )
                            .cornerRadius(12)
                    }
                }
            }
            .padding(30)
            .background(Color.deepPurple)
            .cornerRadius(20)
            .shadow(color: achievement.isPositive ? Color.successGreen.opacity(0.3) : Color.warningOrange.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 40)
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

            // Confetti effect would go here in full implementation
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
