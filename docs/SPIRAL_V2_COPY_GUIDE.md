# Spiral V2 - Complete Copy Guide & Roast Library

## 📝 All Text Content for the App

This document contains EVERY piece of text that appears in Spiral. Copy-paste ready for implementation.

---

## 🔥 Roast Library

### Funny/Sarcastic Roasts (70% probability)
```swift
let funnyRoasts = [
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
    "Remember when you had hobbies?",
]
```

### Motivational Roasts (20% probability)
```swift
let motivationalRoasts = [
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
    "Break the cycle. Right now.",
]
```

### Reality Check Roasts (10% probability)
```swift
let realityCheckRoasts = [
    "You've scrolled for 32 minutes.\n\nIn that time you could've:\n• Finished a workout\n• Called a friend\n• Made dinner\n• Read 2 chapters\n• Taken a walk\n• Actually accomplished something\n\nStill worth it?",
    
    "That's 45 minutes. You just:\n• Watched 6 TikToks about productivity\n• Did zero productive things\n• See the irony?",
    
    "1 hour gone. Here's what you missed:\n• The sun (it's still up)\n• Human interaction\n• Physical movement\n• Your actual goals",
    
    "Let's do the math:\n25 minutes × 4 times a day = 100 minutes\n× 365 days = 608 hours per year\n\nThat's 25 days. Twenty-five. Days.",
    
    "In the time you've scrolled this week, you could have:\n• Learned to code (basics)\n• Read 3 books\n• Started a side project\n• Actually talked to people\n\nBut here we are.",
]
```

### Time-Specific Roasts
```swift
func getTimeSpecificRoast(hour: Int) -> String {
    switch hour {
    case 0...5:
        return [
            "It's \(hour)am. Even your phone wants to sleep.",
            "Midnight doom scroll? Bold strategy.",
            "The sun gave up on you hours ago.",
            "Your circadian rhythm is crying.",
            "Nothing good happens on your phone at \(hour)am.",
        ].randomElement()!
    case 6...8:
        return [
            "Morning doom scroll? Bold strategy.",
            "Starting the day scrolling. This won't end well.",
            "Imagine waking up and choosing violence (against yourself).",
            "Coffee first. Scrolling never.",
        ].randomElement()!
    case 12...13:
        return [
            "Lunch break doom scroll. Classic.",
            "Scrolling through lunch. Your food is judging you.",
            "This is literally your break time. Take an actual break.",
        ].randomElement()!
    case 22...23:
        return [
            "Pre-bed doom scroll. RIP your sleep schedule.",
            "Blue light before bed. Your melatonin is crying.",
            "Your sleep quality just left the chat.",
            "This is why you're tired in the morning.",
        ].randomElement()!
    default:
        return funnyRoasts.randomElement()!
    }
}
```

### Frequency-Based Roasts
```swift
func getFrequencyRoast(interventionsToday: Int) -> String {
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
```

---

## 📱 UI Text Content

### Onboarding

**Screen 1 - Welcome**
```
Title: SPIRAL
Subtitle: Break the spiral. Touch grass.
Button: Let's go
```

**Screen 2 - How It Works**
```
Title: How It Works

Bullet 1: 📊 We detect doom scrolling
         (You know the kind)

Bullet 2: 🌀 We intervene with humor
         (Not judgment)

Bullet 3: 📈 You scroll less, live more
         (The goal)

Button: Continue
```

**Screen 3 - Permissions & Mode**
```
Title: Last Step: Permissions

Body: We need Screen Time access to detect doom scrolling.

      Your data never leaves your device. Promise. 🤝

Button: Grant Permission

---

Choose Your Mode:

○ Gentle 😌
  Soft reminder

● Accountability 💪 (Recommended)
  10s wait, limited ignores

○ Lockdown 🔒
  Complete task to continue

Button: Start Using Spiral
```

---

### Home Screen

```
App Title: SPIRAL

Cards:
1. Today's Doom Score: [X]/10
   [Progress bar]
   [Status message]
   Better than [X]% of users

2. Current Streak: [X] days 🔥
   Longest Streak: [X] days

3. Quick Stats
   • Interventions today: [X]
   • Time saved: [X]h [X]m
   • Top [X]% of users 🎯

Button: View Full Stats
```

**Doom Score Messages:**
```swift
0:     "Perfect! ✨"
1-2:   "Doing great! 🎉"
3-4:   "Not bad 👍"
5-6:   "Could be better 😬"
7-8:   "Yikes... 😰"
9:     "Terminally online 💀"
10:    "Touch grass. Seriously. 🌱"
```

---

### Intervention Screen

**Header:**
```
Caught you! 👀
Been scrolling for [X] minutes.
```

**Roast:**
```
[Randomly selected roast from library]
```

**Quick Response Options:**
```
Worth it - saw good stuff ✓
Total waste - help me stop 🛑
Just taking a break 😌
```

**Optional Note:**
```
Want to note what you saw? (Optional)
[Text field: Type here...]
```

**Bottom Actions:**
```
[Share this roast] [Dismiss]
```

**Accountability Mode Timer:**
```
Dismiss available in [X]s
[Circular progress indicator]
```

**Lockdown Mode:**
```
Title: SPIRAL DETECTED

Body: You need a break.
      Complete a task to continue.

Options:
• Wait 60 seconds
• Solve: What's [X] + [Y]?
• Type: "I will stop doom scrolling"

Button: [Disabled until completion]
       Start Cooldown
```

---

### Stats Screen

```
Title: Stats
Button: [Share]

Time Range: [7D] [30D] [3M] [1Y]

Card 1: Time Saved This Week
        
        [X]h [X]m
        
        That's like...
        🎬 [X] movies
        📺 [X] TV episodes
        📚 [X] chapters

Card 2: Doom Score Trend
        
        [Line chart]
        
        Average: [X]/10 (improving! 📈)

Card 3: Split view
        Interventions    |  Successful Breaks
        [X]              |  [X]
        ↓ [X]% vs last   |  ↑ [X]% vs last

Card 4: Most Doom Scrolled Apps
        
        Instagram    [X]h [X]m  [Progress bar]
        TikTok       [X]h [X]m  [Progress bar]
        Twitter      [X]h [X]m  [Progress bar]

Card 5: You're in the top [X]% 🎯
        
        [X]% of users doom scroll more
        Keep it up!
```

---

### Settings Screen

```
Title: Settings

DETECTION
─────────────────

Mode
[Current mode] 😌/💪/🔒        >

Time Threshold
[X] minutes                    >
(Range: 15-60 min)

Monitored Apps
[X] apps                       >

─────────────────

FEEDBACK
─────────────────

Sound                      [Toggle]
Haptics                    [Toggle]
Haptics Intensity              >
(Light / Medium / Strong)

─────────────────

NOTIFICATIONS
─────────────────

Daily Reminders            [Toggle]
Weekly Recap               [Toggle]
Achievement Alerts         [Toggle]

─────────────────

SHARING
─────────────────

Share Prompts              [Toggle]
Include Stats on Cards     [Toggle]
Card Style                     >

─────────────────

CUSTOMIZATION
─────────────────

Roast Style                    >
(Funny / Motivational / Brutal)

App Icon                       >
(Default / Minimal / Dark)

─────────────────

PRIVACY
─────────────────

All Data Stored Locally    ✓
No Cloud Sync             ✓
No Tracking               ✓

View Privacy Policy           >
Delete All Data               >

─────────────────

ABOUT
─────────────────

Version 1.0.0
Made with 🌀 by [Your Name]

Rate on App Store             >
Share Feedback                >
Follow @SpiralApp             >
```

---

### Achievements

**Positive Achievements:**
```
Touch Grass 🌱
24 hours clean

Week Warrior 🔥
7 day streak

Reformed ✨
30 days with <30min daily avg

Top 10% 🎯
Top 10% of users

Month Clean 👑
30 day streak

Streak Master 💎
100 day streak
```

**Sarcastic Achievements:**
```
Doom Lord 💀
Scrolled 10+ hours in a day

Night Owl 🦉
3am doom scroll session

Serial Scroller 📱
Dismissed 50 interventions

Addict 🤡
Opened TikTok 100 times in a day

Ignorant 🙈
Ignored 10 interventions in a row
```

**Unlock Messages:**
```
🏆 ACHIEVEMENT UNLOCKED

[Achievement Name] [Emoji]

[Description]

You're in the top [X]% of users!

[Share] [Cool, thanks]
```

---

### "Before You Go" Screen

```
Title: Before you go... 🤔

Body: You've opened [App Name]
      [X] times today already.
      
      Still want to?

Buttons:
[Yeah, I'm bored]
[Nah, thanks]
```

---

### Reality Check Screen

```
You've scrolled for [X] minutes.

In that time you could have:
✅ Finished a workout
✅ Called a friend
✅ Made dinner
✅ Read 2 chapters
✅ Taken a walk
✅ Actually accomplished something

Still want to scroll?

[Yeah] [You're right, I'll stop]
```

---

### Share Card Text

**Roast Card:**
```
[Roast text]

- Spiral App 🌀

Break the spiral. Touch grass.
Get it on the App Store
```

**Achievement Card:**
```
ACHIEVEMENT UNLOCKED

[Achievement Name] [Emoji]

[Description]

─────────────────

Powered by Spiral 🌀
Get it on the App Store
```

**Stats Card:**
```
MY SPIRAL STATS

This Week:

⏰ Time saved:    [X]h [X]m
🔥 Streak:        [X] days
📊 Doom Score:    [X]/10
🎯 Rank:          Top [X]%

─────────────────

I'm breaking the spiral 🌀
Get Spiral on iOS
```

**Weekly Recap:**
```
THIS WEEK ON SPIRAL

Monday:    [X]/10 [Emoji]
Tuesday:   [X]/10 [Emoji]
Wednesday: [X]/10 [Emoji]
Thursday:  [X]/10 [Emoji]
Friday:    [X]/10 [Emoji]
Saturday:  [X]/10 [Emoji]
Sunday:    [X]/10 [Emoji]

Average: [X]/10 ([Message])

Powered by Spiral 🌀
```

**Before/After Card:**
```
MY TRANSFORMATION

📱 BEFORE SPIRAL
[X] hours/week scrolling 😱
Feeling: Exhausted
Doom Score: [X]/10

      ↓↓↓

🌱 AFTER SPIRAL
[X] hours/week scrolling 🎉
Feeling: Actually alive
Doom Score: [X]/10

─────────────────
Download Spiral
Break the doom scroll
```

---

### Easter Egg Messages

**Triple Tap Spiral:**
```
You found the secret! 🎉
[Special spiral animation]
```

**Shake During Intervention:**
```
Shaking won't help. Nice try though. 😏
```

**Developer Mode (10 shakes):**
```
DEVELOPER MODE UNLOCKED

📊 Total lines of code: [X]
🐛 Bugs fixed: [X]
⏱️  Hours spent: [X]
☕ Coffee consumed: ∞

Built with 🌀 and sweat

[Close]
```

---

### Notification Text

**Daily Reminder:**
```
Title: "Daily check-in 🌀"
Body: "How's your screen time today? Open Spiral to see."
```

**Achievement Unlocked:**
```
Title: "Achievement Unlocked! 🏆"
Body: "[Achievement Name] - [Description]"
```

**Weekly Recap Ready:**
```
Title: "Your week is wrapped 📊"
Body: "See how you did this week. Spoiler: [Good/Could be better]"
```

**Streak Milestone:**
```
Title: "Streak alert! 🔥"
Body: "[X] days clean. You're on fire!"
```

---

### Error Messages

**Permission Denied:**
```
Title: Permission Required

Body: Spiral needs Screen Time access to detect doom scrolling. Without it, the app can't work.

[Open Settings] [Cancel]
```

**No Data Yet:**
```
Title: No data yet

Body: Use Spiral for a day to see your stats here. We're watching... 👀

[Got it]
```

**Something Broke:**
```
Title: Oops

Body: Something went wrong. Try restarting the app. If this keeps happening, let us know.

[Restart] [Report Bug]
```

---

### Share Prompts

```
"This roast is fire. Share it?"
[Share] [Nah]

"Show off your achievement?"
[Share] [Keep it private]

"Pretty good week. Want to share?"
[Share] [Nah]

"That's huge progress. Flex on your friends?"
[Hell yeah] [Keep it humble]

"9/10... maybe share this as a warning?"
[Share the shame] [No thanks]
```

---

### Mode Descriptions (Settings Detail)

**Gentle Mode:**
```
GENTLE MODE 😌

How it works:
• Shows intervention screen
• One tap to dismiss
• Tracks everything
• No blocking

Best for:
Most people who want casual accountability without being too strict.

[Select]
```

**Accountability Mode:**
```
ACCOUNTABILITY MODE 💪

How it works:
• Shows intervention screen
• Must wait 10 seconds to dismiss
• Can only dismiss 3 times per day
• After 3rd ignore → switches to Lockdown

Best for:
People who need more friction to break the habit.

[Select]
```

**Lockdown Mode:**
```
LOCKDOWN MODE 🔒

How it works:
• Full-screen takeover
• Must complete task to continue
• 60s wait OR solve challenge
• Sets 15 min cooldown after

Best for:
Nuclear option when you really need to stop.

[Select]
```

---

## 🎭 Tone Guidelines

**Voice:**
- Your funny friend who calls you out
- Honest but not mean
- Self-aware and meta
- Gen Z humor without being cringe

**What Works:**
✅ "Caught you! 👀"
✅ "This is the 4th time today. You good?"
✅ "Your thumb is more active than you are."

**What Doesn't:**
❌ "Warning: Excessive screen time detected."
❌ "Please reflect on your choices."
❌ "You should consider reducing usage."

---

## 📊 Dynamic Text Patterns

### Time Formatting
```swift
func formatDuration(_ seconds: TimeInterval) -> String {
    let hours = Int(seconds) / 3600
    let minutes = Int(seconds) / 60 % 60
    
    if hours > 0 {
        return "\(hours)h \(minutes)m"
    } else {
        return "\(minutes)m"
    }
}
```

### Percentile Messages
```swift
func percentileMessage(_ rank: Int) -> String {
    switch rank {
    case 0...10:
        return "You're in the top \(rank)%! Legend status. 🏆"
    case 11...25:
        return "Top \(rank)%. Doing great! 🎯"
    case 26...50:
        return "Better than \(100-rank)% of users. Not bad! 👍"
    case 51...75:
        return "\(100-rank)% of users scroll more than you. Could be worse! 😅"
    default:
        return "Top \(rank)%... room for improvement. 📈"
    }
}
```

### Time Saved Comparisons
```swift
func timeSavedComparison(_ minutes: Int) -> [String] {
    let hours = Double(minutes) / 60.0
    
    return [
        "🎬 \(Int(hours / 2)) movies",
        "📺 \(Int(hours / 0.45)) TV episodes",
        "📚 \(Int(hours / 0.25)) book chapters",
        "🏃 \(Int(hours)) workout sessions",
        "☕ \(Int(hours * 4)) coffee breaks",
    ]
}
```

---

**All text in this document is final and ready for implementation. Copy-paste freely!** 🌀
