# Quick Reference for Claude Code

## Key Changes from Generic iOS App to Spiral V2

### Threshold

-   DEFAULT: 1500 seconds (25 minutes)
-   NOT 3600 seconds (60 minutes)

### Intervention Modes

1. Gentle - One tap dismiss
2. Accountability - 10s wait, 3 max dismissals/day
3. Lockdown - Must complete task

### Critical Features

-   50+ roasts (see SPIRAL_V2_COPY_GUIDE.md)
-   Doom Score (0-10) calculation
-   Active vs passive detection
-   Share card generation

### Files Priority

1. Models/ - Data structures first
2. Services/ - Detection logic
3. Views/ - UI with roasts
4. Share system - Viral engine

### Testing Notes

-   MUST test on physical device
-   Screen Time API doesn't work in simulator
-   Active/passive detection needs iteration
-   Battery profiling essential

### Common Pitfalls

-   Don't use 60 min threshold
-   Don't make reflection mandatory
-   Don't skip active/passive logic
-   Don't forget to copy ALL roasts
-   Don't compromise on 60fps

## Resources

-   All roasts: docs/SPIRAL_V2_COPY_GUIDE.md
-   Implementation guide: docs/SPIRAL_V2_QUICK_START.md
-   Full spec: docs/SPIRAL_V2_PROJECT_SPEC.md
