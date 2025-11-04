# Spiral V2 - Claude Code Quick Start

## 🚀 Start Building NOW

This is your Day 1-5 roadmap with V2 features. Everything is prioritized for maximum impact.

---

## 📋 Pre-Flight Checklist

- [ ] macOS Ventura+ with Xcode 15.0+
- [ ] Physical iPhone with iOS 16+ (Screen Time requires real device)
- [ ] Apple Developer account
- [ ] Read SPIRAL_V2_PROJECT_SPEC.md (skim it)
- [ ] Ready to build something viral

---

## ⚡ Day 1: Core Setup & Detection

### Morning: Project Setup (2 hours)

**1. Create Xcode Project**
```
File > New > Project > iOS > App
- Name: Spiral
- Interface: SwiftUI
- Storage: SwiftData
- Minimum: iOS 16.0
```

**2. Add Capabilities**
```
Signing & Capabilities:
+ Family Controls
+ Background Modes > Background fetch
```

**3. Update Info.plist**
```xml
<key>NSFamilyControlsUsageDescription</key>
<string>Spiral detects doom scrolling to help you break the cycle. All data stays on your device.</string>
```

**4. Create File Structure**
```
Spiral/
├── App/SpiralApp.swift
├── Models/
│   ├── AppSettings.swift
│   ├── ScrollSession.swift
│   └── UserStats.swift
├── Views/
│   ├── HomeView.swift
│   ├── InterventionView.swift
│   └── OnboardingView.swift
├── ViewModels/
│   ├── ScrollDetectionViewModel.swift
│   └── InterventionViewModel.swift
├── Services/
│   ├── ScreenTimeMonitor.swift
│   ├── DoomScrollDetector.swift
│   └── RoastEngine.swift
└── Utilities/
    ├── Constants.swift
    └── RoastLibrary.swift
```

### Afternoon: Data Models (3 hours)

**Copy-paste from SPIRAL_V2_PROJECT_SPEC.md:**
- AppSettings model (with 3 modes: gentle, accountability, lockdown)
- ScrollSession model (with active/passive tracking)
- UserStats model (with doom score)
- Constants.swift (25 min default threshold)

**Key Changes from V1:**
```swift
// NEW: 25 minutes default (not 60)
static let defaultTimeThreshold: TimeInterval = 1500

// NEW: Three modes
enum InterventionMode {
    case gentle, accountability, lockdown
}

// NEW: Active vs passive tracking
var interactions: Int  // likes, comments, posts
var scrollEvents: Int  // scroll gestures
```

### Evening: Roast System (2 hours)

**1. Create RoastLibrary.swift**
```swift
// Copy ALL roasts from SPIRAL_V2_COPY_GUIDE.md
struct RoastLibrary {
    static let funny = [/* 30 roasts */]
    static let motivational = [/* 15 roasts */]
    static let realityCheck = [/* 5 roasts */]
}
```

**2. Create RoastEngine.swift**
```swift
class RoastEngine {
    func selectRoast(context: InterventionContext) -> String {
        // 70% funny, 20% motivational, 10% reality check
        let roll = Int.random(in: 1...10)
        
        if roll <= 7 {
            return RoastLibrary.funny.randomElement()!
        } else if roll <= 9 {
            return RoastLibrary.motivational.randomElement()!
        } else {
            return RoastLibrary.realityCheck.randomElement()!
        }
    }
}
```

**✅ End of Day 1: You have project setup + roast system**

---

## ⚡ Day 2: Intervention & Detection

### Morning: Intervention View (3 hours)

**Priority: This is THE money shot of the app.**

```swift
struct InterventionView: View {
    @StateObject var viewModel: InterventionViewModel
    @State private var selectedResponse: ResponseType?
    
    var body: some View {
        ZStack {
            // Spiral Depth gradient background
            LinearGradient(
                colors: [Color("DeepPurple"), Color("NeonPurple")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Spiral animation (placeholder for now)
                Circle()
                    .fill(Color("ElectricBlue"))
                    .frame(width: 200, height: 200)
                
                // Header
                Text("Caught you! 👀")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                // Duration
                Text("Been scrolling for \(viewModel.duration) minutes.")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                
                // Roast
                Text(viewModel.roastMessage)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("ElectricBlue"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Quick response buttons
                VStack(spacing: 12) {
                    responseButton("Worth it - saw good stuff ✓", .worthIt)
                    responseButton("Total waste - help me stop 🛑", .waste)
                    responseButton("Just taking a break 😌", .justBreak)
                }
                
                // Optional note
                TextField("Want to note what you saw? (Optional)", text: $viewModel.note)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                // Bottom actions
                HStack {
                    Button("Share this roast") {
                        // TODO: Phase 3
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Dismiss") {
                        viewModel.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }
}
```

### Afternoon: Screen Time Integration (4 hours)

**THE MOST CRITICAL PART**

```swift
import FamilyControls
import DeviceActivity

class ScreenTimeMonitor: ObservableObject {
    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    
    func requestAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
    }
    
    func startMonitoring() {
        // Set up DeviceActivityMonitor
        // This tracks app usage in real-time
        
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print("Failed to start monitoring: \(error)")
        }
    }
}
```

**NOTE:** Screen Time API is complex. Reference Apple docs heavily. This will take time to get right.

**✅ End of Day 2: Intervention view + basic Screen Time setup**

---

## ⚡ Day 3: Modes & Home Screen

### Morning: Three Modes (3 hours)

**Gentle Mode:** Already done in intervention view above.

**Accountability Mode:**
```swift
class InterventionViewModel: ObservableObject {
    @Published var waitTime: Int = 10  // seconds
    @Published var dismissalsToday: Int = 0
    let maxDismissals = 3
    
    var canDismiss: Bool {
        if mode == .gentle { return true }
        if mode == .accountability {
            return waitTime == 0 && dismissalsToday < maxDismissals
        }
        if mode == .lockdown { return taskCompleted }
        return false
    }
    
    func startCountdown() {
        guard mode == .accountability else { return }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            if self?.waitTime ?? 0 > 0 {
                self?.waitTime -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}

// In InterventionView:
Button("Dismiss") {
    viewModel.dismiss()
}
.disabled(!viewModel.canDismiss)

if viewModel.mode == .accountability && viewModel.waitTime > 0 {
    Text("Dismiss available in \(viewModel.waitTime)s")
}
```

**Lockdown Mode:**
```swift
@State private var lockdownChallenge: String = ""
@State private var userAnswer: String = ""
@State private var taskCompleted = false

// Generate random math problem
let num1 = Int.random(in: 10...50)
let num2 = Int.random(in: 10...50)
lockdownChallenge = "What's \(num1) + \(num2)?"

// Check answer
if Int(userAnswer) == num1 + num2 {
    taskCompleted = true
}
```

### Afternoon: Home Screen with Doom Score (3 hours)

```swift
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var statsVM = StatsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // App title
                    Text("SPIRAL")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color("ElectricBlue"))
                    
                    // Spiral animation (placeholder)
                    Circle()
                        .fill(Color("ElectricBlue"))
                        .frame(width: 150, height: 150)
                    
                    // Doom Score Card
                    VStack {
                        Text("Today's Doom Score")
                        
                        Text("\(statsVM.doomScore)/10")
                            .font(.system(size: 48, weight: .bold))
                        
                        ProgressView(value: Double(statsVM.doomScore), total: 10)
                        
                        Text(statsVM.doomScoreMessage)
                        
                        Text("Better than \(statsVM.percentile)% of users")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color("DeepPurple"))
                    .cornerRadius(16)
                    
                    // Streak Card
                    VStack {
                        Text("Current Streak: \(statsVM.currentStreak) days 🔥")
                        Text("Longest Streak: \(statsVM.longestStreak) days")
                    }
                    .padding()
                    .background(Color("DeepPurple"))
                    .cornerRadius(16)
                    
                    // Quick Stats
                    VStack(alignment: .leading) {
                        Text("Quick Stats")
                            .font(.headline)
                        Text("• Interventions today: \(statsVM.interventionsToday)")
                        Text("• Time saved: \(statsVM.timeSaved)")
                        Text("• Top \(statsVM.percentile)% of users 🎯")
                    }
                    .padding()
                    .background(Color("DeepPurple"))
                    .cornerRadius(16)
                }
                .padding()
            }
            .background(Color.black)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
    }
}
```

### Doom Score Calculation
```swift
func calculateDoomScore(for date: Date) -> Int {
    var score = 0
    
    // Time spent (0-4 points)
    let totalTime = getTotalDoomScrollTime(date)
    switch totalTime {
    case 0..<900: score += 0
    case 900..<1800: score += 1
    case 1800..<3600: score += 2
    case 3600..<7200: score += 3
    default: score += 4
    }
    
    // Interventions (0-3 points)
    score += min(getInterventionCount(date), 3)
    
    // Ignores (0-2 points)
    score += min(getIgnoredCount(date), 2)
    
    // Late night (0-1 points)
    if hasLateNightSessions(date) { score += 1 }
    
    return min(score, 10)
}
```

**✅ End of Day 3: Three modes working + Home screen with doom score**

---

## ⚡ Day 4: Stats & Achievements

### Morning: Stats View (3 hours)

```swift
struct StatsView: View {
    @StateObject var viewModel = StatsViewModel()
    @State private var selectedRange: TimeRange = .week
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Time range picker
                Picker("Range", selection: $selectedRange) {
                    Text("7D").tag(TimeRange.week)
                    Text("30D").tag(TimeRange.month)
                    Text("3M").tag(TimeRange.quarter)
                }
                .pickerStyle(.segmented)
                
                // Time saved card
                VStack {
                    Text("Time Saved This Week")
                    Text("\(viewModel.timeSaved)")
                        .font(.largeTitle)
                    
                    Text("That's like...")
                    ForEach(viewModel.timeSavedComparisons, id: \.self) { comparison in
                        Text(comparison)
                    }
                }
                .cardStyle()
                
                // Doom score trend chart
                // Use Swift Charts framework
                Chart(viewModel.dailyScores) { score in
                    LineMark(
                        x: .value("Day", score.date),
                        y: .value("Score", score.value)
                    )
                }
                .frame(height: 200)
                .cardStyle()
                
                // Intervention stats
                HStack {
                    StatCard(title: "Interventions", value: "\(viewModel.interventions)")
                    StatCard(title: "Successful Breaks", value: "\(viewModel.breaks)")
                }
                
                // App breakdown
                VStack(alignment: .leading) {
                    Text("Most Doom Scrolled Apps")
                    ForEach(viewModel.topApps) { app in
                        HStack {
                            Text(app.name)
                            Spacer()
                            Text(app.duration)
                            ProgressView(value: app.percentage)
                        }
                    }
                }
                .cardStyle()
            }
            .padding()
        }
    }
}
```

### Afternoon: Achievement System (3 hours)

```swift
enum Achievement: String, CaseIterable {
    // Positive
    case touchGrass, weekWarrior, reformed, topTen
    // Sarcastic
    case doomLord, nightOwl, serialScroller
    
    var description: String {
        // Copy from SPIRAL_V2_COPY_GUIDE.md
    }
}

class AchievementManager: ObservableObject {
    @Published var unlockedAchievements: [Achievement] = []
    
    func checkAchievements(stats: UserStats) {
        // Check each achievement condition
        if stats.currentStreak >= 1 && !unlockedAchievements.contains(.touchGrass) {
            unlockAchievement(.touchGrass)
        }
        
        if stats.currentStreak >= 7 && !unlockedAchievements.contains(.weekWarrior) {
            unlockAchievement(.weekWarrior)
        }
        
        // etc...
    }
    
    func unlockAchievement(_ achievement: Achievement) {
        unlockedAchievements.append(achievement)
        showAchievementPopup(achievement)
    }
}
```

**Achievement Popup:**
```swift
struct AchievementPopup: View {
    let achievement: Achievement
    
    var body: some View {
        VStack {
            Text("🏆")
                .font(.system(size: 60))
            Text("ACHIEVEMENT UNLOCKED")
            Text(achievement.displayName)
            Text(achievement.description)
            
            HStack {
                Button("Share") {
                    // TODO: Phase 5
                }
                Button("Cool, thanks") {
                    // Dismiss
                }
            }
        }
        .padding()
        .background(Color("DeepPurple"))
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}
```

**✅ End of Day 4: Full stats view + achievement system**

---

## ⚡ Day 5: Polish & Sharing

### Morning: Animations (3 hours)

**Spiral Animation:**
```swift
struct SpiralShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Golden ratio spiral
        let growthFactor = 1.618
        let rotations = 2.5
        let points = 200
        
        // Draw spiral using polar coordinates
        for i in 0...points {
            let progress = Double(i) / Double(points)
            let angle = rotations * 2 * .pi * progress
            let radius = 10 * pow(CGFloat(growthFactor), CGFloat(angle / .pi))
            
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

// Breathing animation (home screen)
.rotationEffect(.degrees(rotation))
.scaleEffect(scale)
.onAppear {
    withAnimation(.linear(duration: 30).repeatForever()) {
        rotation = 360
    }
    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
        scale = 1.05
    }
}
```

### Afternoon: Share System (4 hours)

**Share Card Generator:**
```swift
class ShareCardGenerator {
    func generateRoastCard(_ roast: String) -> UIImage {
        let size = CGSize(width: 1080, height: 1080)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            // Draw gradient background
            let colors = [
                UIColor(named: "DeepPurple")!.cgColor,
                UIColor(named: "NeonPurple")!.cgColor
            ]
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: [0, 1]
            )!
            
            context.cgContext.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
            
            // Draw logo (top right)
            let logo = UIImage(named: "SpiralLogo")
            logo?.draw(in: CGRect(x: 900, y: 50, width: 130, height: 130))
            
            // Draw roast text (centered)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 48, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let text = roast as NSString
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attributes)
            
            // Draw footer
            let footer = "- Spiral App 🌀" as NSString
            footer.draw(at: CGPoint(x: 400, y: 950), withAttributes: attributes)
        }
    }
}
```

**Share Flow:**
```swift
func shareRoast(_ roast: String) {
    let card = ShareCardGenerator().generateRoastCard(roast)
    let shareText = "Spiral just called me out 💀"
    
    let items: [Any] = [shareText, card]
    let activityVC = UIActivityViewController(
        activityItems: items,
        applicationActivities: nil
    )
    
    // Present
    UIApplication.shared.windows.first?.rootViewController?
        .present(activityVC, animated: true)
}
```

**✅ End of Day 5: Animations + sharing system**

---

## 🧪 Testing Checklist

### On Physical Device (Required)
- [ ] Screen Time permission flow works
- [ ] Doom scroll detection triggers at 25 min
- [ ] All three modes work correctly
- [ ] Animations are smooth (60fps)
- [ ] Haptics fire correctly
- [ ] Sounds play
- [ ] Battery usage acceptable (<5% per hour)

### Functionality
- [ ] Onboarding can be completed
- [ ] Home screen shows correct doom score
- [ ] Intervention triggers with roast
- [ ] Quick responses save correctly
- [ ] Stats calculate accurately
- [ ] Achievements unlock properly
- [ ] Share cards generate correctly

### Edge Cases
- [ ] App survives background/foreground
- [ ] Data persists across app restarts
- [ ] Handles permission denial gracefully
- [ ] No crashes during normal use
- [ ] Memory usage stable

---

## 🚨 Critical Gotchas

1. **Screen Time API only works on physical device** - No simulator support
2. **Active vs passive detection is hard** - Will need iteration
3. **Battery optimization is critical** - Profile early
4. **Animations must be 60fps** - No compromises
5. **Share cards must look amazing** - First impression for virality

---

## 📦 Phase Priorities

**Phase 1 (Days 1-2):** Detection + Intervention → **Must work perfectly**
**Phase 2 (Days 3-4):** Modes + Stats → **Core user value**
**Phase 3 (Day 5):** Polish + Sharing → **Viral potential**

Focus on Phase 1 first. Without good detection, the app is useless.

---

## 🎯 Success Criteria for MVP

- ✅ Detects doom scrolling accurately (>85%)
- ✅ Three modes work as specified
- ✅ Roasts are funny and varied
- ✅ Doom score calculates correctly
- ✅ Sharing works on Instagram/Twitter
- ✅ Zero crashes in normal use
- ✅ Animations are buttery smooth

---

## 🔗 Reference Documents

During development, reference:
- **SPIRAL_V2_PROJECT_SPEC.md** - Full technical details
- **SPIRAL_V2_COPY_GUIDE.md** - All text and roasts
- **SPIRAL_V2_UI_MOCKUPS.md** - Exact layouts
- **SPIRAL_BRANDING_GUIDE.md** - Colors and design

---

**Let's build this! 🌀🔥**

Start with Day 1 tasks. Test on physical device ASAP. Iterate on detection. Make it funny. Make it beautiful. Make it viral.

**Break the spiral. Touch grass. Ship the app.**
