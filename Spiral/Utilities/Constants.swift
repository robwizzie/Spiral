//
//  Constants.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/4/25.
//

import Foundation

struct AppConstants {
    // MARK: - Detection Thresholds

    /// Default time threshold for doom scroll detection (25 minutes)
    static let defaultTimeThreshold: TimeInterval = 1500 // 25 minutes (changed from 60)

    /// Minimum threshold user can set (15 minutes)
    static let minTimeThreshold: TimeInterval = 900

    /// Maximum threshold user can set (60 minutes)
    static let maxTimeThreshold: TimeInterval = 3600

    // MARK: - Detection Parameters

    /// Interaction ratio threshold (below this = doom scrolling)
    static let interactionRatioThreshold: Double = 0.1 // 10%

    /// Minimum scroll velocity for passive doom scrolling
    static let minScrollVelocityThreshold: Double = 50.0

    /// Maximum app switches before considering active use
    static let maxAppSwitchesForDoomScroll: Int = 5

    // MARK: - Accountability Mode Settings

    /// Wait time before dismiss button appears (seconds)
    static let accountabilityWaitTime: Int = 10

    /// Maximum dismissals allowed per day in accountability mode
    static let maxDismissalsPerDay: Int = 3

    /// Cooldown period after lockdown (minutes)
    static let lockdownCooldownMinutes: Int = 15

    // MARK: - Doom Score Calculation

    /// Time ranges for doom score calculation (in seconds)
    static let doomScoreTimeRanges = [
        (min: 0, max: 900, points: 0),      // < 15 min
        (min: 900, max: 1800, points: 1),   // 15-30 min
        (min: 1800, max: 3600, points: 2),  // 30-60 min
        (min: 3600, max: 7200, points: 3),  // 1-2 hours
        (min: 7200, max: Int.max, points: 4) // 2+ hours
    ]

    /// Maximum points for each doom score factor
    static let maxInterventionPoints: Int = 3
    static let maxIgnoredPoints: Int = 2
    static let lateNightPoints: Int = 1

    // MARK: - Default Apps to Monitor

    static let defaultMonitoredApps = [
        "com.apple.mobilesafari",
        "com.burbn.instagram",
        "com.zhiliaoapp.musically", // TikTok
        "com.atebits.Tweetie2", // Twitter/X
        "com.facebook.Facebook",
        "com.reddit.Reddit"
    ]

    // MARK: - Roast Selection Probabilities

    /// Probability of funny/sarcastic roast (70%)
    static let funnyRoastProbability: Int = 7

    /// Probability of motivational roast (20%)
    static let motivationalRoastProbability: Int = 2

    /// Probability of reality check roast (10%)
    static let realityCheckRoastProbability: Int = 1

    // MARK: - Time of Day Ranges

    static let lateNightHours: ClosedRange<Int> = 0...5
    static let morningHours: ClosedRange<Int> = 6...8
    static let lunchHours: ClosedRange<Int> = 12...13
    static let preBedHours: ClosedRange<Int> = 22...23

    // MARK: - Animation Durations

    static let spiralBreakingDuration: Double = 0.8
    static let spiralReformDuration: Double = 1.0
    static let spiralBreathingDuration: Double = 4.0
    static let spiralRotationDuration: Double = 30.0

    // MARK: - UI Constants

    static let cardCornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 12
    static let cardPadding: CGFloat = 20
    static let standardSpacing: CGFloat = 16
}
