//
//  HomeView.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var screenTimeMonitor = ScreenTimeMonitor()
    @State private var showingIntervention = false
    @State private var statsViewModel: StatsViewModel?

    var body: some View {
        NavigationStack {
            ZStack {
                // Animated gradient background
                AnimatedGradientBackground()

                // Floating particles for depth
                ParticleField(count: 12)
                    .opacity(0.4)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 35) {
                        // App title with gradient and glow
                        Text("SPIRAL")
                            .font(.system(size: 52, weight: .black, design: .rounded))
                            .tracking(4)
                            .gradientForeground(colors: [.electricBlue, .neonPurple, .electricBlue])
                            .neonGlow(color: .electricBlue, radius: 20)
                            .padding(.top, 40)

                        // Spiral animation with dramatic glow
                        ZStack {
                            // Outer glow ring
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.electricBlue.opacity(0.4),
                                            Color.neonPurple.opacity(0.2),
                                            .clear
                                        ],
                                        center: .center,
                                        startRadius: 90,
                                        endRadius: 180
                                    )
                                )
                                .frame(width: 360, height: 360)
                                .pulse(from: 0.9, to: 1.1, duration: 3)

                            // Inner glow
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.electricBlue.opacity(0.6),
                                            .clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                                .frame(width: 200, height: 200)
                                .blur(radius: 20)

                            SpiralAnimation(state: .idle, size: 180)
                                .neonGlow(color: .electricBlue, radius: 25)
                        }
                        .padding(.bottom, 10)

                        // Stats cards
                        if let stats = statsViewModel {
                            // Doom Score Card - DRAMATIC
                            VStack(spacing: 16) {
                                Text("TODAY'S DOOM SCORE")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .tracking(3)
                                    .foregroundColor(.white.opacity(0.7))

                                // Massive score display
                                ZStack {
                                    // Glow behind score
                                    Text("\(stats.doomScore)")
                                        .font(.system(size: 120, weight: .black, design: .rounded))
                                        .foregroundColor(doomScoreColor(stats.doomScore))
                                        .blur(radius: 40)
                                        .opacity(0.6)

                                    Text("\(stats.doomScore)")
                                        .font(.system(size: 120, weight: .black, design: .rounded))
                                        .gradientForeground(colors: [
                                            doomScoreColor(stats.doomScore),
                                            doomScoreColor(stats.doomScore).opacity(0.7)
                                        ])
                                        .neonGlow(color: doomScoreColor(stats.doomScore), radius: 15)
                                }

                                Text("/10")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                                    .offset(y: -20)

                                // Custom progress ring
                                ZStack {
                                    // Background ring
                                    Circle()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 12)
                                        .frame(width: 200, height: 200)

                                    // Progress ring with gradient
                                    Circle()
                                        .trim(from: 0, to: CGFloat(stats.doomScore) / 10.0)
                                        .stroke(
                                            AngularGradient(
                                                colors: [
                                                    doomScoreColor(stats.doomScore),
                                                    doomScoreColor(stats.doomScore).opacity(0.5),
                                                    doomScoreColor(stats.doomScore)
                                                ],
                                                center: .center
                                            ),
                                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                        )
                                        .frame(width: 200, height: 200)
                                        .rotationEffect(.degrees(-90))
                                        .shadow(color: doomScoreColor(stats.doomScore).opacity(0.8), radius: 10)
                                }
                                .padding(.vertical, 8)

                                // Score message
                                Text(stats.doomScoreMessage)
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)

                                // Percentile badge
                                HStack(spacing: 8) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text(stats.percentileMessage)
                                        .font(.system(size: 15, weight: .medium))
                                }
                                .foregroundColor(.electricBlue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(Color.electricBlue.opacity(0.15))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.electricBlue.opacity(0.5), lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.vertical, 30)
                            .padding(.horizontal, 25)
                            .glassmorphicCard(cornerRadius: 24, shadowRadius: 30)
                            .padding(.horizontal)

                            // Streak Card - BOLD
                            HStack(spacing: 20) {
                                // Flame icon with pulse
                                ZStack {
                                    Circle()
                                        .fill(Color.warningOrange.opacity(0.2))
                                        .frame(width: 70, height: 70)
                                        .pulse(from: 1.0, to: 1.1, duration: 1.5)

                                    Text("🔥")
                                        .font(.system(size: 40))
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                                        Text("\(stats.currentStreak)")
                                            .font(.system(size: 48, weight: .black, design: .rounded))
                                            .gradientForeground(colors: [.warningOrange, .alertRed])

                                        Text("days")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(.white.opacity(0.6))
                                    }

                                    Text("Current Streak")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.7))

                                    Text("Best: \(stats.longestStreak) days")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.electricBlue)
                                }

                                Spacer()
                            }
                            .padding(20)
                            .glassmorphicCard(cornerRadius: 20, shadowRadius: 20)
                            .padding(.horizontal)

                            // Quick Stats Grid
                            VStack(spacing: 16) {
                                Text("QUICK STATS")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .tracking(3)
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                VStack(spacing: 12) {
                                    statRow(
                                        icon: "hand.raised.fill",
                                        label: "Interventions",
                                        value: "\(stats.interventionsToday)",
                                        color: .electricBlue
                                    )

                                    Divider()
                                        .background(Color.white.opacity(0.1))

                                    statRow(
                                        icon: "clock.fill",
                                        label: "Time Saved",
                                        value: stats.timeSavedFormatted,
                                        color: .successGreen
                                    )

                                    Divider()
                                        .background(Color.white.opacity(0.1))

                                    statRow(
                                        icon: "trophy.fill",
                                        label: "Rank",
                                        value: "Top \(stats.percentile)%",
                                        color: .neonPurple
                                    )
                                }
                            }
                            .padding(20)
                            .glassmorphicCard(cornerRadius: 20, shadowRadius: 20)
                            .padding(.horizontal)

                            // View Full Stats Button - BOLD
                            NavigationLink(destination: StatsView(viewModel: stats)) {
                                HStack(spacing: 12) {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.system(size: 20, weight: .bold))

                                    Text("VIEW FULL STATS")
                                        .font(.system(size: 17, weight: .bold, design: .rounded))
                                        .tracking(1)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    ZStack {
                                        // Gradient background
                                        LinearGradient(
                                            colors: [Color.electricBlue, Color.neonPurple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )

                                        // Shimmer effect
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
                            .padding(.horizontal)
                        }

                        // Dev test button (subtle)
                        Button("Test Intervention") {
                            showingIntervention = true
                        }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 5)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.electricBlue)
                            .neonGlow(color: .electricBlue, radius: 8)
                    }
                }
            }
        }
        .sheet(isPresented: $showingIntervention) {
            InterventionView(
                viewModel: InterventionViewModel(
                    mode: .accountability,
                    duration: 1680,
                    interventionsToday: 2,
                    dismissalsToday: 1,
                    onDismiss: {
                        showingIntervention = false
                    }
                )
            )
        }
        .onAppear {
            if statsViewModel == nil {
                statsViewModel = StatsViewModel(modelContext: modelContext)
            }
            statsViewModel?.loadStats()
        }
    }

    // MARK: - Helper Views

    private func statRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: 16) {
            // Icon with background
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))

                Text(value)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))
        }
    }

    private func doomScoreColor(_ score: Int) -> Color {
        switch score {
        case 0...2:
            return .successGreen
        case 3...4:
            return .electricBlue
        case 5...6:
            return .warningOrange
        default:
            return .alertRed
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [AppSettings.self, ScrollSession.self, UserStats.self, UserAchievement.self], inMemory: true)
}
