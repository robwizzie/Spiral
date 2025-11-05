//
//  RoastEngine.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/4/25.
//

import Foundation

/// Context for intervention roast selection
struct InterventionContext {
    let interventionsToday: Int
    let hour: Int
    let scrollDuration: TimeInterval
    let doomScore: Int
    let currentStreak: Int
}

/// Engine for selecting appropriate roasts based on context
class RoastEngine {

    // MARK: - Main Selection Method

    /// Select an appropriate roast based on intervention context
    /// - Parameter context: The current intervention context
    /// - Returns: A roast message string
    func selectRoast(context: InterventionContext) -> String {
        // 70% funny, 20% motivational, 10% reality check
        let roll = Int.random(in: 1...10)

        var roast: String

        if roll <= AppConstants.funnyRoastProbability {
            // Funny/Sarcastic roasts (70%)
            roast = selectFunnyRoast(context: context)
        } else if roll <= (AppConstants.funnyRoastProbability + AppConstants.motivationalRoastProbability) {
            // Motivational roasts (20%)
            roast = selectMotivationalRoast(context: context)
        } else {
            // Reality check roasts (10%)
            roast = selectRealityCheckRoast(context: context)
        }

        return roast
    }

    // MARK: - Category Selection Methods

    /// Select a funny/sarcastic roast with context awareness
    private func selectFunnyRoast(context: InterventionContext) -> String {
        // Check for special conditions first

        // High frequency interventions today
        if context.interventionsToday >= 3 {
            return RoastLibrary.getFrequencyRoast(interventionsToday: context.interventionsToday)
        }

        // Late night scrolling
        if AppConstants.lateNightHours.contains(context.hour) {
            return RoastLibrary.getTimeSpecificRoast(hour: context.hour)
        }

        // Early morning scrolling
        if AppConstants.morningHours.contains(context.hour) {
            return RoastLibrary.getTimeSpecificRoast(hour: context.hour)
        }

        // Lunch time scrolling
        if AppConstants.lunchHours.contains(context.hour) {
            return RoastLibrary.getTimeSpecificRoast(hour: context.hour)
        }

        // Pre-bed scrolling
        if AppConstants.preBedHours.contains(context.hour) {
            return RoastLibrary.getTimeSpecificRoast(hour: context.hour)
        }

        // Default: random funny roast
        return RoastLibrary.funny.randomElement() ?? "Still scrolling?"
    }

    /// Select a motivational roast
    private func selectMotivationalRoast(context: InterventionContext) -> String {
        // If they have a good streak going, give extra motivation
        if context.currentStreak > 0 {
            let streakMotivation = [
                "You had a \(context.currentStreak) day streak going. Don't break it now.",
                "You're better than this. You've proven it for \(context.currentStreak) days.",
            ]
            // 30% chance to use streak-specific message
            if Bool.random() && Double.random(in: 0...1) < 0.3 {
                return streakMotivation.randomElement()!
            }
        }

        return RoastLibrary.motivational.randomElement() ?? "You can do better."
    }

    /// Select a reality check roast
    private func selectRealityCheckRoast(context: InterventionContext) -> String {
        // Customize the reality check with actual duration if needed
        let roast = RoastLibrary.realityCheck.randomElement() ?? "Let's be real about your time."

        // If the roast contains "32 minutes", replace with actual duration
        if roast.contains("32 minutes") {
            let minutes = Int(context.scrollDuration / 60)
            return roast.replacingOccurrences(of: "32 minutes", with: "\(minutes) minutes")
        }

        // If the roast contains "45 minutes", replace with actual duration
        if roast.contains("45 minutes") {
            let minutes = Int(context.scrollDuration / 60)
            return roast.replacingOccurrences(of: "45 minutes", with: "\(minutes) minutes")
        }

        return roast
    }

    // MARK: - Utility Methods

    /// Format duration for display in roasts
    func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) minutes"
        }
    }

    /// Get intervention message header based on mode and context
    func getInterventionHeader(mode: InterventionMode, context: InterventionContext) -> String {
        switch mode {
        case .gentle:
            return "Caught you! 👀"
        case .accountability:
            if context.interventionsToday >= AppConstants.maxDismissalsPerDay {
                return "That's \(context.interventionsToday) ignores today. 😬"
            }
            return "Caught you! 👀"
        case .lockdown:
            return "SPIRAL DETECTED 🌀"
        }
    }

    /// Get duration message for intervention screen
    func getDurationMessage(duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)

        if minutes < 30 {
            return "Been scrolling for \(minutes) minutes."
        } else if minutes < 60 {
            return "Been scrolling for \(minutes) minutes. That's half an hour."
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "Been scrolling for \(hours)h \(remainingMinutes)m. Seriously."
        }
    }
}

// MARK: - Roast Style Filter

extension RoastEngine {
    /// Filter roasts based on user's preferred style setting
    func selectRoastWithStyle(context: InterventionContext, style: RoastStyle) -> String {
        switch style {
        case .funny:
            return selectFunnyRoast(context: context)
        case .motivational:
            return selectMotivationalRoast(context: context)
        case .brutal:
            // Brutal mode: prioritize reality checks and frequency-based roasts
            if context.interventionsToday >= 2 {
                return RoastLibrary.getFrequencyRoast(interventionsToday: context.interventionsToday)
            }
            return selectRealityCheckRoast(context: context)
        case .mixed:
            // Mixed mode: use the default algorithm
            return selectRoast(context: context)
        }
    }
}
