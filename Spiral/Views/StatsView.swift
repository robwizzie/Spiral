//
//  StatsView.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI
import SwiftData
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
        ScrollView {
            VStack(spacing: 20) {
                // Time range picker
                Picker("Range", selection: $selectedRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
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
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // TODO: Share functionality
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.electricBlue)
                }
            }
        }
    }

    // MARK: - Time Saved Card

    private var timeSavedCard: some View {
        VStack(spacing: 12) {
            Text("Time Saved This Week")
                .font(.headline)
                .foregroundColor(.white)

            Text(viewModel.timeSavedFormatted)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.successGreen)

            Text("That's like...")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))

            VStack(alignment: .leading, spacing: 4) {
                ForEach(viewModel.timeSavedComparisons, id: \.self) { comparison in
                    Text(comparison)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.deepPurple)
        .cornerRadius(16)
    }

    // MARK: - Doom Score Trend Card

    private var doomScoreTrendCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Doom Score Trend")
                .font(.headline)
                .foregroundColor(.white)

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
                    .lineStyle(StrokeStyle(lineWidth: 3))

                    AreaMark(
                        x: .value("Day", score.date, unit: .day),
                        y: .value("Score", score.score)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.electricBlue.opacity(0.3), .neonPurple.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 200)
                .chartYScale(domain: 0...10)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.weekday(.narrow))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }

                HStack {
                    Image(systemName: viewModel.averageDoomScore < 5 ? "arrow.down.right" : "arrow.up.right")
                        .foregroundColor(viewModel.averageDoomScore < 5 ? .successGreen : .warningOrange)
                    Text("Average: \(String(format: "%.1f", viewModel.averageDoomScore))/10")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text(viewModel.averageDoomScore < 5 ? "improving! 📈" : "room to improve 📊")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            } else {
                Text("No data yet. Keep using Spiral!")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color.deepPurple)
        .cornerRadius(16)
    }

    // MARK: - Intervention Stats Card

    private var interventionStatsCard: some View {
        HStack(spacing: 16) {
            // Interventions
            VStack(spacing: 8) {
                Text("Interventions")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                Text("\(viewModel.interventionsToday)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.electricBlue)

                HStack(spacing: 4) {
                    Image(systemName: "arrow.down")
                        .font(.caption2)
                        .foregroundColor(.successGreen)
                    Text("30% vs last")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.deepPurple)
            .cornerRadius(12)

            // Successful Breaks
            VStack(spacing: 8) {
                Text("Successful Breaks")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                Text("\(max(viewModel.interventionsToday - 2, 0))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.successGreen)

                HStack(spacing: 4) {
                    Image(systemName: "arrow.up")
                        .font(.caption2)
                        .foregroundColor(.successGreen)
                    Text("12% vs last")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.deepPurple)
            .cornerRadius(12)
        }
    }

    // MARK: - App Breakdown Card

    private var appBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Most Doom Scrolled Apps")
                .font(.headline)
                .foregroundColor(.white)

            ForEach(viewModel.topApps.prefix(3)) { app in
                HStack {
                    Text(app.appName)
                        .font(.system(size: 15))
                        .foregroundColor(.white)

                    Spacer()

                    Text(app.durationFormatted)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.electricBlue)
                }

                ProgressView(value: app.percentage)
                    .tint(.electricBlue)
            }
        }
        .padding()
        .background(Color.deepPurple)
        .cornerRadius(16)
    }

    // MARK: - Percentile Card

    private var percentileCard: some View {
        VStack(spacing: 12) {
            Text("You're in the top \(viewModel.percentile)% 🎯")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Text("\(100 - viewModel.percentile)% of users doom scroll more")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))

            Text("Keep it up!")
                .font(.caption)
                .foregroundColor(.successGreen)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.deepPurple)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationStack {
        StatsView(viewModel: StatsViewModel(modelContext: ModelContext(try! ModelContainer(for: UserStats.self))))
    }
}
