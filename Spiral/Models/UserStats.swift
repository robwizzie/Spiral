//
//  UserStats.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/4/25.
//

import Foundation
import SwiftData

@Model
class UserStats {
    var id: UUID
    var date: Date
    var doomScore: Int
    var totalScreenTime: TimeInterval
    var doomScrollTime: TimeInterval
    var interventionCount: Int
    var successfulBreaks: Int
    var ignoredInterventions: Int
    var currentStreak: Int
    var longestStreak: Int
    var appUsageBreakdown: [String: TimeInterval]
    var timeSaved: TimeInterval
    var percentileRank: Int

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        doomScore: Int = 0,
        totalScreenTime: TimeInterval = 0,
        doomScrollTime: TimeInterval = 0,
        interventionCount: Int = 0,
        successfulBreaks: Int = 0,
        ignoredInterventions: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        appUsageBreakdown: [String: TimeInterval] = [:],
        timeSaved: TimeInterval = 0,
        percentileRank: Int = 50
    ) {
        self.id = id
        self.date = date
        self.doomScore = doomScore
        self.totalScreenTime = totalScreenTime
        self.doomScrollTime = doomScrollTime
        self.interventionCount = interventionCount
        self.successfulBreaks = successfulBreaks
        self.ignoredInterventions = ignoredInterventions
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.appUsageBreakdown = appUsageBreakdown
        self.timeSaved = timeSaved
        self.percentileRank = percentileRank
    }

    /// Get the doom score message based on current score
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

    /// Get percentile message
    var percentileMessage: String {
        switch percentileRank {
        case 0...10:
            return "You're in the top \(percentileRank)%! Legend status. 🏆"
        case 11...25:
            return "Top \(percentileRank)%. Doing great! 🎯"
        case 26...50:
            return "Better than \(100-percentileRank)% of users. Not bad! 👍"
        case 51...75:
            return "\(100-percentileRank)% of users scroll more than you. Could be worse! 😅"
        default:
            return "Top \(percentileRank)%... room for improvement. 📈"
        }
    }
}

// MARK: - Helper Methods

extension UserStats {
    /// Calculate doom score for a given date based on sessions
    static func calculateDoomScore(for sessions: [ScrollSession]) -> Int {
        var score = 0

        // Factor 1: Total doom scroll time (0-4 points)
        let totalDoomTime = sessions.reduce(0) { $0 + $1.duration }
        for range in AppConstants.doomScoreTimeRanges {
            if totalDoomTime >= range.min && totalDoomTime < range.max {
                score += range.points
                break
            }
        }

        // Factor 2: Number of interventions (0-3 points)
        let interventionCount = sessions.filter { $0.wasInterrupted }.count
        score += min(interventionCount, AppConstants.maxInterventionPoints)

        // Factor 3: Ignored interventions (0-2 points)
        let ignoredCount = sessions.filter { $0.wasIgnored }.count
        score += min(ignoredCount, AppConstants.maxIgnoredPoints)

        // Factor 4: Time of day multiplier (late night = +1)
        let lateNightSessions = sessions.filter { session in
            let hour = Calendar.current.component(.hour, from: session.startTime)
            return AppConstants.lateNightHours.contains(hour)
        }
        if !lateNightSessions.isEmpty {
            score += AppConstants.lateNightPoints
        }

        return min(score, 10) // Cap at 10
    }
}
