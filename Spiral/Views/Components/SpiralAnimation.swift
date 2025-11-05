//
//  SpiralAnimation.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI

/// Stunning, iconic spiral animation inspired by Stripe's gradient meshes
struct SpiralAnimation: View {
    let state: AnimationState
    let size: CGFloat

    @State private var rotation: Double = 0
    @State private var gradientRotation: Double = 0
    @State private var meshOffset: CGFloat = 0
    @State private var scale: CGFloat = 1.0
    @State private var innerGlow: Double = 0.8
    @State private var fragments: [SpiralFragment] = []

    enum AnimationState {
        case idle           // Beautiful breathing animation
        case hypnotic       // Mesmerizing rotation
        case breaking       // Dramatic break apart
        case reformed       // Triumphant reform
    }

    var body: some View {
        ZStack {
            switch state {
            case .idle:
                stunningIdleSpiral
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

    // MARK: - Stunning Idle Spiral (The Star of the Show)

    private var stunningIdleSpiral: some View {
        ZStack {
            // Layer 1: Deep background glow (creates depth)
            SpiralShape(rotations: 2.5)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color(hex: "#667eea"),  // Soft purple
                            Color(hex: "#764ba2"),  // Deep purple
                            Color(hex: "#f093fb"),  // Pink
                            Color(hex: "#4facfe"),  // Cyan
                            Color(hex: "#667eea")   // Loop back
                        ],
                        center: .center,
                        startAngle: .degrees(gradientRotation),
                        endAngle: .degrees(gradientRotation + 360)
                    ),
                    style: StrokeStyle(lineWidth: 24, lineCap: .round)
                )
                .blur(radius: 20)
                .opacity(0.6)

            // Layer 2: Mid glow with offset for dimension
            SpiralShape(rotations: 2.5)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color(hex: "#4facfe"),  // Cyan
                            Color(hex: "#00f2fe"),  // Bright cyan
                            Color(hex: "#43e97b"),  // Green
                            Color(hex: "#38f9d7"),  // Teal
                            Color(hex: "#4facfe")   // Loop
                        ],
                        center: .center,
                        startAngle: .degrees(gradientRotation + 120),
                        endAngle: .degrees(gradientRotation + 480)
                    ),
                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                )
                .blur(radius: 12)
                .opacity(0.7)
                .offset(x: cos(meshOffset * .pi / 180) * 3, y: sin(meshOffset * .pi / 180) * 3)

            // Layer 3: Sharp definition layer
            SpiralShape(rotations: 2.5)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color(hex: "#667eea"),
                            Color(hex: "#00f2fe"),
                            Color(hex: "#f093fb"),
                            Color(hex: "#43e97b"),
                            Color(hex: "#667eea")
                        ],
                        center: .center,
                        startAngle: .degrees(gradientRotation + 240),
                        endAngle: .degrees(gradientRotation + 600)
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .opacity(0.9)

            // Layer 4: Bright highlights (like light catching edges)
            SpiralShape(rotations: 2.5)
                .stroke(
                    AngularGradient(
                        colors: [
                            .clear,
                            Color.white.opacity(0.8),
                            .clear,
                            Color.white.opacity(0.6),
                            .clear
                        ],
                        center: .center,
                        startAngle: .degrees(gradientRotation + 180),
                        endAngle: .degrees(gradientRotation + 540)
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .blur(radius: 2)

            // Center glow point
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(innerGlow),
                            Color(hex: "#4facfe").opacity(innerGlow * 0.6),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 15
                    )
                )
                .frame(width: 30, height: 30)
        }
        .rotationEffect(.degrees(rotation))
        .scaleEffect(scale)
        .onAppear {
            // Ultra-slow, graceful rotation
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                rotation = 360
            }

            // Gradient rotation (creates flowing effect)
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                gradientRotation = 360
            }

            // Mesh offset (creates subtle movement)
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                meshOffset = 360
            }

            // Gentle breathing
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                scale = 1.05
            }

            // Inner glow pulse
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                innerGlow = 1.0
            }
        }
    }

    // MARK: - Hypnotic Spiral

    private var hypnoticSpiral: some View {
        ZStack {
            // Pulsing background
            SpiralShape(rotations: 2.5)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color(hex: "#f093fb"),
                            Color(hex: "#f5576c"),
                            Color(hex: "#ffd89b"),
                            Color(hex: "#f093fb")
                        ],
                        center: .center,
                        startAngle: .degrees(gradientRotation),
                        endAngle: .degrees(gradientRotation + 360)
                    ),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .blur(radius: 16)
                .opacity(0.8)

            // Foreground spiral
            SpiralShape(rotations: 2.5)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color(hex: "#667eea"),
                            Color(hex: "#00f2fe"),
                            Color(hex: "#f093fb"),
                            Color(hex: "#667eea")
                        ],
                        center: .center,
                        startAngle: .degrees(gradientRotation + 180),
                        endAngle: .degrees(gradientRotation + 540)
                    ),
                    style: StrokeStyle(lineWidth: 7, lineCap: .round)
                )
        }
        .rotationEffect(.degrees(rotation))
        .scaleEffect(scale)
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                gradientRotation = 360
            }
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                scale = 1.08
            }
        }
    }

    // MARK: - Breaking Spiral

    private var breakingSpiral: some View {
        ZStack {
            if fragments.isEmpty {
                // Initial stunning spiral
                stunningIdleSpiral
            } else {
                ForEach(fragments) { fragment in
                    fragmentView(fragment)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                breakSpiral()
            }
        }
    }

    private func fragmentView(_ fragment: SpiralFragment) -> some View {
        SpiralShape(rotations: 0.3)
            .stroke(
                LinearGradient(
                    colors: [
                        Color(hex: "#667eea"),
                        Color(hex: "#4facfe")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 5, lineCap: .round)
            )
            .frame(width: size / 4, height: size / 4)
            .blur(radius: 3)
            .rotationEffect(.degrees(fragment.rotation))
            .offset(x: fragment.offsetX, y: fragment.offsetY)
            .opacity(fragment.opacity)
            .scaleEffect(fragment.scale)
    }

    private func breakSpiral() {
        let fragmentCount = 16
        fragments = (0..<fragmentCount).map { i in
            SpiralFragment(
                id: UUID(),
                angle: Double(i) * (360.0 / Double(fragmentCount)),
                distance: 0,
                rotation: 0,
                opacity: 1.0,
                scale: 1.0
            )
        }

        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            for i in 0..<fragments.count {
                let angle = fragments[i].angle * .pi / 180
                fragments[i].distance = size * 2
                fragments[i].rotation = Double.random(in: -360...360)
                fragments[i].opacity = 0
                fragments[i].scale = 0.7
            }
        }
    }

    // MARK: - Reformed Spiral

    private var reformedSpiral: some View {
        ZStack {
            if fragments.isEmpty {
                // Success state with green accent
                SpiralShape(rotations: 2.5)
                    .stroke(
                        AngularGradient(
                            colors: [
                                Color(hex: "#43e97b"),
                                Color(hex: "#38f9d7"),
                                Color(hex: "#67C3F3"),
                                Color(hex: "#43e97b")
                            ],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .blur(radius: 12)
                    .opacity(0.8)

                SpiralShape(rotations: 2.5)
                    .stroke(
                        AngularGradient(
                            colors: [
                                Color(hex: "#43e97b"),
                                Color.white,
                                Color(hex: "#38f9d7"),
                                Color(hex: "#43e97b")
                            ],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )

                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
            } else {
                ForEach(fragments) { fragment in
                    fragmentView(fragment)
                }
            }
        }
        .scaleEffect(scale)
        .onAppear {
            scatterFragments()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                reformSpiral()
            }
        }
    }

    private func scatterFragments() {
        let fragmentCount = 16
        fragments = (0..<fragmentCount).map { i in
            SpiralFragment(
                id: UUID(),
                angle: Double(i) * (360.0 / Double(fragmentCount)),
                distance: size * 2,
                rotation: Double.random(in: -360...360),
                opacity: 0.3,
                scale: 0.7
            )
        }
    }

    private func reformSpiral() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            for i in 0..<fragments.count {
                fragments[i].distance = 0
                fragments[i].rotation = 0
                fragments[i].opacity = 1.0
                fragments[i].scale = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation {
                fragments = []
                scale = 1.2
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.1)) {
                scale = 1.0
            }
        }
    }

    private func setupAnimation() {
        // Setup handled in individual views
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

#Preview("Stunning Idle") {
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
