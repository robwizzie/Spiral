//
//  RoastLibrary.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/4/25.
//

import Foundation

/// Complete library of roasts from SPIRAL_V2_COPY_GUIDE.md
struct RoastLibrary {

    // MARK: - Funny/Sarcastic Roasts (70% probability)

    static let funny = [
        "Congrats, you've seen every meme on the internet. Twice.",
        "Your thumb is more active than you are.",
        "Still scrolling? The content doesn't get better.",
        "Fun fact: You could've learned Spanish in this time.",
        "This is literally called DOOM scrolling. The name isn't subtle.",
        "Breaking news: Nothing has changed since you last checked.",
        "The algorithm is laughing at you right now.",
        "Plot twist: All those posts are from yesterday.",
        "Imagine if you spent this time doing literally anything else.",
        "Your screen time could power a small country.",
        "Congrats, you've achieved peak brain rot. 🧠",
        "The person you're ignoring IRL misses you.",
        "This is the 4th time today. You good?",
        "Still here? The pixels aren't gonna scroll themselves. Oh wait...",
        "Fun fact: Grass exists outside.",
        "Your FYP is judging you.",
        "Achievement Unlocked: Professional Scroller 🏆",
        "This is intervention #7 today. Maybe we're onto something?",
        "The internet will still be here if you leave. Promise.",
        "Blink if you're being held hostage by your feed.",
        "Bet you forgot what you were looking for 30 minutes ago.",
        "Your battery is dying faster than your productivity.",
        "Main character energy: You're not the main character.",
        "That's 45 minutes you'll never get back. Worth it?",
        "Even your phone thinks this is excessive.",
        "Plot twist: Everyone else is also just scrolling.",
        "Congratulations, you've achieved absolutely nothing.",
        "Your brain cells are literally thanking you for stopping.",
        "The void scrolls back.",
        "Remember when you had hobbies?"
    ]

    // MARK: - Motivational Roasts (20% probability)

    static let motivational = [
        "You're better than this. Seriously.",
        "What are you avoiding right now?",
        "Real talk: How do you feel after scrolling?",
        "Is this how you want to spend the next hour?",
        "Future you is disappointed.",
        "Remember when you said you'd be productive today?",
        "The day is 1% over. Make it count.",
        "What would happen if you put your phone down?",
        "You've got one life. Is this it?",
        "Time you enjoy wasting isn't wasted... but is this enjoyable?",
        "Your goals are waiting for you.",
        "This moment could be different.",
        "You know what needs to be done.",
        "The dopamine isn't real, but your time is.",
        "Break the cycle. Right now."
    ]

    // MARK: - Reality Check Roasts (10% probability)

    static let realityCheck = [
        """
        You've scrolled for 32 minutes.

        In that time you could've:
        • Finished a workout
        • Called a friend
        • Made dinner
        • Read 2 chapters
        • Taken a walk
        • Actually accomplished something

        Still worth it?
        """,

        """
        That's 45 minutes. You just:
        • Watched 6 TikToks about productivity
        • Did zero productive things
        • See the irony?
        """,

        """
        1 hour gone. Here's what you missed:
        • The sun (it's still up)
        • Human interaction
        • Physical movement
        • Your actual goals
        """,

        """
        Let's do the math:
        25 minutes × 4 times a day = 100 minutes
        × 365 days = 608 hours per year

        That's 25 days. Twenty-five. Days.
        """,

        """
        In the time you've scrolled this week, you could have:
        • Learned to code (basics)
        • Read 3 books
        • Started a side project
        • Actually talked to people

        But here we are.
        """
    ]

    // MARK: - Time-Specific Roasts

    static func getTimeSpecificRoast(hour: Int) -> String {
        switch hour {
        case AppConstants.lateNightHours:
            return [
                "It's \(hour)am. Even your phone wants to sleep.",
                "Midnight doom scroll? Bold strategy.",
                "The sun gave up on you hours ago.",
                "Your circadian rhythm is crying.",
                "Nothing good happens on your phone at \(hour)am."
            ].randomElement()!

        case AppConstants.morningHours:
            return [
                "Morning doom scroll? Bold strategy.",
                "Starting the day scrolling. This won't end well.",
                "Imagine waking up and choosing violence (against yourself).",
                "Coffee first. Scrolling never."
            ].randomElement()!

        case AppConstants.lunchHours:
            return [
                "Lunch break doom scroll. Classic.",
                "Scrolling through lunch. Your food is judging you.",
                "This is literally your break time. Take an actual break."
            ].randomElement()!

        case AppConstants.preBedHours:
            return [
                "Pre-bed doom scroll. RIP your sleep schedule.",
                "Blue light before bed. Your melatonin is crying.",
                "Your sleep quality just left the chat.",
                "This is why you're tired in the morning."
            ].randomElement()!

        default:
            return funny.randomElement()!
        }
    }

    // MARK: - Frequency-Based Roasts

    static func getFrequencyRoast(interventionsToday: Int) -> String {
        switch interventionsToday {
        case 1:
            return "First one today. Let's keep it that way."
        case 2:
            return "That's twice. Seeing a pattern?"
        case 3:
            return "Three times. Maybe you need Accountability mode?"
        case 4...6:
            return "Intervention #\(interventionsToday). Should we talk?"
        case 7...9:
            return "This is getting ridiculous. Lockdown mode exists for a reason."
        default:
            return "You've been caught \(interventionsToday) times today. That's... impressive? No, wait. Concerning."
        }
    }

    // MARK: - Helper Methods

    /// Get a random roast from all categories
    static func randomRoast() -> String {
        let allRoasts = funny + motivational + realityCheck
        return allRoasts.randomElement() ?? "You've been scrolling a while."
    }
}
