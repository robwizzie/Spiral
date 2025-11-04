# Spiral - Logo Reference & Assets Guide

## Visual Logo Representations

This file provides visual references for the Spiral logo in various formats that developers can use as implementation guides.

---

## 1. ASCII Art Representation (Concept)

### Primary Logo - Minimal Spiral
```
                    ████████████
                ████            ████
             ███                    ███
           ██                          ██
         ██              ●●              ██
        ██            ●●●●●●●            ██
       ██           ●●●    ●●●           ██
      ██           ●●●      ●●●          ██
      ██          ●●●        ●●●         ██
     ██           ●●●        ●●●         ██
     ██           ●●●        ●●●         ██
     ██            ●●●      ●●●          ██
      ██            ●●●●●●●●●           ██
      ██              ●●●●              ██
       ██                              ██
        ██                            ██
          ██                        ██
            ███                  ███
               ████            ████
                   ████████████

           S  P  I  R  A  L
```

### Icon Version (App Icon)
```
    ██████████████████████████
   ██                        ██
  ██    ████████████████      ██
 ██   ████          ████       ██
 ██  ███    ●●●●●    ███       ██
██  ███   ●●●  ●●●    ███       ██
██  ██   ●●●    ●●●    ██       ██
██  ██   ●●●    ●●●    ██       ██
██  ██    ●●●●●●●●    ██        ██
██   ██     ●●●●     ██         ██
 ██   ███          ███         ██
  ██    ████████████          ██
   ██                        ██
    ██████████████████████████
```

---

## 2. Geometric Construction Guide

### Mathematical Spiral (Fibonacci/Golden Ratio)

The spiral follows the golden ratio (φ = 1.618) for perfect proportions:

```
Center Point: (0, 0)
Starting Radius: r₀ = 10 units
Growth Factor: φ = 1.618
Rotation: θ (0 to 5π) - 2.5 complete rotations

Polar Equation:
r(θ) = r₀ × φ^(θ/π)

Points along spiral:
θ = 0°    : r = 10 units
θ = 180°  : r = 16.18 units
θ = 360°  : r = 26.18 units
θ = 540°  : r = 42.36 units
θ = 720°  : r = 68.54 units
θ = 900°  : r = 110.9 units (end point)
```

### Line Weight Guidelines
```
At 1024px canvas (App Icon):
- Spiral line: 12pt stroke
- Minimum line: 8pt stroke
- Maximum line: 16pt stroke

At 100px canvas (Small icon):
- Spiral line: 3pt stroke
- Adjust based on context

Scale linearly for other sizes
```

---

## 3. SVG Path Specification

### Simplified Spiral Path (for implementation)

```xml
<!-- Spiral Logo SVG Template -->
<svg width="200" height="200" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <!-- Gradient Definition -->
  <defs>
    <linearGradient id="spiralGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#00D9FF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#7B2CBF;stop-opacity:1" />
    </linearGradient>
    
    <!-- Glow Effect -->
    <filter id="glow">
      <feGaussianBlur stdDeviation="4" result="coloredBlur"/>
      <feMerge>
        <feMergeNode in="coloredBlur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>
  
  <!-- Background (optional, for app icon) -->
  <rect width="200" height="200" fill="#1A0B2E" rx="40"/>
  
  <!-- Spiral Path (simplified - actual implementation needs more detail) -->
  <path d="
    M 100 100
    Q 100 90, 110 90
    Q 120 90, 120 100
    Q 120 115, 105 115
    Q 85 115, 85 100
    Q 85 75, 110 75
    Q 140 75, 140 105
    Q 140 140, 105 140
    Q 65 140, 65 100
    Q 65 55, 115 55
    Q 165 55, 165 110
    Q 165 165, 110 165
  "
  stroke="url(#spiralGradient)"
  stroke-width="8"
  fill="none"
  stroke-linecap="round"
  filter="url(#glow)"
  />
  
  <!-- Center Point -->
  <circle cx="100" cy="100" r="6" fill="#00D9FF" opacity="0.8"/>
</defs>
</svg>
```

---

## 4. SwiftUI Implementation Template

### Basic Spiral Shape in SwiftUI

```swift
import SwiftUI

struct SpiralShape: Shape {
    var rotations: Double = 2.5
    var growthFactor: Double = 1.618 // Golden ratio
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startRadius: CGFloat = 10
        
        // Number of points to draw (more = smoother)
        let points = 200
        let maxAngle = rotations * 2 * .pi
        
        // Calculate starting point
        let startPoint = polarToCartesian(
            center: center,
            radius: startRadius,
            angle: 0
        )
        path.move(to: startPoint)
        
        // Draw spiral
        for i in 1...points {
            let progress = Double(i) / Double(points)
            let angle = maxAngle * progress
            
            // Calculate radius using golden ratio growth
            let radius = startRadius * pow(CGFloat(growthFactor), CGFloat(angle / .pi))
            
            let point = polarToCartesian(
                center: center,
                radius: radius,
                angle: angle
            )
            
            path.addLine(to: point)
        }
        
        return path
    }
    
    private func polarToCartesian(center: CGPoint, radius: CGFloat, angle: Double) -> CGPoint {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        return CGPoint(x: x, y: y)
    }
}

// Usage in SwiftUI View
struct SpiralLogo: View {
    var body: some View {
        ZStack {
            // Background
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color("DeepPurple"), Color("NeonPurple")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Spiral
            SpiralShape(rotations: 2.5)
                .stroke(
                    LinearGradient(
                        colors: [Color("ElectricBlue"), Color("NeonPurple")],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round
                    )
                )
            
            // Center point
            Circle()
                .fill(Color("ElectricBlue"))
                .frame(width: 12, height: 12)
        }
        .frame(width: 150, height: 150)
    }
}
```

---

## 5. Animation States Reference

### State 1: Idle (Breathing)
```
Visual: Gentle rotation + scale pulse
Rotation: 0° → 360° over 30 seconds
Scale: 0.95 ↔ 1.05 smooth pulse
Opacity: 90% ↔ 100%
Glow: Subtle, constant
Color: Electric Blue → Neon Purple gradient
```

### State 2: Hypnotic (Detecting)
```
Visual: Rapid rotation
Rotation: 180° per second (6× normal speed)
Scale: 1.0 (constant)
Opacity: 100%
Glow: Intensifying (pulsing faster)
Color: Shifting blue → purple → blue
Effect: Mesmerizing, attention-grabbing
```

### State 3: Breaking (Intervention Triggered)
```
Visual: Fragments flying apart
Animation Duration: 0.8 seconds
Fragments: 12 pieces
Direction: Radial outward from center
Rotation: Each fragment spins randomly
Scale: 1.0 → 0.8 as they fade
Opacity: 100% → 0%
Trail: Motion blur effect
Sound: Synchronized breaking sound
Haptic: 3 strong taps
```

### State 4: Reformed (Success)
```
Visual: Pieces reassemble
Animation Duration: 1.0 seconds
Movement: Fragments fly in from edges
Rotation: Aligns as pieces connect
Color: Blue → Success Green transition
Scale: Final pulse 1.0 → 1.15 → 1.0
Glow: Bright success flash
Effect: Satisfying, rewarding
```

---

## 6. Color Variations

### Primary (Default)
```
Spiral: Electric Blue (#00D9FF)
Background: Deep Purple (#1A0B2E)
Glow: Electric Blue 30% opacity
```

### Alert State (Nuclear Mode)
```
Spiral: Alert Red (#E63946)
Background: Deep Purple (#1A0B2E)
Glow: Alert Red 40% opacity
Pulse: Warning Orange (#FF6B35) flashes
```

### Success State
```
Spiral: Success Green (#10B981)
Background: Deep Purple (#1A0B2E)
Glow: Success Green 30% opacity
```

### Monochrome (Alternative)
```
Spiral: White (#FFFFFF)
Background: Pure Black (#000000)
Glow: White 20% opacity
```

---

## 7. Size Variations & Export Specs

### iOS App Icon Sizes (Required)
```
@1x (px)    @2x (px)    @3x (px)    Usage
20          40          60          iPhone Notification
29          58          87          iPhone Settings
40          80          120         iPhone Spotlight
60          120         180         iPhone App
76          152         N/A         iPad App
83.5        167         N/A         iPad Pro App
1024        N/A         N/A         App Store

All should be:
- PNG format
- No transparency
- No rounded corners (iOS applies)
- Optimized for each size (adjust line weight)
```

### Other Required Sizes
```
512 × 512   - Web icon, marketing
256 × 256   - System icon
128 × 128   - Small icon
64 × 64     - Tiny icon
32 × 32     - Favicon size
```

---

## 8. Fingerprint Fusion Variant

For the "Fingerprint Fusion" variant, add these details:

```
Base: Standard spiral shape
Additional Layer: Fingerprint ridges

Ridge Pattern:
- 3-5 concentric lines per spiral arm
- Follow spiral curvature precisely
- Spacing: 8-12px between ridges
- Line weight: 2px (thinner than main spiral)
- Color: Neon Purple at 40% opacity
- Subtle, not overpowering

Implementation:
1. Draw main spiral (Electric Blue)
2. For each point on spiral:
   - Draw parallel lines offset by 8-12px
   - Use same curvature
   - Fade opacity toward edges
3. Blend mode: Overlay or Screen
```

---

## 9. App Store Marketing Variants

### Large Hero Image (1024 × 1024)
```
Background: Spiral Depth gradient
Logo: Centered, 600 × 600
Text: "SPIRAL" below logo
      48pt Bold, Electric Blue
Tagline: "Break the Spiral"
         28pt Regular, White 80%
Padding: 100px all sides
```

### Feature Graphic (1024 × 500)
```
Layout: Horizontal
Left: Logo (300 × 300)
Right: 
  - "SPIRAL" (48pt Bold)
  - "Break the doom scroll"
  - Key features (3 bullets)
Background: Gradient (subtle)
```

---

## 10. Logo Usage Guidelines

### Do's ✅
- Use approved colors only
- Maintain aspect ratio (1:1)
- Ensure sufficient clear space (min 20% of logo size)
- Use high-resolution assets
- Apply glow effect on dark backgrounds
- Center in circular frames

### Don'ts ❌
- Never rotate logo (except in animation states)
- Never distort or stretch
- Never change colors (except approved variants)
- Never add effects (except approved glow)
- Never place on busy backgrounds
- Never use low-resolution versions
- Never add drop shadows manually

---

## 11. Implementation Checklist

When implementing the logo, ensure:

- [ ] Correct colors (Electric Blue #00D9FF, Neon Purple #7B2CBF)
- [ ] Proper spiral mathematics (golden ratio growth)
- [ ] Smooth curves (enough points for smoothness)
- [ ] Appropriate line weight for size
- [ ] Center point visible
- [ ] Glow effect applied correctly
- [ ] All animation states implemented
- [ ] Scales properly at all sizes
- [ ] No pixelation at large sizes
- [ ] Looks good on both dark and light backgrounds
- [ ] Accessible (sufficient contrast)
- [ ] Export assets at all required sizes

---

## 12. Testing the Logo

### Visual Tests
```
✓ View at 16px (tiny icon)
✓ View at 64px (small icon)
✓ View at 128px (medium icon)
✓ View at 512px (large icon)
✓ View at 1024px (App Store)
✓ Test on white background
✓ Test on black background
✓ Test on purple background
✓ Test with blur (iOS home screen)
✓ Print test at 300 DPI
```

### Animation Tests
```
✓ Breathing animation smooth at 60fps
✓ Hypnotic animation not too fast
✓ Breaking animation satisfying
✓ Reformed animation rewarding
✓ Transitions between states smooth
✓ No janky frames
✓ Haptics synchronized
```

---

## 13. File Naming Convention

When exporting logo files:

```
Format: spiral-logo-[variant]-[size]-[scale].png

Examples:
spiral-logo-primary-1024-1x.png
spiral-logo-primary-60-3x.png
spiral-logo-alert-512-2x.png
spiral-logo-success-128-1x.png
spiral-logo-mono-256-1x.png

For vectors:
spiral-logo-primary.svg
spiral-logo-fingerprint.svg
```

---

## 14. Quick Copy-Paste Specs

### For Developer Handoff
```yaml
Logo: Spiral (Fibonacci-based)
Primary Colors:
  - Spiral: "#00D9FF" (Electric Blue)
  - Background: "#1A0B2E" (Deep Purple)
  - Gradient: "#00D9FF" to "#7B2CBF"

Dimensions:
  - Canvas: 200 × 200 (scalable)
  - Line Weight: 8pt (at 200px size)
  - Center Point: 12px diameter
  - Rotations: 2.5 complete turns
  
Effects:
  - Glow: Gaussian blur 4px, 30% opacity
  - Animation: See states 1-4
  
Export:
  - SVG (vector, preferred)
  - PNG @1x, @2x, @3x
  - All iOS app icon sizes
```

---

## 15. Resources for Logo Creation

### Design Tools
- **Figma** (Recommended) - Web-based, collaborative
- **Sketch** - Mac-only, industry standard
- **Adobe Illustrator** - Professional vector editing
- **Affinity Designer** - One-time purchase alternative

### Spiral Generation Tools
- **Desmos** - Online graphing calculator (test equations)
- **GeoGebra** - Geometric construction
- **Processing** - Generative code (if coding spiral)

### Color Tools
- **Coolors.co** - Gradient generator
- **Adobe Color** - Color harmony
- **Contrast Checker** - Accessibility testing

---

## 16. Final Notes

The Spiral logo is the face of the brand. It should be:
- **Hypnotic** - Draw people in
- **Technical** - Based on real mathematics
- **Memorable** - Instantly recognizable
- **Flexible** - Work at any size
- **Meaningful** - Represent the spiral of doom scrolling

Every implementation should honor these principles.

---

**Ready to create the logo? Use this guide as your reference.** 🎨

For implementation questions, refer back to:
- `SPIRAL_BRANDING_GUIDE.md` for full brand context
- `SPIRAL_UI_MOCKUPS.md` for usage in UI
- `SPIRAL_PROJECT_SPEC.md` for technical integration

**Make it iconic. Make it Spiral.** 🌀
