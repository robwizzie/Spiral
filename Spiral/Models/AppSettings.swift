//
//  AppSettings.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/4/25.
//

import Foundation
import SwiftData

@Model
class AppSettings {
    var id: UUID
    var interventionMode: InterventionMode
    var timeThreshold: TimeInterval
    var monitoredApps: [String]
    var soundEnabled: Bool
    var soundVolume: Float
    var hapticsEnabled: Bool
    var hapticsIntensity: HapticsIntensity
    var notificationsEnabled: Bool
    var dailyReminders: Bool
    var weeklyRecap: Bool
    var achievementAlerts: Bool
    var sharePromptsEnabled: Bool
    var includeStatsInShares: Bool
    var roastStyle: RoastStyle
    var hasCompletedOnboarding: Bool
    var appIconStyle: AppIconStyle

    init(
        id: UUID = UUID(),
        interventionMode: InterventionMode = .accountability,
        timeThreshold: TimeInterval = AppConstants.defaultTimeThreshold,
        monitoredApps: [String] = AppConstants.defaultMonitoredApps,
        soundEnabled: Bool = true,
        soundVolume: Float = 0.8,
        hapticsEnabled: Bool = true,
        hapticsIntensity: HapticsIntensity = .medium,
        notificationsEnabled: Bool = true,
        dailyReminders: Bool = true,
        weeklyRecap: Bool = true,
        achievementAlerts: Bool = true,
        sharePromptsEnabled: Bool = true,
        includeStatsInShares: Bool = true,
        roastStyle: RoastStyle = .funny,
        hasCompletedOnboarding: Bool = false,
        appIconStyle: AppIconStyle = .default
    ) {
        self.id = id
        self.interventionMode = interventionMode
        self.timeThreshold = timeThreshold
        self.monitoredApps = monitoredApps
        self.soundEnabled = soundEnabled
        self.soundVolume = soundVolume
        self.hapticsEnabled = hapticsEnabled
        self.hapticsIntensity = hapticsIntensity
        self.notificationsEnabled = notificationsEnabled
        self.dailyReminders = dailyReminders
        self.weeklyRecap = weeklyRecap
        self.achievementAlerts = achievementAlerts
        self.sharePromptsEnabled = sharePromptsEnabled
        self.includeStatsInShares = includeStatsInShares
        self.roastStyle = roastStyle
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.appIconStyle = appIconStyle
    }
}

// MARK: - Enums

enum InterventionMode: String, Codable {
    case gentle
    case accountability
    case lockdown

    var displayName: String {
        switch self {
        case .gentle: return "Gentle"
        case .accountability: return "Accountability"
        case .lockdown: return "Lockdown"
        }
    }

    var description: String {
        switch self {
        case .gentle:
            return "Soft reminder, easy dismiss"
        case .accountability:
            return "10s wait, 3 ignores max"
        case .lockdown:
            return "Complete task to continue"
        }
    }

    var emoji: String {
        switch self {
        case .gentle: return "😌"
        case .accountability: return "💪"
        case .lockdown: return "🔒"
        }
    }
}

enum HapticsIntensity: String, Codable {
    case light
    case medium
    case strong

    var displayName: String {
        rawValue.capitalized
    }
}

enum RoastStyle: String, Codable {
    case funny
    case motivational
    case brutal
    case mixed

    var displayName: String {
        switch self {
        case .funny: return "Funny"
        case .motivational: return "Motivational"
        case .brutal: return "Brutal"
        case .mixed: return "Mixed"
        }
    }
}

enum AppIconStyle: String, Codable {
    case `default`
    case minimal
    case dark

    var displayName: String {
        switch self {
        case .default: return "Default"
        case .minimal: return "Minimal"
        case .dark: return "Dark"
        }
    }
}
