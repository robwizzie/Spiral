//
//  Achievement.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import Foundation
import SwiftData

// MARK: - Achievement Enum

enum Achievement: String, CaseIterable, Codable {
    // Positive Achievements
    case touchGrass = "Touch Grass"
    case weekWarrior = "Week Warrior"
    case reformed = "Reformed"
    case topTen = "Top 10%"
    case monthClean = "Month Clean"
    case streakMaster = "Streak Master"

    // Sarcastic Achievements
    case doomLord = "Doom Lord"
    case nightOwl = "Night Owl"
    case serialScroller = "Serial Scroller"
    case addict = "Addict"
    case ignorant = "Ignorant"

    var displayName: String {
        rawValue
    }

    var description: String {
        switch self {
        case .touchGrass:
            return "24 hours clean"
        case .weekWarrior:
            return "7 day streak"
        case .reformed:
            return "30 days with <30min daily avg"
        case .topTen:
            return "Top 10% of users"
        case .monthClean:
            return "30 day streak"
        case .streakMaster:
            return "100 day streak"
        case .doomLord:
            return "Scrolled 10+ hours in a day"
        case .nightOwl:
            return "3am doom scroll session"
        case .serialScroller:
            return "Dismissed 50 interventions"
        case .addict:
            return "Opened TikTok 100 times in a day"
        case .ignorant:
            return "Ignored 10 interventions in a row"
        }
    }

    var emoji: String {
        switch self {
        case .touchGrass: return "🌱"
        case .weekWarrior: return "🔥"
        case .reformed: return "✨"
        case .topTen: return "🎯"
        case .monthClean: return "👑"
        case .streakMaster: return "💎"
        case .doomLord: return "💀"
        case .nightOwl: return "🦉"
        case .serialScroller: return "📱"
        case .addict: return "🤡"
        case .ignorant: return "🙈"
        }
    }

    var isPositive: Bool {
        switch self {
        case .touchGrass, .weekWarrior, .reformed, .topTen, .monthClean, .streakMaster:
            return true
        default:
            return false
        }
    }
}

// MARK: - User Achievement Model

@Model
class UserAchievement {
    var id: UUID
    var achievementRawValue: String
    var unlockedAt: Date
    var wasShared: Bool

    var achievement: Achievement {
        get {
            Achievement(rawValue: achievementRawValue) ?? .touchGrass
        }
        set {
            achievementRawValue = newValue.rawValue
        }
    }

    init(
        id: UUID = UUID(),
        achievement: Achievement,
        unlockedAt: Date = Date(),
        wasShared: Bool = false
    ) {
        self.id = id
        self.achievementRawValue = achievement.rawValue
        self.unlockedAt = unlockedAt
        self.wasShared = wasShared
    }
}
