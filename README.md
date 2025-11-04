# 🌀 Spiral

**Break the spiral. Touch grass.**

An iOS app that detects doom scrolling and interrupts you with hilarious roasts. Built with SwiftUI, powered by humor.

## 🎯 What It Does

-   Detects when you're doom scrolling (25+ min)
-   Interrupts with funny roasts
-   Tracks progress with daily "Doom Score" (0-10)
-   Makes every moment shareable
-   Actually helps without being preachy

## 📚 Documentation

All documentation is in the `/docs` folder:

-   [README_V2.md](docs/README_V2.md) - Start here
-   [SPIRAL_V2_QUICK_START.md](docs/SPIRAL_V2_QUICK_START.md) - Implementation guide
-   [SPIRAL_V2_PROJECT_SPEC.md](docs/SPIRAL_V2_PROJECT_SPEC.md) - Full specification
-   [SPIRAL_V2_COPY_GUIDE.md](docs/SPIRAL_V2_COPY_GUIDE.md) - All roasts & text

## 🚀 Getting Started

1. Open `Spiral.xcodeproj` in Xcode 15+
2. Read `docs/SPIRAL_V2_QUICK_START.md`
3. Follow Day 1-5 implementation guide
4. Test on physical device (Screen Time API requirement)

## 🛠️ Tech Stack

-   iOS 16.0+
-   SwiftUI
-   SwiftData
-   FamilyControls API
-   100% privacy-first (no cloud, no tracking)

## 📱 Features

-   🔥 50+ hilarious roasts
-   📊 Smart doom scroll detection (active vs passive)
-   😌 Three intervention modes (Gentle/Accountability/Lockdown)
-   🎯 Doom Score (0-10 daily rating)
-   🏆 Achievements (positive + sarcastic)
-   📤 Viral share system
-   🌱 "Touch grass" reminders

## 🎨 Brand

-   Colors: Deep Purple (#1A0B2E) + Electric Blue (#00D9FF)
-   Tone: Funny, honest, self-aware
-   Design: Minimal, beautiful, Apple Design Award worthy

## 📄 License

[Your License Here]

## 🌀 Let's Break Some Spirals

Built with 🔥 and SwiftUI
EOF

# Commit the docs

git add docs/ README.md
git commit -m "Add complete V2 documentation"
git push

Part 2: What to Give Claude Code
Option A: Claude Code via Terminal (Recommended)
In your terminal, navigate to the project folder and run:
bashclaude-code

```

**Then say:**
```

I need you to build the Spiral iOS app following the complete V2 specification.

Here's what you need to know:

PROJECT:

-   Xcode project already created: Spiral.xcodeproj
-   Git repository initialized and pushed to GitHub
-   All documentation is in the /docs folder

YOUR MISSION:
Read the documentation in /docs and implement Spiral following the Day 1-5 guide in SPIRAL_V2_QUICK_START.md.

Start with Day 1 tasks:

1. Review existing project structure
2. Create all data models (AppSettings, ScrollSession, UserStats)
3. Set up Constants.swift with color assets
4. Create RoastLibrary.swift with all 50+ roasts from SPIRAL_V2_COPY_GUIDE.md
5. Build RoastEngine.swift

Key Requirements:

-   25 minute default threshold (NOT 60)
-   Active vs passive doom scroll detection
-   Three modes: Gentle, Accountability, Lockdown
-   All roasts from SPIRAL_V2_COPY_GUIDE.md
-   Doom Score calculation (0-10)
-   Share system for viral growth
-   60fps animations
-   100% privacy (local storage only)

DOCUMENTATION PRIORITY:

1. SPIRAL_V2_QUICK_START.md - Your day-by-day guide
2. SPIRAL_V2_PROJECT_SPEC.md - Full technical details
3. SPIRAL_V2_COPY_GUIDE.md - All text content
4. Other docs as needed

Questions? Ask me. Otherwise, start with Day 1 and let's build this! 🌀
