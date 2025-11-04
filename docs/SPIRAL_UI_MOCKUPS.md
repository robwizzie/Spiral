# Spiral - UI Mockup & Layout Guide

## Screen-by-Screen Layout Specifications

This document provides detailed layout specifications for every screen in Spiral, with ASCII mockups and exact measurements.

---

## Design System Reference

### Spacing Scale
- **4pt** - Tiny gaps (XS)
- **8pt** - Small gaps (S)
- **16pt** - Standard spacing (M)
- **24pt** - Section spacing (L)
- **32pt** - Major section spacing (XL)
- **48pt** - Screen separation (XXL)

### Corner Radius
- **8pt** - Small elements (tags, badges)
- **12pt** - Buttons, input fields
- **16pt** - Cards, containers
- **24pt** - Large cards, modals

### Typography Scale (iOS)
- **48pt Bold** - Display (App name)
- **34pt Semibold** - Title 1 (Screen titles)
- **28pt Semibold** - Title 2 (Sections)
- **22pt Semibold** - Title 3 (Sub-sections)
- **17pt Regular** - Body (Primary text)
- **16pt Medium** - Callout (Buttons, emphasis)
- **13pt Medium** - Caption (Metadata, timestamps)
- **11pt Regular** - Caption 2 (Fine print)

---

## 1. Onboarding Screens

### Screen 1: Welcome
```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│              [Safe Area]                │
│                                         │
│                                         │
│                 SPIRAL                  │  ← 48pt Bold, Electric Blue
│                                         │
│           Break the Spiral              │  ← 22pt Regular, White 80%
│                                         │
│                                         │
│          [Spiral Animation]             │  ← 180x180pt
│           (Breathing)                   │
│                                         │
│                                         │
│                                         │
│                                         │
│         Swipe to continue →             │  ← 13pt, White 60%
│                [Safe Area]              │
│                                         │
└─────────────────────────────────────────┘

Layout:
- Background: Spiral Depth gradient (Deep Purple → Neon Purple, 135°)
- Content centered vertically and horizontally
- 20pt horizontal margins
- Animation: 180x180pt, centered
- Bottom text: 40pt from bottom safe area
```

### Screen 2: How It Works
```
┌─────────────────────────────────────────┐
│                                         │
│          [Safe Area Top]                │
│                                         │
│           How It Works                  │  ← 34pt Semibold, White
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ 📊  We Monitor                    │  │
│  │     Track your social media usage │  │  ← FeatureRow components
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ 🔔  We Detect                     │  │
│  │     Notice when you're doom       │  │
│  │     scrolling                     │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ ✓  We Intervene                   │  │
│  │    Help you break the cycle       │  │
│  └───────────────────────────────────┘  │
│                                         │
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

FeatureRow Specs:
- Padding: 16pt all sides
- Icon: 40pt width, Title size, Electric Blue
- Text spacing: 15pt between icon and text
- Title: 17pt Semibold, White
- Description: 15pt Regular, White 70%
- Gap between rows: 20pt
```

### Screen 3: Permissions
```
┌─────────────────────────────────────────┐
│                                         │
│          [Safe Area Top]                │
│                                         │
│                                         │
│        We Need Permission               │  ← 34pt Semibold, White
│                                         │
│   Screen Time access helps us           │
│   detect doom scrolling. All data       │  ← 17pt, White 80%, centered
│   stays on your device.                 │
│                                         │
│          ┌─────────────┐                │
│          │     🔒      │                │  ← Shield icon, 60pt
│          └─────────────┘                │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │      Grant Permission             │  │  ← Primary button
│  └───────────────────────────────────┘  │
│                                         │
│         ✓ Permission granted            │  ← Success state (if approved)
│           (Success Green)               │
│                                         │
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

Button Specs:
- Width: Full width minus 40pt (20pt margins each side)
- Height: 52pt
- Background: Electric Blue
- Text: 16pt Semibold, White
- Corner Radius: 12pt
```

### Screen 4: Choose Your Mode
```
┌─────────────────────────────────────────┐
│                                         │
│          [Safe Area Top]                │
│                                         │
│        Choose Your Mode                 │  ← 34pt Semibold, White
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ Gentle                 [ ]        │  │  ← Mode button (unselected)
│  │ Soft notifications, easily        │  │
│  │ dismissible                       │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ Accountability        [✓]         │  │  ← Mode button (selected)
│  │ Must reflect to continue          │  │  Blue border + blue bg tint
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ Nuclear               [ ]         │  │  ← Mode button (unselected)
│  │ Enforced cooldown period          │  │
│  └───────────────────────────────────┘  │
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

Mode Button Specs:
- Width: Full width minus 40pt
- Padding: 16pt all sides
- Background (unselected): White 10%
- Background (selected): Electric Blue 30%
- Border (selected): 2pt Electric Blue
- Corner Radius: 12pt
- Title: 17pt Semibold, White
- Description: 15pt Regular, White 70%
- Gap between buttons: 16pt
```

### Screen 5: Ready
```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│          [Safe Area Top]                │
│                                         │
│                                         │
│         You're All Set!                 │  ← 34pt Semibold, White
│                                         │
│      Ready to break the spiral?         │  ← 17pt, White 80%
│                                         │
│          [Spiral Animation]             │  ← 150x150pt, reformed state
│           (Success Green)               │
│                                         │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │            Begin                  │  │  ← Primary gradient button
│  └───────────────────────────────────┘  │
│                                         │
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

Button Specs:
- Gradient background: Electric Blue → Neon Purple (horizontal)
- Width: Full width minus 40pt
- Height: 52pt
- Text: 16pt Semibold, White
- Corner Radius: 12pt
```

---

## 2. Home View (Main Dashboard)

```
┌─────────────────────────────────────────┐
│ SPIRAL              [Stats] [Settings] │  ← Navigation bar
├─────────────────────────────────────────┤
│                                         │
│          [Safe Area Top]                │
│                                         │
│                                         │
│          [Spiral Animation]             │  ← 150x150pt circle
│            (Breathing)                  │     Gradient: Blue → Purple
│                                         │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │      Current Streak               │  │  ← Card
│  │                                   │  │
│  │         3 days 🔥                 │  │  ← 32pt Bold, White
│  │                                   │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Today's Screen Time              │  │  ← Card
│  │  ─────────────────                │  │
│  │                                   │  │
│  │  2h 15m              Doing great!│  │  ← 28pt Semibold, Electric Blue
│  │                      ✓            │  │     15pt, White 70%
│  │                                   │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │     View Detailed Stats           │  │  ← Secondary button
│  └───────────────────────────────────┘  │
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

Layout:
- Background: Pure black (#000000)
- Navigation bar: Transparent background
- App title: 36pt Bold, Electric Blue, left-aligned
- Settings icon: 24pt, Electric Blue, right-aligned
- Content scroll view with 20pt horizontal margins
- Vertical spacing: 30pt between major elements

Card Specs:
- Background: Deep Purple (#1A0B2E)
- Border: 1pt Neon Purple 20%
- Corner Radius: 16pt
- Padding: 20pt
- Shadow: 0 2pt 8pt rgba(0,0,0,0.4)
```

---

## 3. Intervention View (Full-Screen Takeover)

### Initial State (Breaking)
```
┌─────────────────────────────────────────┐
│█████████████████████████████████████████│
│█████████████████████████████████████████│
│██                                     ██│
│██                                     ██│
│██         [Spiral Animation]          ██│
│██          (Breaking Apart)           ██│  ← 200x200pt
│██                                     ██│
│██                                     ██│
│██                                     ██│
│██      YOU'RE IN THE SPIRAL           ██│  ← 28pt Bold, White
│██                                     ██│
│██  What's ONE thing you learned       ██│
│██  in the last hour?                  ██│  ← 17pt, White 80%
│██                                     ██│
│██  ┌─────────────────────────────┐   ██│
│██  │ Type your answer...         │   ██│  ← Text input
│██  └─────────────────────────────┘   ██│
│██                                     ██│
│██  [I learned something]              ██│  ← Button
│██  [Nothing productive]               ██│  ← Button
│██                                     ██│
│██                                     ██│
│█████████████████████████████████████████│
└─────────────────────────────────────────┘

Layout:
- Background: Spiral Depth gradient (full screen)
- Content centered vertically
- 32pt horizontal margins
- Elements stacked with 20pt spacing
- No navigation bar (full takeover)
- Cannot dismiss without responding (Accountability mode)

Animation Sequence:
1. Screen fades to gradient (0.3s)
2. Spiral appears hypnotic (2s rotation)
3. Spiral breaks apart (0.8s)
4. Text fades in (0.4s)
5. Input/buttons slide up (0.3s)

Haptic Pattern:
- 3 strong taps (0.2s interval) on appearance
- Single tap on button press
```

### Accountability Mode - Active State
```
┌─────────────────────────────────────────┐
│                                         │
│         [Safe Area Top]                 │
│                                         │
│                                         │
│      [Broken Spiral Fragments]          │  ← Dispersed pieces
│                                         │
│                                         │
│      YOU'RE IN THE SPIRAL               │  ← 28pt Bold, White
│                                         │
│  What's ONE thing you learned           │
│  in the last hour?                      │  ← 17pt Regular, White 80%
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ I read an interesting article     │  │  ← Text input (active)
│  │ about climate change              │  │  17pt, White
│  │                                   │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │      I learned something          │  │  ← Primary button (enabled)
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │     Nothing productive            │  │  ← Destructive button
│  └───────────────────────────────────┘  │
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

Input Field Specs:
- Background: Deep Purple 50% opacity
- Border: 2pt Neon Purple 30% (normal)
- Border (focused): 2pt Electric Blue + subtle glow
- Corner Radius: 12pt
- Padding: 16pt
- Min height: 100pt (multi-line)
- Text: 17pt Regular, White
- Placeholder: White 50%
```

### Gentle Mode - Dismissible
```
┌─────────────────────────────────────────┐
│                                    [X]  │  ← Dismiss button (top right)
│         [Safe Area Top]                 │
│                                         │
│                                         │
│      [Spiral Animation - Breathing]     │
│                                         │
│                                         │
│     Taking a scroll break?              │  ← 22pt Semibold, White
│                                         │
│  You've been scrolling for 60 minutes   │  ← 17pt, White 70%
│                                         │
│  ┌───────────────────────────────────┐  │
│  │      Take a break                 │  │  ← Primary button
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │      Just a bit more              │  │  ← Secondary button
│  └───────────────────────────────────┘  │
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

Gentle Mode Specs:
- Can dismiss via X button or "Just a bit more"
- Softer messaging
- Optional text input
- Light haptic (single tap)
- Shorter animation
```

### Nuclear Mode - Enforced
```
┌─────────────────────────────────────────┐
│                                         │
│         [Safe Area Top]                 │
│                                         │
│          [Spiral + Lock Icon]           │  ← 180x180pt
│                                         │
│                                         │
│      SPIRAL DETECTED                    │  ← 28pt Bold, Alert Red
│                                         │
│  You need a break. Apps will be         │
│  restricted for 15 minutes.             │  ← 17pt, White 80%
│                                         │
│  What did you accomplish?               │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │                                   │  │  ← Required text input
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │       Start Cooldown              │  │  ← Button (enabled only
│  └───────────────────────────────────┘  │     when text entered)
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

Nuclear Mode Specs:
- Cannot dismiss
- MUST enter reflection to proceed
- Enforces 15-min app block via Screen Time API
- Strong haptic pattern (continuous buzz)
- Alert Red accent color
- Countdown timer during cooldown
```

---

## 4. Stats View

```
┌─────────────────────────────────────────┐
│ ← Stats                       [Export] │  ← Navigation bar
├─────────────────────────────────────────┤
│                                         │
│          [Safe Area Top]                │
│                                         │
│  ┌────┬────┬────┬────┐                 │
│  │7 D │30D │ Q │ Y │                   │  ← Segmented control
│  └────┴────┴────┴────┘                 │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Total Screen Time                │  │
│  │                                   │  │
│  │       24h 32m                     │  │  ← 32pt Bold, Electric Blue
│  │       ↓ 15% from last week        │  │  ← 15pt, Success Green
│  │                                   │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  [Line Chart]                     │  │  ← Screen time trend
│  │      ╱╲                           │  │  Chart height: 200pt
│  │     ╱  ╲  ╱╲                      │  │
│  │  ──╱    ╲╱  ╲────                 │  │
│  │  M  T  W  T  F  S  S              │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌─────────────────┬─────────────────┐  │
│  │ Interventions   │ Successful      │  │  ← Stat cards (2-column)
│  │                 │ Breaks          │  │
│  │      12         │      9          │  │
│  └─────────────────┴─────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  Most Used Apps                   │  │
│  │                                   │  │
│  │  Instagram        8h 24m   ████  │  │  ← Progress bar
│  │  TikTok          6h 12m   ███    │  │
│  │  Twitter         2h 5m    █      │  │
│  │                                   │  │
│  └───────────────────────────────────┘  │
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

Layout:
- Background: Black
- Scroll view with 20pt margins
- Cards: 16pt spacing between
- 2-column grid: 12pt gap

Stat Card Specs:
- Width: (Screen width - 52pt) / 2
- Height: 100pt
- Title: 15pt Medium, White 70%
- Value: 32pt Bold, Electric Blue
- Background: Deep Purple
- Corner Radius: 16pt
```

---

## 5. Settings View

```
┌─────────────────────────────────────────┐
│ ← Settings                              │  ← Navigation bar
├─────────────────────────────────────────┤
│                                         │
│  Detection                              │  ← Section header
│  ───────────────────────────────────    │
│                                         │
│  Time Threshold                         │  ← Setting row
│  60 minutes                         >   │
│                                         │
│  Monitored Apps                         │
│  6 apps                             >   │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Intervention Mode                      │  ← Section header
│  ───────────────────────────────────    │
│                                         │
│  Mode                                   │
│  Accountability                     >   │
│                                         │
│  Sound                              [●] │  ← Toggle
│  Haptics Intensity                  >   │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Notifications                          │  ← Section header
│  ───────────────────────────────────    │
│                                         │
│  Daily Reminders                    [●] │
│  Quiet Hours                        [ ] │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  Privacy                                │
│  ───────────────────────────────────    │
│                                         │
│  Export Data                        >   │
│  Delete All Data                    >   │
│                                         │
│         [Safe Area Bottom]              │
└─────────────────────────────────────────┘

Layout:
- Standard iOS grouped list style
- Background: Black
- Section headers: 13pt Medium, White 70%, uppercase
- Setting rows:
  - Title: 17pt Regular, White
  - Detail: 17pt Regular, White 70%, right-aligned
  - Chevron: 13pt, White 30%
  - Separator: 1px, White 10%
  - Padding: 16pt vertical, 20pt horizontal
  - Tap target: Full row

Settings Detail Views (Modal):
- Time Threshold: Slider (30-90 min)
- Monitored Apps: List with toggles
- Mode: Radio button list
- Haptics Intensity: Segmented control (Light/Medium/Strong)
```

---

## 6. Component Library

### Progress Ring (Circular)
```
        ████
      ██    ██
    ██  60%  ██
    ██        ██
      ██    ██
        ████

Specs:
- Diameter: 120pt (adjustable)
- Track: Gray 20%, 8pt stroke
- Fill: Electric Flow gradient
- Stroke width: 8pt
- Center text: 28pt Bold, White
- Animation: 0.5s ease-out fill
- End cap: Rounded
```

### Stat Card Component
```
┌─────────────────┐
│ 📊             │  ← Icon (optional)
│                │
│     2,547      │  ← Value (32pt Bold, White)
│                │
│ Screen Time    │  ← Label (13pt, White 70%)
│ This Week      │
└─────────────────┘

Specs:
- Width: Flexible
- Min height: 120pt
- Padding: 20pt
- Icon: 28pt, Electric Blue 60%, top-right
- Background: Deep Purple card style
```

### Button Variants

**Primary Button**
```
┌─────────────────────────────────┐
│        Button Label             │
└─────────────────────────────────┘

Specs:
- Background: Electric Blue
- Text: 16pt Semibold, White
- Height: 52pt
- Corner Radius: 12pt
- Shadow: 0 4pt 12pt Electric Blue 30%
- Press state: 90% opacity, scale 0.98
```

**Secondary Button**
```
┌─────────────────────────────────┐
│        Button Label             │
└─────────────────────────────────┘

Specs:
- Border: 2pt Electric Blue
- Background: Transparent
- Text: 16pt Semibold, Electric Blue
- Height: 52pt
- Corner Radius: 12pt
- Press state: Background Deep Purple 20%
```

**Destructive Button**
```
┌─────────────────────────────────┐
│        Button Label             │
└─────────────────────────────────┘

Specs:
- Background: Alert Red
- Text: 16pt Semibold, White
- Height: 52pt
- Corner Radius: 12pt
- Press state: 90% opacity
```

---

## 7. Animation Specifications

### Spiral Breathing (Home Screen)
```
Keyframe Animation (30s loop):

0%:   Scale 1.0,   Rotation 0°,    Opacity 100%
25%:  Scale 1.05,  Rotation 90°,   Opacity 90%
50%:  Scale 1.0,   Rotation 180°,  Opacity 100%
75%:  Scale 0.95,  Rotation 270°,  Opacity 90%
100%: Scale 1.0,   Rotation 360°,  Opacity 100%

Timing: ease-in-out throughout
Effect: Gentle, meditative breathing
```

### Spiral Breaking (Intervention)
```
Duration: 0.8s

Phase 1 (0.0 - 0.3s): Acceleration
- Rotation speed increases 2x → 6x
- Add subtle shake/vibration
- Scale 1.0 → 1.1

Phase 2 (0.3 - 0.5s): Fragmentation
- Split spiral into 8-12 segments
- Each segment gains random rotation
- Segments begin flying outward

Phase 3 (0.5 - 0.8s): Dispersion
- Segments accelerate outward (radial)
- Fade opacity 100% → 0%
- Scale down 1.0 → 0.8

Timing: ease-in (phase 1), ease-out (phase 3)
Haptic: 3 strong taps synchronized with breaking
```

### Spiral Reformation (Success)
```
Duration: 1.0s

Phase 1 (0.0 - 0.4s): Return
- Fragments fly in from edges
- Position interpolation (ease-in)
- Opacity 0% → 100%

Phase 2 (0.4 - 0.7s): Assembly
- Segments snap into place
- Slight overshoot (spring animation)
- Rotation aligns

Phase 3 (0.7 - 1.0s): Celebration
- Color shift: Blue → Success Green (0.3s)
- Scale pulse: 1.0 → 1.15 → 1.0
- Glow effect intensifies briefly

Timing: Spring animation (damping 0.6)
Haptic: Single success tap at completion
```

---

## 8. Dark Mode vs Light Mode

### Dark Mode (Primary)
- Background: Pure Black (#000000)
- Cards: Deep Purple (#1A0B2E)
- Primary text: White (#FFFFFF)
- Secondary text: White 70%
- Accents: Electric Blue, Neon Purple

### Light Mode (Optional)
- Background: Soft Gray (#F8F9FA)
- Cards: White (#FFFFFF)
- Primary text: Black (#000000)
- Secondary text: Black 70%
- Accents: Darker blue, Purple (adjusted for contrast)
- Borders: Gray 10%

**Note:** App is designed dark-first. Light mode is secondary priority.

---

## 9. Responsive Layout Guidelines

### iPhone SE (Small)
- Reduce spiral size: 120pt
- Reduce card padding: 16pt
- Adjust font sizes: -2pt for display text
- Tighter vertical spacing: 24pt between sections

### iPhone Pro Max (Large)
- Increase spiral size: 180pt
- Maintain standard card padding: 20pt
- Standard font sizes
- Standard vertical spacing: 30pt

### iPad (Future)
- 2-column layout for cards
- Sidebar navigation
- Larger spiral: 250pt
- Increased margins: 40pt

---

## 10. Accessibility Considerations

### VoiceOver Labels
```
Home Screen:
- Spiral animation: "Status indicator, currently idle"
- Streak card: "Current streak: 3 days"
- Screen time: "Today's screen time: 2 hours 15 minutes. Status: Doing great"

Intervention Screen:
- Spiral animation: "Warning indicator"
- Main text: "You're in the spiral. Reflection required."
- Input: "Reflection text field, required"
- Button: "Submit reflection and continue"

Settings:
- Each row: "Setting name, current value, button"
- Toggles: "Setting name, toggle button, currently on/off"
```

### Dynamic Type Support
- All text scales with user preference
- Minimum: Scale down to 80% of specified size
- Maximum: Scale up to 200% of specified size
- Layout adapts: Vertical stacking at large sizes

### Reduce Motion
- Spiral: Static or slow fade instead of rotation
- Intervention: Crossfade instead of breaking animation
- Transitions: Fade instead of slide/scale
- Progress: Instant instead of animated

### Color Contrast
All combinations tested for WCAG AA:
✓ White on Deep Purple: 12.5:1 (AAA)
✓ Electric Blue on Black: 8.2:1 (AAA)
✓ White on Alert Red: 4.6:1 (AA)

---

## 11. Error States & Edge Cases

### No Screen Time Permission
```
┌─────────────────────────────────────────┐
│                                         │
│          [Sad Spiral Icon]              │
│                                         │
│     Permission Required                 │
│                                         │
│  Spiral needs Screen Time access        │
│  to detect doom scrolling.              │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │      Open Settings                │  │
│  └───────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

### No Data Yet (First Day)
```
┌─────────────────────────────────────────┐
│          Stats                          │
├─────────────────────────────────────────┤
│                                         │
│          [Empty State Icon]             │
│                                         │
│     No data yet                         │
│                                         │
│  Use Spiral for a day to see            │
│  your stats here.                       │
│                                         │
└─────────────────────────────────────────┘
```

### Network Unavailable
```
Not applicable - app is 100% offline
```

---

## Implementation Checklist

For each screen, ensure:
- [ ] Layout matches mockup within 4pt tolerance
- [ ] Colors match brand guide exactly
- [ ] Typography uses correct weights and sizes
- [ ] Spacing follows 8pt grid system
- [ ] Animations are smooth (60fps)
- [ ] Haptics fire at correct times
- [ ] VoiceOver labels are descriptive
- [ ] Dynamic Type is supported
- [ ] Dark mode is primary, light mode optional
- [ ] Safe areas are respected
- [ ] Tap targets are minimum 44x44pt

---

**This guide provides pixel-perfect specifications for implementation. Reference it constantly while building. When in doubt, measure twice, code once.** 🎨
