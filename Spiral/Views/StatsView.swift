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
            CleanBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Time range picker
                    Picker("Range", selection: $selectedRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 8)

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
            }
        }
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // TODO: Share functionality
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.electricBlue)
                }
            }
        }
    }

    // MARK: - Time Saved Card

    private var timeSavedCard: some View {
        VStack(spacing: 16) {
            Text("TIME SAVED THIS WEEK")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .tracking(2)
                .foregroundColor(.secondary)

            // Large time display
            Text(viewModel.timeSavedFormatted)
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundColor(.successGreen)

            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.horizontal, 20)

            VStack(spacing: 8) {
                Text("That's like...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(viewModel.timeSavedComparisons, id: \.self) { comparison in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.successGreen)
                                .frame(width: 4, height: 4)

                            Text(comparison)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .modernCard(padding: 24)
        .padding(.horizontal)
    }

    // MARK: - Doom Score Trend Card

    private var doomScoreTrendCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DOOM SCORE TREND")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .tracking(2)
                .foregroundColor(.secondary)

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
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))

                    AreaMark(
                        x: .value("Day", score.date, unit: .day),
                        y: .value("Score", score.score)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                .electricBlue.opacity(0.3),
                                .neonPurple.opacity(0.1),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 180)
                .chartYScale(domain: 0...10)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(Color.white.opacity(0.1))
                        AxisValueLabel(format: .dateTime.weekday(.narrow))
                            .foregroundStyle(Color.secondary)
                            .font(.system(size: 11))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(Color.white.opacity(0.1))
                        AxisValueLabel()
                            .foregroundStyle(Color.secondary)
                            .font(.system(size: 11))
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.2))

                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: viewModel.averageDoomScore < 5 ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(viewModel.averageDoomScore < 5 ? .successGreen : .warningOrange)

                        Text("Avg: \(String(format: "%.1f", viewModel.averageDoomScore))/10")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text(viewModel.averageDoomScore < 5 ? "Improving" : "Room to grow")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(viewModel.averageDoomScore < 5 ? .successGreen : .warningOrange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill((viewModel.averageDoomScore < 5 ? Color.successGreen : Color.warningOrange).opacity(0.15))
                        )
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.secondary)

                    Text("No data yet")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)

                    Text("Keep using Spiral to see your trends!")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(height: 180)
                .frame(maxWidth: .infinity)
            }
        }
        .modernCard(padding: 20)
        .padding(.horizontal)
    }

    // MARK: - Intervention Stats Card

    private var interventionStatsCard: some View {
        HStack(spacing: 12) {
            // Interventions
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.electricBlue.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.electricBlue)
                }

                Text("\(viewModel.interventionsToday)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Interventions")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.successGreen)
                    Text("30%")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .modernCard(padding: 16)

            // Successful Breaks
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.successGreen.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.successGreen)
                }

                Text("\(max(viewModel.interventionsToday - 2, 0))")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Successful")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.successGreen)
                    Text("12%")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .modernCard(padding: 16)
        }
        .padding(.horizontal)
    }

    // MARK: - App Breakdown Card

    private var appBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("TOP DOOM SCROLL APPS")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .tracking(2)
                .foregroundColor(.secondary)

            VStack(spacing: 14) {
                ForEach(Array(viewModel.topApps.prefix(3).enumerated()), id: \.element.id) { index, app in
                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            // Rank
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 28, height: 28)

                                Text("#\(index + 1)")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(app.appName)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)

                                Text("\(Int(app.percentage * 100))% of time")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Text(app.durationFormatted)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(.electricBlue)
                        }

                        ProgressView(value: app.percentage)
                            .tint(.electricBlue)
                    }

                    if index < 2 {
                        Divider()
                            .background(Color.white.opacity(0.1))
                    }
                }
            }
        }
        .modernCard(padding: 20)
        .padding(.horizontal)
    }

    // MARK: - Percentile Card

    private var percentileCard: some View {
        VStack(spacing: 16) {
            Text("🎯")
                .font(.system(size: 44))

            VStack(spacing: 6) {
                Text("TOP")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .tracking(2)
                    .foregroundColor(.secondary)

                Text("\(viewModel.percentile)%")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.successGreen)
            }

            Text("\(100 - viewModel.percentile)% of users doom scroll more")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Text("Keep it up!")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.successGreen)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.successGreen.opacity(0.15))
                )
        }
        .modernCard(padding: 24)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        StatsView(viewModel: StatsViewModel(modelContext: ModelContext(try! ModelContainer(for: UserStats.self))))
    }
}
