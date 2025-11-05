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
            ScrollView {
                ZStack {
                    // Background
                    Color.black
                        .ignoresSafeArea()

                    VStack(spacing: 30) {
                        // App title
                        Text("SPIRAL")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color.electricBlue)

                        // Spiral animation - breathing state
                        SpiralAnimation(state: .idle, size: 150)

                        // Doom Score Card
                        if let stats = statsViewModel {
                            VStack(spacing: 12) {
                                Text("Today's Doom Score")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("\(stats.doomScore)/10")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(doomScoreColor(stats.doomScore))

                                ProgressView(value: Double(stats.doomScore), total: 10)
                                    .tint(doomScoreColor(stats.doomScore))
                                    .scaleEffect(y: 2)

                                Text(stats.doomScoreMessage)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.top, 8)

                                Text(stats.percentileMessage)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(20)
                            .background(Color.deepPurple)
                            .cornerRadius(16)

                            // Streak Card
                            VStack(spacing: 8) {
                                HStack {
                                    Text("🔥")
                                        .font(.system(size: 32))
                                    Text("Current Streak: \(stats.currentStreak) days")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }

                                Text("Longest Streak: \(stats.longestStreak) days")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding()
                            .background(Color.deepPurple)
                            .cornerRadius(16)

                            // Quick Stats
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Quick Stats")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                HStack {
                                    Image(systemName: "hand.raised.fill")
                                        .foregroundColor(.electricBlue)
                                    Text("Interventions today: \(stats.interventionsToday)")
                                        .foregroundColor(.white)
                                }

                                HStack {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(.electricBlue)
                                    Text("Time saved: \(stats.timeSavedFormatted)")
                                        .foregroundColor(.white)
                                }

                                HStack {
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundColor(.electricBlue)
                                    Text("Top \(stats.percentile)% of users 🎯")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color.deepPurple)
                            .cornerRadius(16)

                            // View Full Stats Button
                            NavigationLink(destination: StatsView(viewModel: stats)) {
                                Text("View Full Stats")
                                    .font(.system(size: 17, weight: .semibold))
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
                        }

                        // Test intervention button (development only)
                        Button("Test Intervention View") {
                            showingIntervention = true
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        .opacity(0.5)
                    }
                    .padding()
                }
            }
            .background(Color.black)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Text("Settings (Coming Soon)")) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color.electricBlue)
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
