//
//  AchievementManager.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class AchievementManager: ObservableObject {
    // MARK: - Published Properties

    @Published var unlockedAchievements: [Achievement] = []
    @Published var showingAchievement: Achievement?

    // MARK: - Private Properties

    private let modelContext: ModelContext

    // MARK: - Initialization

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadUnlockedAchievements()
    }

    // MARK: - Load Achievements

    private func loadUnlockedAchievements() {
        let descriptor = FetchDescriptor<UserAchievement>()
        do {
            let achievements = try modelContext.fetch(descriptor)
            unlockedAchievements = achievements.map { $0.achievement }
        } catch {
            print("❌ Failed to load achievements: \(error)")
        }
    }

    // MARK: - Check Achievements

    /// Check all achievement conditions based on current stats
    func checkAchievements(stats: UserStats, sessions: [ScrollSession]) {
        // Positive Achievements
        checkTouchGrass(stats: stats)
        checkWeekWarrior(stats: stats)
        checkReformed(stats: stats)
        checkTopTen(stats: stats)
        checkMonthClean(stats: stats)
        checkStreakMaster(stats: stats)

        // Sarcastic Achievements
        checkDoomLord(stats: stats)
        checkNightOwl(sessions: sessions)
        checkSerialScroller(sessions: sessions)
        checkAddict(sessions: sessions)
        checkIgnorant(sessions: sessions)
    }

    // MARK: - Positive Achievement Checks

    private func checkTouchGrass(stats: UserStats) {
        guard !isUnlocked(.touchGrass) else { return }

        if stats.currentStreak >= 1 {
            unlockAchievement(.touchGrass)
        }
    }

    private func checkWeekWarrior(stats: UserStats) {
        guard !isUnlocked(.weekWarrior) else { return }

        if stats.currentStreak >= 7 {
            unlockAchievement(.weekWarrior)
        }
    }

    private func checkReformed(stats: UserStats) {
        guard !isUnlocked(.reformed) else { return }

        // Need to check 30-day average < 30 minutes
        // For now, simplified check
        if stats.currentStreak >= 30 && stats.doomScrollTime < 1800 { // < 30 min today
            unlockAchievement(.reformed)
        }
    }

    private func checkTopTen(stats: UserStats) {
        guard !isUnlocked(.topTen) else { return }

        if stats.percentileRank <= 10 {
            unlockAchievement(.topTen)
        }
    }

    private func checkMonthClean(stats: UserStats) {
        guard !isUnlocked(.monthClean) else { return }

        if stats.currentStreak >= 30 {
            unlockAchievement(.monthClean)
        }
    }

    private func checkStreakMaster(stats: UserStats) {
        guard !isUnlocked(.streakMaster) else { return }

        if stats.currentStreak >= 100 {
            unlockAchievement(.streakMaster)
        }
    }

    // MARK: - Sarcastic Achievement Checks

    private func checkDoomLord(stats: UserStats) {
        guard !isUnlocked(.doomLord) else { return }

        // 10+ hours in a day
        if stats.doomScrollTime >= 36000 { // 10 hours
            unlockAchievement(.doomLord)
        }
    }

    private func checkNightOwl(sessions: [ScrollSession]) {
        guard !isUnlocked(.nightOwl) else { return }

        // Check for 3am session
        let lateNightSession = sessions.first { session in
            let hour = Calendar.current.component(.hour, from: session.startTime)
            return hour == 3
        }

        if lateNightSession != nil {
            unlockAchievement(.nightOwl)
        }
    }

    private func checkSerialScroller(sessions: [ScrollSession]) {
        guard !isUnlocked(.serialScroller) else { return }

        // Count all dismissed interventions
        let dismissedCount = sessions.filter { $0.wasIgnored }.count

        if dismissedCount >= 50 {
            unlockAchievement(.serialScroller)
        }
    }

    private func checkAddict(sessions: [ScrollSession]) {
        guard !isUnlocked(.addict) else { return }

        // Check if TikTok was opened 100 times today
        let tiktokSessions = sessions.filter { $0.appName.contains("TikTok") }

        if tiktokSessions.count >= 100 {
            unlockAchievement(.addict)
        }
    }

    private func checkIgnorant(sessions: [ScrollSession]) {
        guard !isUnlocked(.ignorant) else { return }

        // Check for 10 consecutive ignores
        let sortedSessions = sessions.sorted { $0.startTime < $1.startTime }
        var consecutiveIgnores = 0

        for session in sortedSessions {
            if session.wasIgnored {
                consecutiveIgnores += 1
                if consecutiveIgnores >= 10 {
                    unlockAchievement(.ignorant)
                    return
                }
            } else if session.wasInterrupted {
                consecutiveIgnores = 0
            }
        }
    }

    // MARK: - Unlock Achievement

    private func unlockAchievement(_ achievement: Achievement) {
        guard !isUnlocked(achievement) else { return }

        // Save to SwiftData
        let userAchievement = UserAchievement(achievement: achievement)
        modelContext.insert(userAchievement)

        do {
            try modelContext.save()
            unlockedAchievements.append(achievement)

            // Show popup
            showAchievementPopup(achievement)

            print("🏆 Achievement Unlocked: \(achievement.displayName)")
        } catch {
            print("❌ Failed to save achievement: \(error)")
        }
    }

    // MARK: - Helper Methods

    func isUnlocked(_ achievement: Achievement) -> Bool {
        unlockedAchievements.contains(achievement)
    }

    private func showAchievementPopup(_ achievement: Achievement) {
        withAnimation {
            showingAchievement = achievement
        }

        // Auto-dismiss after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                self.showingAchievement = nil
            }
        }
    }

    func dismissAchievementPopup() {
        withAnimation {
            showingAchievement = nil
        }
    }

    func markAsShared(_ achievement: Achievement) {
        let descriptor = FetchDescriptor<UserAchievement>(
            predicate: #Predicate { $0.achievementRawValue == achievement.rawValue }
        )

        do {
            if let userAchievement = try modelContext.fetch(descriptor).first {
                userAchievement.wasShared = true
                try modelContext.save()
            }
        } catch {
            print("❌ Failed to mark achievement as shared: \(error)")
        }
    }

    // MARK: - Statistics

    var totalAchievements: Int {
        Achievement.allCases.count
    }

    var unlockedCount: Int {
        unlockedAchievements.count
    }

    var progressPercentage: Double {
        Double(unlockedCount) / Double(totalAchievements)
    }

    var positiveAchievements: [Achievement] {
        unlockedAchievements.filter { $0.isPositive }
    }

    var sarcasticAchievements: [Achievement] {
        unlockedAchievements.filter { !$0.isPositive }
    }
}
