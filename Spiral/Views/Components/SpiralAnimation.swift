//
//  SpiralAnimation.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI

/// The main spiral animation component with multiple states
struct SpiralAnimation: View {
    let state: AnimationState
    let size: CGFloat

    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var progress: Double = 1.0
    @State private var colorPhase: Double = 0
    @State private var fragments: [SpiralFragment] = []

    enum AnimationState {
        case idle           // Breathing animation on home screen
        case hypnotic       // Rapid rotation during detection
        case breaking       // Fragments flying apart
        case reformed       // Fragments coming back together
    }

    var body: some View {
        ZStack {
            switch state {
            case .idle:
                breathingSpiral
            case .hypnotic:
                hypnoticSpiral
            case .breaking:
                breakingSpiral
            case .reformed:
                reformedSpiral
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            setupAnimation()
        }
    }

    // MARK: - Breathing Animation (Idle State)

    private var breathingSpiral: some View {
        ZStack {
            // Center dot
            Circle()
                .fill(Color.electricBlue)
                .frame(width: 8, height: 8)

            // Spiral
            SpiralShape(rotations: 2.5)
                .stroke(
                    LinearGradient(
                        colors: [Color.electricBlue, Color.neonPurple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(rotation))
                .scaleEffect(scale)
                .shadow(color: Color.electricBlue.opacity(0.6), radius: 10)
        }
        .onAppear {
            // Slow continuous rotation
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                rotation = 360
            }

            // Breathing scale animation
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                scale = 1.05
            }
        }
    }

    // MARK: - Hypnotic Animation (Detection Active)

    private var hypnoticSpiral: some View {
        ZStack {
            Circle()
                .fill(Color.electricBlue)
                .frame(width: 8, height: 8)

            SpiralShape(rotations: 2.5)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.electricBlue.opacity(1.0 - colorPhase * 0.5),
                            Color.neonPurple.opacity(0.5 + colorPhase * 0.5)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(rotation))
                .scaleEffect(scale)
                .shadow(color: Color.neonPurple.opacity(0.6 + colorPhase * 0.4), radius: 20)
        }
        .onAppear {
            // Rapid rotation
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }

            // Pulsing scale
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                scale = 1.02
            }

            // Color shift
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                colorPhase = 1.0
            }
        }
    }

    // MARK: - Breaking Animation

    private var breakingSpiral: some View {
        ZStack {
            if fragments.isEmpty {
                // Initial spiral before breaking
                SpiralShape(rotations: 2.5)
                    .stroke(Color.electricBlue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
            } else {
                // Fragments
                ForEach(fragments) { fragment in
                    fragmentView(fragment)
                }
            }
        }
        .onAppear {
            // Trigger breaking animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                breakSpiral()
            }
        }
    }

    private func fragmentView(_ fragment: SpiralFragment) -> some View {
        AnimatableSpiralShape(
            rotations: 0.3,
            progress: 1.0
        )
        .stroke(Color.electricBlue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
        .frame(width: size / 4, height: size / 4)
        .rotationEffect(.degrees(fragment.rotation))
        .offset(x: fragment.offsetX, y: fragment.offsetY)
        .opacity(fragment.opacity)
        .scaleEffect(fragment.scale)
    }

    private func breakSpiral() {
        // Generate 12 fragments in a circle
        let fragmentCount = 12
        fragments = (0..<fragmentCount).map { i in
            SpiralFragment(
                id: UUID(),
                angle: Double(i) * 30,
                distance: 0,
                rotation: 0,
                opacity: 1.0,
                scale: 1.0
            )
        }

        // Animate fragments flying outward
        withAnimation(.easeOut(duration: 0.8)) {
            for i in 0..<fragments.count {
                let angle = fragments[i].angle * .pi / 180
                fragments[i].distance = size * 1.5
                fragments[i].rotation = Double.random(in: -180...180)
                fragments[i].opacity = 0
                fragments[i].scale = 0.9
            }
        }
    }

    // MARK: - Reformed Animation

    private var reformedSpiral: some View {
        ZStack {
            if fragments.isEmpty {
                // Final reformed spiral
                SpiralShape(rotations: 2.5)
                    .stroke(Color.successGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .scaleEffect(scale)
                    .shadow(color: Color.successGreen.opacity(0.6), radius: 20)
            } else {
                // Fragments coming back together
                ForEach(fragments) { fragment in
                    fragmentView(fragment)
                }
            }
        }
        .onAppear {
            // Start with fragments scattered
            scatterFragments()

            // Bring them back together
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                reformSpiral()
            }
        }
    }

    private func scatterFragments() {
        let fragmentCount = 12
        fragments = (0..<fragmentCount).map { i in
            let angle = Double(i) * 30 * .pi / 180
            return SpiralFragment(
                id: UUID(),
                angle: Double(i) * 30,
                distance: size * 1.5,
                rotation: Double.random(in: -180...180),
                opacity: 0.3,
                scale: 0.9
            )
        }
    }

    private func reformSpiral() {
        // Animate fragments coming back
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            for i in 0..<fragments.count {
                fragments[i].distance = 0
                fragments[i].rotation = 0
                fragments[i].opacity = 1.0
                fragments[i].scale = 1.0
            }
        }

        // After reform, clear fragments and show final spiral
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation {
                fragments = []
                // Pulse effect
                scale = 1.15
            }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.1)) {
                scale = 1.0
            }
        }
    }

    // MARK: - Setup

    private func setupAnimation() {
        switch state {
        case .idle, .hypnotic:
            break // Handled in view bodies
        case .breaking:
            break // Handled on appear
        case .reformed:
            break // Handled on appear
        }
    }
}

// MARK: - Supporting Types

struct SpiralFragment: Identifiable {
    let id: UUID
    let angle: Double
    var distance: CGFloat
    var rotation: Double
    var opacity: Double
    var scale: CGFloat

    var offsetX: CGFloat {
        distance * cos(angle * .pi / 180)
    }

    var offsetY: CGFloat {
        distance * sin(angle * .pi / 180)
    }
}

// MARK: - Preview

#Preview("Idle") {
    ZStack {
        Color.black
        SpiralAnimation(state: .idle, size: 200)
    }
}

#Preview("Hypnotic") {
    ZStack {
        Color.black
        SpiralAnimation(state: .hypnotic, size: 200)
    }
}

#Preview("Breaking") {
    ZStack {
        Color.black
        SpiralAnimation(state: .breaking, size: 200)
    }
}

#Preview("Reformed") {
    ZStack {
        Color.black
        SpiralAnimation(state: .reformed, size: 200)
    }
}
