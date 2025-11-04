# Spiral V2 - Complete Project Specification

## 🌀 Project Overview

**App Name:** Spiral  
**Tagline:** Break the spiral. Touch grass.  
**Platform:** iOS 16.0+  
**Tech Stack:** SwiftUI, SwiftData, FamilyControls  
**Philosophy:** Funny, effective, beautiful. No bullshit.

---

## 🎯 What Makes V2 Different

This isn't just a screen time tracker. This is:
- **Actually funny** - Roasts that make you laugh while calling you out
- **Smart detection** - Knows the difference between doom scrolling and being productive
- **Effortlessly shareable** - Every moment is Instagram-ready
- **Beautifully animated** - The spiral breaking is *chef's kiss*
- **Privacy-first** - Zero data collection, 100% on-device
- **No signup** - Download and go

---

## 🎨 Core Philosophy & Tone

### Voice & Personality
**Think:** Your brutally honest friend who makes you laugh while calling you out

**Examples:**
- ✅ "Caught you! 👀 Been scrolling for 28 minutes. Worth it?"
- ✅ "This is the 4th time today. You good?"
- ✅ "Your thumb is more active than you are."
- ❌ "Warning: Excessive screen time detected." (too corporate)
- ❌ "Please reflect on your choices." (too preachy)

### Design Principles
1. **Clean AF** - Every pixel matters
2. **Fast** - Launch in < 1 second, 60fps animations
3. **Funny** - But not cringe
4. **Helpful** - Underneath the humor, genuinely useful
5. **Private** - Your data never leaves your device

---

## 🏗️ Technical Architecture

### Tech Stack
```
Language: Swift 5.9+
Framework: SwiftUI
Storage: SwiftData (100% local)
Minimum iOS: 16.0

Key Frameworks:
- FamilyControls (Screen Time API)
- DeviceActivity (Usage monitoring)
- UserNotifications (Local alerts)
- CoreHaptics (Custom vibrations)
- UIKit (Share sheet, image generation)
```

### Project Structure
```
Spiral/
├── App/
│   └── SpiralApp.swift
├── Models/
│   ├── AppSettings.swift
│   ├── ScrollSession.swift
│   ├── UserStats.swift
│   ├── Achievement.swift
│   ├── RoastMessage.swift
│   └── ShareCard.swift
├── Views/
│   ├── HomeView.swift
│   ├── InterventionView.swift
│   ├── StatsView.swift
│   ├── SettingsView.swift
│   ├── OnboardingView.swift
│   ├── ShareCardView.swift
│   └── Components/
│       ├── SpiralAnimation.swift
│       ├── DoomScoreCard.swift
│       ├── AchievementCard.swift
│       ├── StatCard.swift
│       └── RoastCard.swift
├── ViewModels/
│   ├── ScrollDetectionViewModel.swift
│   ├── InterventionViewModel.swift
│   ├── StatsViewModel.swift
│   ├── SettingsViewModel.swift
│   └── ShareViewModel.swift
├── Services/
│   ├── ScreenTimeMonitor.swift
│   ├── DoomScrollDetector.swift (NEW - Active vs Passive)
│   ├── RoastEngine.swift (NEW - Roast generation)
│   ├── AchievementManager.swift (NEW)
│   ├── ShareCardGenerator.swift (NEW)
│   ├── HapticsManager.swift
│   ├── SoundManager.swift
│   └── DataManager.swift
├── Utilities/
│   ├── Constants.swift
│   ├── Extensions.swift
│   └── RoastLibrary.swift (NEW - All roasts)
└── Resources/
    ├── Assets.xcassets/
    ├── Sounds/
    │   ├── intervention.mp3
    │   ├── success.mp3
    │   ├── break.mp3
    │   └── achievement.mp3
    └── ShareTemplates/
        └── (Dynamic generation)
```

---

## 🎮 Core Features

### 1. Smart Doom Scroll Detection

**The Most Important Feature** - Get this right or the app is useless.

#### Detection Algorithm
```swift
struct DoomScrollSession {
    var startTime: Date
    var duration: TimeInterval
    var scrollEvents: Int
    var interactions: Int  // likes, comments, posts, shares
    var appSwitches: Int
    var scrollVelocity: Double  // pixels per second
    var timeOfDay: Date
}

func isDoomScrolling(_ session: DoomScrollSession) -> Bool {
    // 1. Duration check
    guard session.duration >= userThreshold else { return false }
    
    // 2. Interaction ratio (KEY METRIC)
    let interactionRatio = Double(session.interactions) / Double(session.scrollEvents)
    if interactionRatio > 0.1 {  // More than 10% active
        return false  // They're engaging, not doom scrolling
    }
    
    // 3. Scroll velocity check
    if session.scrollVelocity < 50 {  // Slow, deliberate scrolling
        return false
    }
    
    // 4. App switching pattern
    if session.appSwitches > 5 {
        return false  // Context switching = active use
    }
    
    // 5. Time of day multiplier
    let hour = Calendar.current.component(.hour, from: session.timeOfDay)
    var doomMultiplier = 1.0
    if (2...5).contains(hour) {  // 2am-5am
        doomMultiplier = 1.5  // Night scrolling is worse
    }
    
    return true
}
```

#### What Counts as "Active" (NOT Doom Scrolling)
- Posting content
- Writing comments (typing detected)
- Replying to messages
- Creating stories
- Editing content
- Watching full videos (no skipping)
- Frequent app switching
- Reading long-form content (slow scroll)

#### What Counts as "Passive" (IS Doom Scrolling)
- Rapid scrolling through feed
- Skipping videos quickly
- No interactions (just consuming)
- No typing/creating
- Single app focus
- Fast scroll velocity
- Continuous for 25+ minutes

#### Technical Implementation
```swift
// Monitor screen time via DeviceActivity
class DoomScrollDetector: ObservableObject {
    private var currentSession: DoomScrollSession?
    private var scrollEventCount = 0
    private var interactionCount = 0
    
    // Called by ScreenTimeMonitor
    func trackScrollEvent() {
        scrollEventCount += 1
        currentSession?.scrollEvents += 1
    }
    
    // Detect interactions via app-specific events
    func trackInteraction(type: InteractionType) {
        interactionCount += 1
        currentSession?.interactions += 1
    }
    
    // Check every 5 seconds if doom scrolling
    func checkDoomScrollStatus() {
        guard let session = currentSession else { return }
        
        if isDoomScrolling(session) {
            // TRIGGER INTERVENTION
            triggerIntervention(session: session)
        }
    }
}
```

---

### 2. Three Modes (User Choice)

#### Mode 1: Gentle (Default)
**For:** Most users, casual accountability

**Behavior:**
- Shows intervention screen
- Beautiful animation + roast
- One tap to dismiss
- Tracks everything
- No blocking

**Intervention Flow:**
```
1. Screen darkens
2. Spiral animation (hypnotic → breaking)
3. Haptic feedback (3 taps)
4. Show roast/message
5. Quick action buttons
6. One tap dismisses
```

#### Mode 2: Accountability
**For:** People who need more friction

**Behavior:**
- Shows intervention screen
- Must wait 10 seconds before dismiss button appears
- Can only dismiss 3 times per day
- After 3rd ignore → auto-switches to Lockdown for 15 minutes
- Stronger haptics

**Intervention Flow:**
```
1. Same as Gentle
2. BUT: Dismiss button disabled for 10s
3. Progress circle shows countdown
4. After 3 dismissals today:
   "That's 3 ignores. Going to Lockdown mode for 15 min."
5. Switches to Lockdown automatically
```

#### Mode 3: Lockdown
**For:** Nuclear option, opt-in only

**Behavior:**
- Full-screen takeover (can't dismiss easily)
- Must complete quick task to continue
- 60 second wait OR solve challenge
- After completion → 15 min cooldown period
- During cooldown, threshold drops to 10 minutes

**Intervention Flow:**
```
1. Full screen takeover
2. Show doom score + stats
3. Present challenge:
   
   Options:
   a) Wait 60 seconds (progress bar)
   b) Solve math problem: "What's 47 + 28?"
   c) Type phrase: "I will stop doom scrolling"
   d) Watch 30s motivational clip
   
4. Must complete challenge
5. After completion: "15 min cooldown active"
6. Sets threshold to 10 min for next 15 minutes
```

**Mode Settings:**
```swift
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
```

---

### 3. Roast Engine (The Secret Sauce)

**This is what makes the app go viral.**

#### Roast Categories

**Funny/Sarcastic:**
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
    "Blink if you're being held hostage by your feed."
]
```

**Motivational:**
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
]
```

**Reality Checks:**
```swift
let realityChecks = [
    "You've scrolled for 32 minutes. In that time you could've:\n• Finished a workout\n• Called a friend\n• Made dinner\n• Read 2 chapters\n• Taken a walk\n• Actually accomplished something",
    
    "That's 45 minutes. You just:\n• Watched 6 TikToks about productivity\n• Did zero productive things\n• See the irony?",
    
    "1 hour gone. Here's what you missed:\n• The sun (it's still up)\n• Human interaction\n• Physical movement\n• Your goals",
]
```

**Time-Specific:**
```swift
func getTimeSpecificRoast(hour: Int) -> String {
    switch hour {
    case 0...5:
        return "It's \(hour)am. Even your phone wants to sleep."
    case 6...8:
        return "Morning doom scroll? Bold strategy."
    case 12...13:
        return "Lunch break doom scroll. Classic."
    case 22...23:
        return "Pre-bed doom scroll. RIP your sleep schedule."
    default:
        return funnyRoasts.randomElement()!
    }
}
```

**Frequency-Based:**
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
    default:
        return "This is getting ridiculous. Lockdown mode exists for a reason."
    }
}
```

#### Roast Selection Algorithm
```swift
class RoastEngine {
    func selectRoast(context: InterventionContext) -> String {
        // 70% funny, 20% motivational, 10% reality check
        let roll = Int.random(in: 1...10)
        
        var roast: String
        
        if roll <= 7 {
            // Check for special conditions
            if context.interventionsToday >= 3 {
                roast = getFrequencyRoast(interventionsToday: context.interventionsToday)
            } else if (2...5).contains(context.hour) {
                roast = getTimeSpecificRoast(hour: context.hour)
            } else {
                roast = funnyRoasts.randomElement()!
            }
        } else if roll <= 9 {
            roast = motivationalRoasts.randomElement()!
        } else {
            roast = realityChecks.randomElement()!
        }
        
        return roast
    }
}

struct InterventionContext {
    let interventionsToday: Int
    let hour: Int
    let scrollDuration: TimeInterval
    let doomScore: Int
    let currentStreak: Int
}
```

---

### 4. Intervention Screen (The Money Shot)

**This is the most important screen in the app.**

#### Layout
```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│         [Spiral Animation]              │  ← 200x200pt, breaking
│          (Breaking Apart)               │
│                                         │
│                                         │
│        Caught you! 👀                   │  ← 28pt Bold
│                                         │
│    Been scrolling for 28 minutes.      │  ← 17pt Regular
│                                         │
│  "Your thumb is more active than        │  ← Roast message
│   you are."                             │    20pt Medium, Electric Blue
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Worth it - saw good stuff ✓      │  │  ← Quick tap option
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Total waste - help me stop 🛑    │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Just taking a break 😌           │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Want to note what you saw? (Optional) │  ← 15pt, White 70%
│  ┌───────────────────────────────────┐  │
│  │ Type here...                      │  │  ← Optional text input
│  └───────────────────────────────────┘  │
│                                         │
│  [Share this roast] [Dismiss]          │  ← Bottom actions
│                                         │
└─────────────────────────────────────────┘

Background: Spiral Depth gradient (Deep Purple → Neon Purple)
Animation: Spiral breaks as screen appears
Haptics: 3 strong taps on appearance
Sound: Glass shattering (musical)
```

#### Interaction Flow
```swift
struct InterventionView: View {
    @StateObject var viewModel: InterventionViewModel
    @State private var selectedResponse: ResponseType?
    @State private var noteText = ""
    @State private var showingShare = false
    
    var body: some View {
        ZStack {
            // Gradient background
            backgroundGradient
            
            VStack(spacing: 20) {
                // Spiral animation
                SpiralAnimation(state: .breaking)
                    .frame(width: 200, height: 200)
                
                // Header
                Text("Caught you! 👀")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                // Duration
                Text("Been scrolling for \(viewModel.duration.formatted).")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                
                // Roast
                Text(viewModel.roastMessage)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.electricBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Quick response options
                VStack(spacing: 12) {
                    responseButton("Worth it - saw good stuff ✓", type: .worthIt)
                    responseButton("Total waste - help me stop 🛑", type: .waste)
                    responseButton("Just taking a break 😌", type: .justBreak)
                }
                .padding(.horizontal)
                
                // Optional note
                VStack(alignment: .leading, spacing: 8) {
                    Text("Want to note what you saw? (Optional)")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextField("Type here...", text: $noteText)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Bottom actions
                HStack(spacing: 16) {
                    Button("Share this roast") {
                        showingShare = true
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    Button("Dismiss") {
                        dismiss()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(viewModel.mode == .accountability && viewModel.waitTime > 0)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            viewModel.triggerHaptics()
            viewModel.playSound()
            viewModel.startCountdown()  // For accountability mode
        }
        .sheet(isPresented: $showingShare) {
            ShareCardView(roast: viewModel.roastMessage)
        }
    }
    
    func responseButton(_ text: String, type: ResponseType) -> some View {
        Button(action: {
            selectedResponse = type
            viewModel.recordResponse(type, note: noteText)
        }) {
            HStack {
                Text(text)
                    .font(.system(size: 17, weight: .medium))
                Spacer()
                if selectedResponse == type {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(
                selectedResponse == type 
                    ? Color.electricBlue.opacity(0.3)
                    : Color.white.opacity(0.1)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        selectedResponse == type ? Color.electricBlue : Color.clear,
                        lineWidth: 2
                    )
            )
        }
    }
}
```

#### Accountability Mode Countdown
```swift
// In InterventionViewModel
@Published var waitTime: Int = 10  // seconds
private var timer: Timer?

func startCountdown() {
    guard mode == .accountability else { return }
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
        guard let self = self else { return }
        if self.waitTime > 0 {
            self.waitTime -= 1
        } else {
            self.timer?.invalidate()
        }
    }
}

// UI shows:
"Dismiss available in \(waitTime)s"
[Progress circle showing countdown]
```

---

### 5. Doom Score System

**The daily rating that makes stats instantly understandable.**

#### Calculation
```swift
func calculateDoomScore(for date: Date) -> Int {
    let sessions = fetchSessions(for: date)
    
    var score = 0
    
    // Factor 1: Total doom scroll time (0-4 points)
    let totalDoomTime = sessions.reduce(0) { $0 + $1.duration }
    switch totalDoomTime {
    case 0..<900:        score += 0  // < 15 min
    case 900..<1800:     score += 1  // 15-30 min
    case 1800..<3600:    score += 2  // 30-60 min
    case 3600..<7200:    score += 3  // 1-2 hours
    default:             score += 4  // 2+ hours
    }
    
    // Factor 2: Number of interventions (0-3 points)
    let interventionCount = sessions.filter { $0.wasInterrupted }.count
    score += min(interventionCount, 3)
    
    // Factor 3: Ignored interventions (0-2 points)
    let ignoredCount = sessions.filter { $0.wasIgnored }.count
    score += min(ignoredCount, 2)
    
    // Factor 4: Time of day multiplier
    let lateNightSessions = sessions.filter { session in
        let hour = Calendar.current.component(.hour, from: session.startTime)
        return (0...5).contains(hour)
    }
    if !lateNightSessions.isEmpty {
        score += 1  // Late night doom scrolling is worse
    }
    
    return min(score, 10)  // Cap at 10
}

// Get message based on score
func doomScoreMessage(score: Int) -> String {
    switch score {
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
```

#### Display on Home Screen
```
┌─────────────────────────────────┐
│    Today's Doom Score           │
│                                 │
│         3/10 😌                 │
│                                 │
│    [=========░░░░░░░░░░░]       │
│                                 │
│    Not bad 👍                   │
│                                 │
│    You're doing better than     │
│    67% of Spiral users          │
└─────────────────────────────────┘
```

---

### 6. Stats & Gamification

#### Home Screen Layout
```
┌─────────────────────────────────────────┐
│ SPIRAL              [Stats] [Settings]  │
├─────────────────────────────────────────┤
│                                         │
│          [Spiral Animation]             │
│           (Breathing state)             │
│          150x150pt circle               │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │     Today's Doom Score: 3/10      │  │
│  │     [Progress bar]                │  │
│  │     Not bad 👍                    │  │
│  │                                   │  │
│  │     Better than 67% of users      │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Current Streak: 7 days 🔥        │  │
│  │  Longest Streak: 14 days          │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Quick Stats                      │  │
│  │  • Interventions today: 2         │  │
│  │  • Time saved: 1h 34m             │  │
│  │  • Top 15% of users 🎯            │  │
│  └───────────────────────────────────┘  │
│                                         │
│  [View Full Stats]                      │
│                                         │
└─────────────────────────────────────────┘
```

#### Stats View (Detailed)
```
┌─────────────────────────────────────────┐
│ ← Stats                       [Share]   │
├─────────────────────────────────────────┤
│                                         │
│  [7D] [30D] [3M] [1Y]                  │  ← Time range selector
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Time Saved This Week             │  │
│  │                                   │  │
│  │       4h 23m                      │  │
│  │                                   │  │
│  │  That's like...                   │  │
│  │  🎬 2 movies                       │  │
│  │  📺 6 TV episodes                  │  │
│  │  📚 8 chapters                     │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Doom Score Trend                 │  │
│  │                                   │  │
│  │  [Line chart]                     │  │
│  │      ╱╲                           │  │
│  │     ╱  ╲  ╱╲                      │  │
│  │  ──╱    ╲╱  ╲────                 │  │
│  │  M  T  W  T  F  S  S              │  │
│  │                                   │  │
│  │  Average: 4/10 (improving! 📈)    │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌─────────────────┬─────────────────┐  │
│  │ Interventions   │ Successful      │  │
│  │                 │ Breaks          │  │
│  │      23         │      18         │  │
│  │  ↓ 30% vs last  │  ↑ 12% vs last  │  │
│  └─────────────────┴─────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Most Doom Scrolled Apps          │  │
│  │                                   │  │
│  │  Instagram        8h 24m   ████   │  │
│  │  TikTok          6h 12m   ███     │  │
│  │  Twitter         2h 5m    █       │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  You're in the top 15% 🎯         │  │
│  │                                   │  │
│  │  85% of users doom scroll more    │  │
│  │  Keep it up!                      │  │
│  └───────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

#### Achievements System
```swift
enum Achievement: String, CaseIterable {
    // Real achievements
    case touchGrass = "Touch Grass"
    case weekWarrior = "Week Warrior"
    case reformed = "Reformed"
    case topTen = "Top 10%"
    case monthClean = "Month Clean"
    case streakMaster = "Streak Master"
    
    // Sarcastic achievements
    case doomLord = "Doom Lord"
    case nightOwl = "Night Owl"
    case serialScroller = "Serial Scroller"
    case addict = "Addict"
    case ignorant = "Ignorant"
    
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
```

#### Achievement Unlock Screen
```
┌─────────────────────────────────────────┐
│                                         │
│          🏆                             │
│                                         │
│    ACHIEVEMENT UNLOCKED                 │
│                                         │
│       Week Warrior 🔥                   │
│                                         │
│   7 consecutive days without            │
│   doom scrolling                        │
│                                         │
│   You're in the top 12% of users!       │
│                                         │
│  [Share] [Cool, thanks]                 │
│                                         │
└─────────────────────────────────────────┘

Animation: Confetti falling, success sound
Haptic: Success pattern
Auto-dismiss after 5 seconds if not interacted with
```

---

### 7. Share System (Viral Engine)

**This is how the app spreads organically.**

#### Share Card Types

**1. Roast Card**
```swift
struct RoastShareCard {
    let roast: String
    let timestamp: Date
    
    func generate() -> UIImage {
        // 1080x1080 for Instagram
        let size = CGSize(width: 1080, height: 1080)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            // Draw gradient background
            let gradient = CGGradient(...)
            context.cgContext.drawLinearGradient(...)
            
            // Draw spiral logo (small, top right)
            // Draw roast text (centered, large)
            // Draw "Get Spiral" footer
            // Draw App Store badge (optional)
        }
    }
}
```

**Example Output:**
```
┌─────────────────────────────────┐
│ 🌀                    SPIRAL    │
│                                 │
│                                 │
│    "Your thumb is more active   │
│     than you are."              │
│                                 │
│                                 │
│  Break the spiral. Touch grass. │
│                                 │
│  [App Store Badge]              │
└─────────────────────────────────┘
```

**2. Achievement Card**
```
┌─────────────────────────────────┐
│                                 │
│         🏆                      │
│                                 │
│   ACHIEVEMENT UNLOCKED          │
│                                 │
│     Week Warrior 🔥             │
│                                 │
│  7 days without doom scrolling  │
│                                 │
│  ─────────────────────          │
│                                 │
│  Powered by Spiral 🌀           │
│  Get it on the App Store        │
└─────────────────────────────────┘
```

**3. Stats Card**
```
┌─────────────────────────────────┐
│      MY SPIRAL STATS            │
│                                 │
│  This Week:                     │
│                                 │
│  ⏰ Time saved:    4h 23m        │
│  🔥 Streak:        7 days        │
│  📊 Doom Score:    3/10          │
│  🎯 Rank:          Top 15%       │
│                                 │
│  ─────────────────────          │
│                                 │
│  I'm breaking the spiral 🌀     │
│  Get Spiral on iOS              │
└─────────────────────────────────┘
```

**4. Weekly Recap Card**
```
┌─────────────────────────────────┐
│     THIS WEEK ON SPIRAL         │
│                                 │
│  Monday:    2/10 ✨             │
│  Tuesday:   4/10 😌             │
│  Wednesday: 3/10 👍             │
│  Thursday:  2/10 ✨             │
│  Friday:    5/10 😬             │
│  Saturday:  3/10 👍             │
│  Sunday:    1/10 🎉             │
│                                 │
│  Average: 3/10 (Not bad!)       │
│                                 │
│  Powered by Spiral 🌀           │
└─────────────────────────────────┘
```

**5. Before/After Card**
```
┌─────────────────────────────────┐
│     MY TRANSFORMATION           │
│                                 │
│  📱 BEFORE SPIRAL               │
│  42 hours/week scrolling 😱     │
│  Feeling: Exhausted             │
│  Doom Score: 8/10               │
│                                 │
│         ↓↓↓                     │
│                                 │
│  🌱 AFTER SPIRAL                │
│  12 hours/week scrolling 🎉     │
│  Feeling: Actually alive        │
│  Doom Score: 3/10               │
│                                 │
│  ─────────────────────          │
│  Download Spiral                │
│  Break the doom scroll          │
└─────────────────────────────────┘
```

#### Share Flow
```swift
class ShareViewModel: ObservableObject {
    func shareRoast(_ roast: String) {
        // Generate card
        let card = RoastShareCard(roast: roast, timestamp: Date())
        let image = card.generate()
        
        // Pre-written share text options (random)
        let shareTexts = [
            "Spiral just called me out 💀",
            "This app roasted me and I deserved it",
            "Getting my life together with @SpiralApp 🌀",
            "POV: Your phone calls you out",
            "Caught doom scrolling by Spiral 😅"
        ]
        let shareText = shareTexts.randomElement()!
        
        // Present share sheet
        let items: [Any] = [shareText, image]
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        // Track share locally (for achievements)
        trackShare(type: .roast)
        
        // Present
        UIApplication.shared.windows.first?.rootViewController?
            .present(activityVC, animated: true)
    }
    
    private func trackShare(type: ShareType) {
        shareCount += 1
        
        // Check for achievements
        if shareCount == 1 {
            unlockAchievement(.firstShare)
        }
        if shareCount == 10 {
            unlockAchievement(.influencer)
        }
    }
}
```

#### Share Triggers (When to Prompt)
```swift
enum ShareTrigger {
    case funnyRoast          // After particularly funny roast
    case achievement         // After unlocking achievement
    case weeklyRecap         // Sunday evening
    case milestone           // Big improvement
    case goodDoomScore       // Score < 3
    case badDoomScore        // Score > 8 (funny self-deprecation)
    case streakMilestone     // 7, 14, 30, 100 days
    
    var promptMessage: String {
        switch self {
        case .funnyRoast:
            return "This roast is fire. Share it?"
        case .achievement:
            return "Show off your achievement?"
        case .weeklyRecap:
            return "Pretty good week. Want to share?"
        case .milestone:
            return "That's huge progress. Flex on your friends?"
        case .goodDoomScore:
            return "3/10 this week. You're crushing it."
        case .badDoomScore:
            return "9/10... maybe share this as a warning?"
        case .streakMilestone:
            return "Hell yeah. Share your streak?"
        }
    }
}
```

#### Share Settings
```
┌─────────────────────────────────┐
│  Sharing                        │
│  ───────────────                │
│                                 │
│  Share Prompts          [●]     │
│  Show after achievements        │
│                                 │
│  Include Stats          [●]     │
│  On share cards                 │
│                                 │
│  Watermark              [●]     │
│  "Powered by Spiral"            │
│                                 │
│  Card Style                     │
│  Dark Mode (Default)       >    │
│                                 │
└─────────────────────────────────┘
```

---

### 8. Additional Features

#### "Before You Go" Warning
```swift
// Monitor app launches
class AppLaunchMonitor: ObservableObject {
    func appWillLaunch(_ bundleId: String) {
        guard monitoredApps.contains(bundleId) else { return }
        
        let opensToday = getOpensToday(bundleId)
        
        if opensToday >= 10 {
            showBeforeYouGoScreen(opens: opensToday)
        }
    }
}
```

**Screen:**
```
┌─────────────────────────────────┐
│                                 │
│       Before you go... 🤔       │
│                                 │
│  You've opened Instagram        │
│  14 times today already.        │
│                                 │
│  Still want to?                 │
│                                 │
│  [Yeah, I'm bored]              │
│  [Nah, thanks]                  │
│                                 │
└─────────────────────────────────┘

Appears for 3 seconds before app opens
Can be dismissed or waited out
Just adds friction, doesn't block
```

#### Reality Check Mode
```
You've scrolled for 32 minutes.

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

#### Home Screen Widget
```
┌────────────────────┐
│    SPIRAL 🌀       │
│                    │
│  Clean streak:     │
│     5 hours        │
│                    │
│  Today: 2/10 ✨    │
└────────────────────┘

Small widget, updates every 15 min
Shows current streak or doom score
Tapping opens app to home screen
```

#### App Icon Variants
```swift
// App icon changes based on performance
enum AppIconState {
    case clean      // Clean spiral (doing great)
    case warning    // Twisted spiral (doom scrolling detected)
    case critical   // Broken spiral (need intervention)
    
    func updateIcon() {
        if #available(iOS 16.0, *) {
            UIApplication.shared.setAlternateIconName(iconName)
        }
    }
}
```

Icons update:
- Clean: Doom score < 4
- Warning: Doom score 5-7
- Critical: Doom score 8+

User sees status on home screen.

#### Easter Eggs

**1. Triple Tap Spiral**
```swift
// On home screen
.onTapGesture(count: 3) {
    showSecretAnimation()
    // Spiral does a special dance
    // Message: "You found the secret! 🎉"
}
```

**2. Shake Phone During Intervention**
```swift
// In intervention view
.onShake {
    showFunnyMessage()
    // "Shaking won't help. Nice try though."
}
```

**3. Developer Mode**
```swift
// Shake phone 10 times on home screen
if shakeCount >= 10 {
    unlockDeveloperMode()
    // Shows:
    // - Total lines of code
    // - Number of bugs fixed
    // - Developer message
    // - Behind-the-scenes animation tests
}
```

---

### 9. Settings

```
┌─────────────────────────────────────────┐
│ ← Settings                              │
├─────────────────────────────────────────┤
│                                         │
│  Detection                              │
│  ───────────────────────────────────    │
│                                         │
│  Mode                                   │
│  Gentle 😌                          >   │
│                                         │
│  Time Threshold                         │
│  25 minutes                         >   │
│  (Range: 15-60 min)                     │
│                                         │
│  Monitored Apps                         │
│  6 apps                             >   │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Feedback                               │
│  ───────────────────────────────────    │
│                                         │
│  Sound                              [●] │
│  Haptics                            [●] │
│  Haptics Intensity                  >   │
│  (Light / Medium / Strong)              │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Notifications                          │
│  ───────────────────────────────────    │
│                                         │
│  Daily Reminders                    [●] │
│  Weekly Recap                       [●] │
│  Achievement Alerts                 [●] │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Sharing                                │
│  ───────────────────────────────────    │
│                                         │
│  Share Prompts                      [●] │
│  Include Stats on Cards             [●] │
│  Card Style                         >   │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Customization                          │
│  ───────────────────────────────────    │
│                                         │
│  Roast Style                        >   │
│  (Funny / Motivational / Brutal)        │
│                                         │
│  App Icon                           >   │
│  (Default / Minimal / Dark)             │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Privacy                                │
│  ───────────────────────────────────    │
│                                         │
│  All Data Stored Locally            ✓   │
│  No Cloud Sync                      ✓   │
│  No Tracking                        ✓   │
│                                         │
│  View Privacy Policy                >   │
│  Delete All Data                    >   │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  About                                  │
│  ───────────────────────────────────    │
│                                         │
│  Version 1.0.0                          │
│  Made with 🌀 by [Your Name]            │
│                                         │
│  Rate on App Store                  >   │
│  Share Feedback                     >   │
│  Follow @SpiralApp                  >   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 10. Onboarding (Fast & Funny)

**3 screens max. Get them in the app FAST.**

#### Screen 1: Welcome
```
┌─────────────────────────────────┐
│                                 │
│                                 │
│            SPIRAL               │
│             🌀                  │
│                                 │
│    Break the spiral.            │
│    Touch grass.                 │
│                                 │
│                                 │
│    [Let's go]                   │
│                                 │
│                                 │
└─────────────────────────────────┘
```

#### Screen 2: How It Works
```
┌─────────────────────────────────┐
│                                 │
│        How It Works             │
│                                 │
│  📊 We detect doom scrolling    │
│     (You know the kind)         │
│                                 │
│  🌀 We intervene with humor     │
│     (Not judgment)              │
│                                 │
│  📈 You scroll less, live more  │
│     (The goal)                  │
│                                 │
│    [Continue]                   │
│                                 │
└─────────────────────────────────┘
```

#### Screen 3: Permissions + Mode
```
┌─────────────────────────────────┐
│                                 │
│    Last Step: Permissions       │
│                                 │
│  We need Screen Time access to  │
│  detect doom scrolling.         │
│                                 │
│  Your data never leaves your    │
│  device. Promise. 🤝            │
│                                 │
│  [Grant Permission]             │
│                                 │
│  ───────────────                │
│                                 │
│  Choose Your Mode:              │
│                                 │
│  ○ Gentle 😌                    │
│    Soft reminder                │
│                                 │
│  ● Accountability 💪 (Default)  │
│    10s wait, limited ignores    │
│                                 │
│  ○ Lockdown 🔒                  │
│    Complete task to continue    │
│                                 │
│  [Start Using Spiral]           │
│                                 │
└─────────────────────────────────┘
```

**Total onboarding time: < 60 seconds**

---

## 🎨 Visual Design System

### Colors (Exact Hex Values)
```swift
extension Color {
    // Primary
    static let deepPurple = Color(hex: "1A0B2E")
    static let electricBlue = Color(hex: "00D9FF")
    static let neonPurple = Color(hex: "7B2CBF")
    
    // Alert
    static let warningOrange = Color(hex: "FF6B35")
    static let alertRed = Color(hex: "E63946")
    
    // Success
    static let successGreen = Color(hex: "10B981")
    
    // Neutral
    static let pureBlack = Color(hex: "000000")
    static let pureWhite = Color(hex: "FFFFFF")
    static let softGray = Color(hex: "F8F9FA")
}
```

### Gradients
```swift
// Spiral Depth (Main background)
let spiralDepth = LinearGradient(
    colors: [.deepPurple, .neonPurple],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

// Electric Flow (Buttons, accents)
let electricFlow = LinearGradient(
    colors: [.electricBlue, .neonPurple],
    startPoint: .leading,
    endPoint: .trailing
)

// Warning Cascade (Alerts)
let warningCascade = LinearGradient(
    colors: [.warningOrange, .alertRed],
    startPoint: .leading,
    endPoint: .trailing
)
```

### Typography
```swift
// Display (App title, major headlines)
Font.system(size: 48, weight: .bold)

// Title 1 (Screen titles)
Font.system(size: 34, weight: .semibold)

// Title 2 (Section headers)
Font.system(size: 28, weight: .semibold)

// Body (Primary text)
Font.system(size: 17, weight: .regular)

// Callout (Buttons, emphasis)
Font.system(size: 16, weight: .medium)

// Caption (Metadata, timestamps)
Font.system(size: 13, weight: .medium)
```

### Spacing System (8pt Grid)
```swift
enum Spacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 16
    static let l: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}
```

### Corner Radius
```swift
enum CornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 24
}
```

---

## 🎬 Animation Specifications

### Spiral Animation States

**1. Idle/Breathing (Home Screen)**
```swift
struct SpiralBreathingAnimation: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        SpiralShape()
            .stroke(electricFlow, lineWidth: 8)
            .frame(width: 150, height: 150)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    .linear(duration: 30)
                    .repeatForever(autoreverses: false)
                ) {
                    rotation = 360
                }
                
                withAnimation(
                    .easeInOut(duration: 4)
                    .repeatForever(autoreverses: true)
                ) {
                    scale = 1.05
                }
            }
    }
}
```

**2. Hypnotic (Detection in Progress)**
```swift
// Rapid rotation + color shift
withAnimation(.linear(duration: 2).repeatForever()) {
    rotation += 360
}

withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
    colorPhase += 1  // Shift between blue and purple
}
```

**3. Breaking (Intervention Triggered)**
```swift
struct SpiralBreakingAnimation: View {
    @State private var isBreaking = false
    @State private var fragments: [Fragment] = []
    
    func breakSpiral() {
        // Generate 12 fragments
        fragments = (0..<12).map { i in
            Fragment(
                angle: Double(i) * 30,
                distance: 0,
                opacity: 1.0,
                rotation: 0
            )
        }
        
        // Animate breaking
        withAnimation(.easeOut(duration: 0.8)) {
            for i in 0..<fragments.count {
                fragments[i].distance = 200  // Fly outward
                fragments[i].opacity = 0     // Fade out
                fragments[i].rotation = Double.random(in: -180...180)
            }
        }
        
        // Trigger haptics
        HapticsManager.shared.playInterventionPattern()
        
        // Play sound
        SoundManager.shared.play(.break)
    }
}
```

**4. Reformed (Success)**
```swift
// Reverse of breaking
func reformSpiral() {
    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
        for i in 0..<fragments.count {
            fragments[i].distance = 0
            fragments[i].opacity = 1.0
            fragments[i].rotation = 0
        }
    }
    
    // Color shift to green
    withAnimation(.easeInOut(duration: 0.3).delay(0.5)) {
        spiralColor = .successGreen
    }
    
    // Success pulse
    withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.7)) {
        scale = 1.15
    }
    withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.9)) {
        scale = 1.0
    }
}
```

---

## 🔊 Sound Design

### Required Sounds

**1. Intervention Sound** (`intervention.mp3`)
- Duration: 1.5 seconds
- Style: Glass shattering but musical (not jarring)
- Volume: Adjustable in settings
- Plays when intervention triggers

**2. Success Sound** (`success.mp3`)
- Duration: 1 second
- Style: Positive chime, rewarding
- Plays on achievement unlock
- Plays when spiral reforms

**3. Break Sound** (`break.mp3`)
- Duration: 0.8 seconds
- Style: Synchronized with spiral breaking
- Subtle but satisfying

**4. Achievement Sound** (`achievement.mp3`)
- Duration: 1 second
- Style: Celebration chime
- Plays on achievement unlock

### Sound Manager
```swift
class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    private var players: [SoundType: AVAudioPlayer] = [:]
    
    enum SoundType: String {
        case intervention
        case success
        case `break`
        case achievement
    }
    
    func play(_ sound: SoundType) {
        guard UserDefaults.standard.bool(forKey: "soundEnabled") else { return }
        
        players[sound]?.play()
    }
    
    func setVolume(_ volume: Float) {
        players.values.forEach { $0.volume = volume }
    }
}
```

---

## 📳 Haptics Design

### Haptic Patterns

**Gentle Mode:**
```swift
func playGentlePattern() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.warning)
}
```

**Accountability Mode:**
```swift
func playAccountabilityPattern() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    generator.impactOccurred()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        generator.impactOccurred()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        generator.impactOccurred()
    }
}
```

**Lockdown Mode:**
```swift
func playLockdownPattern() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    // Continuous buzz
    for i in 0..<5 {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
            generator.impactOccurred(intensity: 1.0)
        }
    }
}
```

**Success Pattern:**
```swift
func playSuccessPattern() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}
```

---

## 🗂️ Data Models (Complete)

### AppSettings
```swift
import SwiftData

@Model
class AppSettings {
    var id: UUID
    var interventionMode: InterventionMode
    var timeThreshold: TimeInterval  // Default: 1500 (25 min)
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
        timeThreshold: TimeInterval = 1500,  // 25 minutes
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
    
    enum InterventionMode: String, Codable {
        case gentle, accountability, lockdown
    }
    
    enum HapticsIntensity: String, Codable {
        case light, medium, strong
    }
    
    enum RoastStyle: String, Codable {
        case funny, motivational, brutal, mixed
    }
    
    enum AppIconStyle: String, Codable {
        case `default`, minimal, dark
    }
}
```

### ScrollSession
```swift
@Model
class ScrollSession {
    var id: UUID
    var startTime: Date
    var endTime: Date?
    var appName: String
    var duration: TimeInterval
    var scrollEvents: Int
    var interactions: Int
    var appSwitches: Int
    var averageScrollVelocity: Double
    var wasInterrupted: Bool
    var wasIgnored: Bool
    var userResponse: ResponseType?
    var userNote: String?
    var roastMessage: String?
    var interventionMode: AppSettings.InterventionMode
    
    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        appName: String,
        duration: TimeInterval = 0,
        scrollEvents: Int = 0,
        interactions: Int = 0,
        appSwitches: Int = 0,
        averageScrollVelocity: Double = 0,
        wasInterrupted: Bool = false,
        wasIgnored: Bool = false,
        userResponse: ResponseType? = nil,
        userNote: String? = nil,
        roastMessage: String? = nil,
        interventionMode: AppSettings.InterventionMode = .gentle
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.appName = appName
        self.duration = duration
        self.scrollEvents = scrollEvents
        self.interactions = interactions
        self.appSwitches = appSwitches
        self.averageScrollVelocity = averageScrollVelocity
        self.wasInterrupted = wasInterrupted
        self.wasIgnored = wasIgnored
        self.userResponse = userResponse
        self.userNote = userNote
        self.roastMessage = roastMessage
        self.interventionMode = interventionMode
    }
    
    enum ResponseType: String, Codable {
        case worthIt
        case waste
        case justBreak
        case dismissed
    }
    
    var isActiveDoomScrolling: Bool {
        let interactionRatio = Double(interactions) / max(Double(scrollEvents), 1.0)
        return interactionRatio < 0.1 && averageScrollVelocity > 50
    }
}
```

### UserStats
```swift
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
    var timeSaved: TimeInterval  // vs previous week average
    var percentileRank: Int  // 0-100
    
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
}
```

### Achievement
```swift
@Model
class UserAchievement {
    var id: UUID
    var achievement: Achievement
    var unlockedAt: Date
    var wasShared: Bool
    
    init(
        id: UUID = UUID(),
        achievement: Achievement,
        unlockedAt: Date = Date(),
        wasShared: Bool = false
    ) {
        self.id = id
        self.achievement = achievement
        self.unlockedAt = unlockedAt
        self.wasShared = wasShared
    }
}

// Achievement enum defined earlier in spec
```

---

## 🚀 Implementation Phases

### Phase 1: MVP Core (Weeks 1-2)
**Goal:** Working detection and intervention

**Tasks:**
- [ ] Xcode project setup
- [ ] Data models (AppSettings, ScrollSession, UserStats)
- [ ] Screen Time API integration
- [ ] Basic doom scroll detection (time-based only)
- [ ] Intervention view with roasts
- [ ] Three modes (Gentle, Accountability, Lockdown)
- [ ] Home screen with doom score
- [ ] Settings view
- [ ] Onboarding flow (3 screens)
- [ ] Basic spiral animation (breathing, breaking)

**Deliverable:** App that detects doom scrolling and shows funny intervention

---

### Phase 2: Polish & Gamification (Week 3)
**Goal:** Beautiful, engaging experience

**Tasks:**
- [ ] Perfect spiral animations (all states)
- [ ] Custom haptics for each mode
- [ ] Sound integration
- [ ] Achievement system
- [ ] Stats view with charts
- [ ] Doom score calculation
- [ ] Percentile ranking
- [ ] Time saved calculations
- [ ] App icon (3 variants)
- [ ] Easter eggs

**Deliverable:** Polished app ready for beta

---

### Phase 3: Sharing & Viral Features (Week 4)
**Goal:** Make it shareable

**Tasks:**
- [ ] Share card generator
- [ ] All share card types (roast, achievement, stats, etc.)
- [ ] Share triggers and prompts
- [ ] Platform-specific optimizations
- [ ] Weekly recap automation
- [ ] "Before you go" screen
- [ ] Home screen widget
- [ ] App icon state changes
- [ ] Trending roasts feature

**Deliverable:** Viral-ready app

---

### Phase 4: Advanced Detection & Testing (Week 5)
**Goal:** Smart detection and stability

**Tasks:**
- [ ] Active vs passive detection (THE KEY FEATURE)
- [ ] Scroll velocity tracking
- [ ] Interaction detection
- [ ] App switching patterns
- [ ] Battery optimization
- [ ] Performance profiling
- [ ] Extensive testing on device
- [ ] Bug fixes
- [ ] Accessibility (VoiceOver, Dynamic Type)

**Deliverable:** Production-ready app

---

### Phase 5: Launch Prep (Week 6)
**Goal:** App Store submission

**Tasks:**
- [ ] App Store screenshots (all sizes)
- [ ] Preview video (15-30s)
- [ ] App Store description (optimized)
- [ ] Keywords research
- [ ] Privacy policy
- [ ] Support page
- [ ] TestFlight beta (friends/family)
- [ ] Beta feedback integration
- [ ] Final bug fixes
- [ ] Submit for review

**Deliverable:** Live on App Store!

---

## 🎯 Success Metrics

### Technical
- Zero crashes
- < 1 second app launch
- 60fps animations always
- < 5% battery drain during monitoring
- Active vs passive detection accuracy > 85%

### User Experience
- Onboarding completion rate > 90%
- Daily active users retention > 50% (Day 7)
- Intervention response rate > 70%
- Average doom score improvement > 30% (Week 2 vs Week 1)

### Virality
- Share rate > 10% of users
- App Store rating > 4.5 stars
- Organic download growth week-over-week
- Social media mentions tracking

### Business
- 10,000 downloads in first month
- 50% Day 7 retention
- 25% Day 30 retention
- Featured by tech blogs

---

## 🚨 Critical Requirements (NEVER FORGET)

### 1. Privacy First
- **100% on-device** - NO cloud, NO server, NO exceptions
- No analytics or telemetry
- No user accounts
- Clear privacy policy
- User can delete all data anytime

### 2. Active vs Passive Detection
- **This makes or breaks the app**
- Must be accurate (> 85%)
- Test extensively with real usage
- Adjust thresholds based on data
- Never interrupt productive use

### 3. Performance
- Animations must be 60fps (no compromises)
- Launch time < 1 second
- Battery efficient monitoring
- No memory leaks
- Profile regularly

### 4. Humor Done Right
- Funny but not mean
- Self-aware and meta
- Gen Z friendly but not cringe
- Helpful underneath
- Never shame the user

### 5. App Store Compliance
- Clear Screen Time usage explanation
- Privacy labels accurate (all "None")
- Demo video for reviewers
- Prepare for rejection (may need revision)
- Patience during review

---

## 📞 Development Resources

### Apple Documentation
- [FamilyControls](https://developer.apple.com/documentation/familycontrols)
- [DeviceActivity](https://developer.apple.com/documentation/deviceactivity)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [SwiftData](https://developer.apple.com/xcode/swiftdata/)

### Design Inspiration
- Duolingo (gamification)
- Clear (gesture-driven UX)
- Forest (screen time with character)
- BeReal (social prompts)

### Testing Tools
- TestFlight (beta distribution)
- Instruments (performance profiling)
- Xcode Previews (UI iteration)
- Physical iPhone (required for Screen Time)

---

## 🎬 Let's Build This!

**This spec contains everything needed to build Spiral V2:**
- Complete feature set
- Exact UI layouts
- All roast messages
- Technical implementation details
- Data models with Swift code
- Animation specifications
- Sound and haptics design
- Sharing system
- Go-to-market strategy

**Next Steps:**
1. Read SPIRAL_V2_QUICK_START.md for immediate actions
2. Reference SPIRAL_V2_UI_MOCKUPS.md while building UI
3. Use SPIRAL_V2_COPY_GUIDE.md for all text content
4. Follow SPIRAL_V2_SHARING_SYSTEM.md for viral features

**Remember the mission:**
- Make it funny
- Make it beautiful
- Make it work
- Make it private
- Make it shareable

**Let's break some spirals.** 🌀🔥

---

**Document Version:** 2.0  
**Last Updated:** November 2025  
**Status:** Ready for Development
