//
//  StatsView.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI
import Charts

struct StatsView: View {
    @ObservedObject var viewModel: StatsViewModel
    @State private var selectedRange: TimeRange = .week

    enum TimeRange: String, CaseIterable {
        case week = "7D"
        case month = "30D"
        case quarter = "3M"

        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .quarter: return 90
            }
        }
    }

    var body: some View {
        ZStack {
            // Animated gradient background
            AnimatedGradientBackground()

            // Floating particles
            ParticleField(count: 15)
                .opacity(0.3)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // Header with title
                    VStack(spacing: 12) {
                        Text("YOUR STATS")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .tracking(3)
                            .gradientForeground(colors: [.electricBlue, .neonPurple, .electricBlue])
                            .neonGlow(color: .electricBlue, radius: 15)

                        Text("Track your progress")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 20)

                    // Time range picker with custom styling
                    HStack(spacing: 12) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Button(action: {
                                HapticsManager.shared.lightTap()
                                selectedRange = range
                            }) {
                                Text(range.rawValue)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(selectedRange == range ? .white : .white.opacity(0.6))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        ZStack {
                                            if selectedRange == range {
                                                LinearGradient(
                                                    colors: [.electricBlue, .neonPurple],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                                .cornerRadius(12)
                                                .neonGlow(color: .electricBlue, radius: 8)
                                            } else {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white.opacity(0.08))
                                            }
                                        }
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .glassmorphicCard(cornerRadius: 16, shadowRadius: 15)
                    .padding(.horizontal)

                    // Time saved card
                    timeSavedCard

                    // Doom score trend chart
                    doomScoreTrendCard

                    // Intervention stats
                    interventionStatsCard

                    // App breakdown
                    if !viewModel.topApps.isEmpty {
                        appBreakdownCard
                    }

                    // Percentile card
                    percentileCard

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 5)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    HapticsManager.shared.lightTap()
                    // TODO: Share functionality
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.electricBlue)
                        .neonGlow(color: .electricBlue, radius: 8)
                }
            }
        }
    }

    // MARK: - Time Saved Card

    private var timeSavedCard: some View {
        VStack(spacing: 20) {
            Text("⏰ TIME SAVED THIS WEEK")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .tracking(3)
                .foregroundColor(.white.opacity(0.7))

            // Massive time display with glow
            ZStack {
                Text(viewModel.timeSavedFormatted)
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundColor(.successGreen)
                    .blur(radius: 30)
                    .opacity(0.6)

                Text(viewModel.timeSavedFormatted)
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .gradientForeground(colors: [.successGreen, .electricBlue])
                    .neonGlow(color: .successGreen, radius: 15)
            }

            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.horizontal, 20)

            VStack(spacing: 12) {
                Text("That's like...")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.timeSavedComparisons, id: \.self) { comparison in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color.successGreen)
                                .frame(width: 6, height: 6)

                            Text(comparison)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 25)
        .glassmorphicCard(cornerRadius: 24, shadowRadius: 30)
        .padding(.horizontal)
    }

    // MARK: - Doom Score Trend Card

    private var doomScoreTrendCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("📊 DOOM SCORE TREND")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .tracking(3)
                .foregroundColor(.white.opacity(0.7))

            if !viewModel.dailyScores.isEmpty {
                Chart(viewModel.dailyScores) { score in
                    LineMark(
                        x: .value("Day", score.date, unit: .day),
                        y: .value("Score", score.score)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.electricBlue, .neonPurple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round))
                    .symbol {
                        Circle()
                            .fill(Color.electricBlue)
                            .frame(width: 8, height: 8)
                            .shadow(color: .electricBlue.opacity(0.8), radius: 4)
                    }

                    AreaMark(
                        x: .value("Day", score.date, unit: .day),
                        y: .value("Score", score.score)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                .electricBlue.opacity(0.5),
                                .neonPurple.opacity(0.3),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 220)
                .chartYScale(domain: 0...10)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [4]))
                            .foregroundStyle(Color.white.opacity(0.1))
                        AxisTick()
                            .foregroundStyle(Color.white.opacity(0.3))
                        AxisValueLabel(format: .dateTime.weekday(.narrow))
                            .foregroundStyle(Color.white.opacity(0.6))
                            .font(.system(size: 12, weight: .semibold))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [4]))
                            .foregroundStyle(Color.white.opacity(0.1))
                        AxisTick()
                            .foregroundStyle(Color.white.opacity(0.3))
                        AxisValueLabel()
                            .foregroundStyle(Color.white.opacity(0.6))
                            .font(.system(size: 12, weight: .semibold))
                    }
                }
                .padding(.top, 8)

                Divider()
                    .background(Color.white.opacity(0.2))

                HStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.averageDoomScore < 5 ? "arrow.down.right.circle.fill" : "arrow.up.right.circle.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(viewModel.averageDoomScore < 5 ? .successGreen : .warningOrange)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Average")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            Text("\(String(format: "%.1f", viewModel.averageDoomScore))/10")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }

                    Spacer()

                    Text(viewModel.averageDoomScore < 5 ? "📈 Improving!" : "📊 Room to grow")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(viewModel.averageDoomScore < 5 ? .successGreen : .warningOrange)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill((viewModel.averageDoomScore < 5 ? Color.successGreen : Color.warningOrange).opacity(0.15))
                        )
                }
                .padding(.top, 4)
            } else {
                VStack(spacing: 12) {
                    Text("📭")
                        .font(.system(size: 50))

                    Text("No data yet")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))

                    Text("Keep using Spiral to see your trends!")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 25)
        .glassmorphicCard(cornerRadius: 24, shadowRadius: 30)
        .padding(.horizontal)
    }

    // MARK: - Intervention Stats Card

    private var interventionStatsCard: some View {
        HStack(spacing: 14) {
            // Interventions
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.electricBlue.opacity(0.2))
                        .frame(width: 60, height: 60)

                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.electricBlue)
                }

                Text("\(viewModel.interventionsToday)")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .gradientForeground(colors: [.electricBlue, .neonPurple])

                Text("Interventions")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))

                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.successGreen)
                    Text("30% vs last")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .glassmorphicCard(cornerRadius: 18, shadowRadius: 20)

            // Successful Breaks
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.successGreen.opacity(0.2))
                        .frame(width: 60, height: 60)

                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.successGreen)
                }

                Text("\(max(viewModel.interventionsToday - 2, 0))")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .gradientForeground(colors: [.successGreen, .electricBlue])

                Text("Successful")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))

                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.successGreen)
                    Text("12% vs last")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .glassmorphicCard(cornerRadius: 18, shadowRadius: 20)
        }
        .padding(.horizontal)
    }

    // MARK: - App Breakdown Card

    private var appBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("📱 TOP DOOM SCROLL APPS")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .tracking(3)
                .foregroundColor(.white.opacity(0.7))

            VStack(spacing: 16) {
                ForEach(Array(viewModel.topApps.prefix(3).enumerated()), id: \.element.id) { index, app in
                    VStack(spacing: 10) {
                        HStack(spacing: 12) {
                            // Rank badge
                            ZStack {
                                Circle()
                                    .fill(
                                        index == 0 ? Color.warningOrange.opacity(0.2) :
                                        index == 1 ? Color.electricBlue.opacity(0.2) :
                                        Color.neonPurple.opacity(0.2)
                                    )
                                    .frame(width: 36, height: 36)

                                Text("#\(index + 1)")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(
                                        index == 0 ? .warningOrange :
                                        index == 1 ? .electricBlue :
                                        .neonPurple
                                    )
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(app.appName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)

                                Text("\(Int(app.percentage * 100))% of total time")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }

                            Spacer()

                            Text(app.durationFormatted)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.electricBlue)
                        }

                        // Enhanced progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 6)

                                RoundedRectangle(cornerRadius: 6)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                index == 0 ? .warningOrange : .electricBlue,
                                                .neonPurple
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * app.percentage, height: 6)
                                    .shadow(color: (index == 0 ? Color.warningOrange : Color.electricBlue).opacity(0.6), radius: 4)
                            }
                        }
                        .frame(height: 6)
                    }

                    if index < 2 {
                        Divider()
                            .background(Color.white.opacity(0.1))
                    }
                }
            }
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 25)
        .glassmorphicCard(cornerRadius: 24, shadowRadius: 30)
        .padding(.horizontal)
    }

    // MARK: - Percentile Card

    private var percentileCard: some View {
        VStack(spacing: 20) {
            Text("🎯")
                .font(.system(size: 60))

            VStack(spacing: 8) {
                Text("TOP")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.7))

                ZStack {
                    Text("\(viewModel.percentile)%")
                        .font(.system(size: 68, weight: .black, design: .rounded))
                        .foregroundColor(.successGreen)
                        .blur(radius: 25)
                        .opacity(0.6)

                    Text("\(viewModel.percentile)%")
                        .font(.system(size: 68, weight: .black, design: .rounded))
                        .gradientForeground(colors: [.successGreen, .electricBlue])
                        .neonGlow(color: .successGreen, radius: 12)
                }
            }

            VStack(spacing: 8) {
                Text("\(100 - viewModel.percentile)% of users doom scroll more")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                Text("Keep crushing it! 💪")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.successGreen)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.successGreen.opacity(0.15))
                            .overlay(
                                Capsule()
                                    .stroke(Color.successGreen.opacity(0.5), lineWidth: 1)
                            )
                    )
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 25)
        .glassmorphicCard(cornerRadius: 24, shadowRadius: 30)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        StatsView(viewModel: StatsViewModel(modelContext: ModelContext(try! ModelContainer(for: UserStats.self))))
    }
}
