//
//  StatsViewModel.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class StatsViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var doomScore: Int = 0
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var interventionsToday: Int = 0
    @Published var timeSaved: TimeInterval = 0
    @Published var percentile: Int = 50
    @Published var dailyScores: [DailyScore] = []
    @Published var topApps: [AppUsage] = []

    // MARK: - Private Properties

    private let modelContext: ModelContext

    // MARK: - Initialization

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadStats()
    }

    // MARK: - Load Stats

    func loadStats() {
        loadTodayStats()
        loadDailyScores()
        loadTopApps()
    }

    private func loadTodayStats() {
        let descriptor = FetchDescriptor<UserStats>(
            predicate: #Predicate { stats in
                stats.date >= Date().startOfDay && stats.date <= Date().endOfDay
            }
        )

        do {
            if let todayStats = try modelContext.fetch(descriptor).first {
                doomScore = todayStats.doomScore
                currentStreak = todayStats.currentStreak
                longestStreak = todayStats.longestStreak
                interventionsToday = todayStats.interventionCount
                timeSaved = todayStats.timeSaved
                percentile = todayStats.percentileRank
            } else {
                // Create today's stats if none exist
                createTodayStats()
            }
        } catch {
            print("❌ Failed to load today's stats: \(error)")
        }
    }

    private func createTodayStats() {
        let stats = UserStats(date: Date())
        modelContext.insert(stats)

        do {
            try modelContext.save()
            doomScore = 0
            currentStreak = 0
            longestStreak = 0
        } catch {
            print("❌ Failed to create today's stats: \(error)")
        }
    }

    private func loadDailyScores() {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        let descriptor = FetchDescriptor<UserStats>(
            predicate: #Predicate { stats in
                stats.date >= sevenDaysAgo
            },
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )

        do {
            let stats = try modelContext.fetch(descriptor)
            dailyScores = stats.map { DailyScore(date: $0.date, score: $0.doomScore) }
        } catch {
            print("❌ Failed to load daily scores: \(error)")
        }
    }

    private func loadTopApps() {
        let descriptor = FetchDescriptor<UserStats>(
            predicate: #Predicate { stats in
                stats.date >= Date().startOfDay && stats.date <= Date().endOfDay
            }
        )

        do {
            if let todayStats = try modelContext.fetch(descriptor).first {
                topApps = todayStats.appUsageBreakdown.map { key, value in
                    AppUsage(appName: key, duration: value)
                }
                .sorted { $0.duration > $1.duration }
                .prefix(3)
                .map { $0 }
            }
        } catch {
            print("❌ Failed to load app usage: \(error)")
        }
    }

    // MARK: - Update Stats

    func updateDoomScore() {
        // Fetch today's sessions
        let descriptor = FetchDescriptor<ScrollSession>(
            predicate: #Predicate { session in
                session.startTime >= Date().startOfDay && session.startTime <= Date().endOfDay
            }
        )

        do {
            let sessions = try modelContext.fetch(descriptor)
            let newScore = UserStats.calculateDoomScore(for: sessions)

            // Update today's stats
            let statsDescriptor = FetchDescriptor<UserStats>(
                predicate: #Predicate { stats in
                    stats.date >= Date().startOfDay && stats.date <= Date().endOfDay
                }
            )

            if let todayStats = try modelContext.fetch(statsDescriptor).first {
                todayStats.doomScore = newScore
                todayStats.interventionCount = sessions.filter { $0.wasInterrupted }.count
                todayStats.ignoredInterventions = sessions.filter { $0.wasIgnored }.count
                todayStats.doomScrollTime = sessions.reduce(0) { $0 + $1.duration }

                try modelContext.save()
                doomScore = newScore
                interventionsToday = todayStats.interventionCount
            }
        } catch {
            print("❌ Failed to update doom score: \(error)")
        }
    }

    func updateStreak() {
        // Calculate current streak
        let calendar = Calendar.current
        var streak = 0
        var checkDate = Date()

        while true {
            let descriptor = FetchDescriptor<UserStats>(
                predicate: #Predicate { stats in
                    stats.date >= checkDate.startOfDay && stats.date <= checkDate.endOfDay
                }
            )

            do {
                if let dayStats = try modelContext.fetch(descriptor).first {
                    // Consider it a successful day if doom score is low enough
                    if dayStats.doomScore <= 4 {
                        streak += 1
                        checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? Date()
                    } else {
                        break
                    }
                } else {
                    break
                }
            } catch {
                break
            }
        }

        // Update stats
        let descriptor = FetchDescriptor<UserStats>(
            predicate: #Predicate { stats in
                stats.date >= Date().startOfDay && stats.date <= Date().endOfDay
            }
        )

        do {
            if let todayStats = try modelContext.fetch(descriptor).first {
                todayStats.currentStreak = streak
                if streak > todayStats.longestStreak {
                    todayStats.longestStreak = streak
                }

                try modelContext.save()
                currentStreak = streak
                longestStreak = todayStats.longestStreak
            }
        } catch {
            print("❌ Failed to update streak: \(error)")
        }
    }

    // MARK: - Computed Properties

    var doomScoreMessage: String {
        switch doomScore {
        case 0:
            return "Perfect! ✨"
        case 1...2:
            return "Doing great! 🎉"
        case 3...4:
            return "Not bad 👍"
        case 5...6:
            return "Could be better 😬"
        case 7...8:
            return "Yikes... 😰"
        case 9:
            return "Terminally online 💀"
        case 10:
            return "Touch grass. Seriously. 🌱"
        default:
            return "Error calculating score"
        }
    }

    var percentileMessage: String {
        "Better than \(100 - percentile)% of users"
    }

    var timeSavedFormatted: String {
        timeSaved.formatted
    }

    var averageDoomScore: Double {
        guard !dailyScores.isEmpty else { return 0 }
        let sum = dailyScores.reduce(0) { $0 + $1.score }
        return Double(sum) / Double(dailyScores.count)
    }

    var timeSavedComparisons: [String] {
        let hours = timeSaved / 3600

        return [
            "🎬 \(Int(hours / 2)) movies",
            "📺 \(Int(hours / 0.45)) TV episodes",
            "📚 \(Int(hours / 0.25)) book chapters"
        ]
    }
}

// MARK: - Supporting Types

struct DailyScore: Identifiable {
    let id = UUID()
    let date: Date
    let score: Int
}

struct AppUsage: Identifiable {
    let id = UUID()
    let appName: String
    let duration: TimeInterval

    var durationFormatted: String {
        duration.formatted
    }

    var percentage: Double {
        // Would calculate based on total time
        0.5 // Placeholder
    }
}
