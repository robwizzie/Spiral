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
                // Clean, simple background
                CleanBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // App title - clean and modern
                        Text("SPIRAL")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .tracking(2)
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        // Spiral animation - stunning centerpiece
                        SpiralAnimation(state: .idle, size: 160)
                            .padding(.vertical, 20)

                        // Stats cards
                        if let stats = statsViewModel {
                            // Doom Score Card - hero element
                            VStack(spacing: 20) {
                                Text("TODAY'S DOOM SCORE")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .tracking(2)
                                    .foregroundColor(.secondary)

                                // Clean score display
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("\(stats.doomScore)")
                                        .font(.system(size: 64, weight: .bold, design: .rounded))
                                        .foregroundColor(doomScoreColor(stats.doomScore))

                                    Text("/10")
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundColor(.secondary)
                                }

                                // Simple progress indicator
                                ProgressView(value: Double(stats.doomScore), total: 10)
                                    .tint(doomScoreColor(stats.doomScore))
                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                                    .padding(.horizontal, 30)

                                // Score message
                                Text(stats.doomScoreMessage)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)

                                // Percentile badge
                                HStack(spacing: 6) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.system(size: 13, weight: .medium))
                                    Text(stats.percentileMessage)
                                        .font(.system(size: 14, weight: .medium))
                                }
                                .foregroundColor(.electricBlue)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.electricBlue.opacity(0.15))
                                )
                            }
                            .modernCard(padding: 24)
                            .padding(.horizontal)

                            // Streak Card - clean and simple
                            HStack(spacing: 16) {
                                Text("🔥")
                                    .font(.system(size: 32))

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                                        Text("\(stats.currentStreak)")
                                            .font(.system(size: 32, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)

                                        Text("days")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }

                                    Text("Current Streak")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("\(stats.longestStreak)")
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        .foregroundColor(.electricBlue)

                                    Text("best")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .modernCard()
                            .padding(.horizontal)

                            // Quick Stats
                            VStack(spacing: 16) {
                                statRow(
                                    icon: "hand.raised.fill",
                                    label: "Interventions Today",
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
                                    label: "Your Rank",
                                    value: "Top \(stats.percentile)%",
                                    color: .neonPurple
                                )
                            }
                            .modernCard()
                            .padding(.horizontal)

                            // View Full Stats Button
                            NavigationLink(destination: StatsView(viewModel: stats)) {
                                HStack(spacing: 10) {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.system(size: 16, weight: .semibold))

                                    Text("View Full Stats")
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
                            .padding(.horizontal)
                        }

                        // Dev test button
                        Button("Test Intervention") {
                            showingIntervention = true
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.electricBlue)
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
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.5))
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
