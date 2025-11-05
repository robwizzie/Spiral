//
//  VisualEffects.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI

// MARK: - Glassmorphism Card Style

struct GlassmorphicCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    var shadowRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Blur background
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(0.05))
                        .background(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(.ultraThinMaterial)
                        )

                    // Border gradient
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.electricBlue.opacity(0.5),
                                    Color.neonPurple.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: Color.electricBlue.opacity(0.2), radius: shadowRadius, x: 0, y: 10)
    }
}

extension View {
    func glassmorphicCard(cornerRadius: CGFloat = 20, shadowRadius: CGFloat = 20) -> some View {
        modifier(GlassmorphicCard(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
}

// MARK: - Neon Glow Effect

struct NeonGlow: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.7), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.5), radius: radius * 1.5, x: 0, y: 0)
            .shadow(color: color.opacity(0.3), radius: radius * 2, x: 0, y: 0)
    }
}

extension View {
    func neonGlow(color: Color = .electricBlue, radius: CGFloat = 10) -> some View {
        modifier(NeonGlow(color: color, radius: radius))
    }
}

// MARK: - Animated Gradient Background

struct AnimatedGradientBackground: View {
    @State private var gradientRotation: Double = 0

    let colors: [Color]
    let speed: Double

    init(colors: [Color] = [.deepPurple, .neonPurple, .electricBlue], speed: Double = 8.0) {
        self.colors = colors
        self.speed = speed
    }

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .hueRotation(.degrees(gradientRotation))
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                gradientRotation = 360
            }
        }
    }
}

// MARK: - Pulsing Effect

struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    let minScale: CGFloat
    let maxScale: CGFloat
    let duration: Double

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? maxScale : minScale)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                ) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func pulse(from minScale: CGFloat = 0.95, to maxScale: CGFloat = 1.05, duration: Double = 2.0) -> some View {
        modifier(PulseEffect(minScale: minScale, maxScale: maxScale, duration: duration))
    }
}

// MARK: - Shimmer Effect

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.3),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 400
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Particle System (Simple)

struct FloatingParticle: View {
    let size: CGFloat
    let color: Color
    @State private var offsetY: CGFloat = 0
    @State private var offsetX: CGFloat = 0
    @State private var opacity: Double = 0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .blur(radius: size / 2)
            .offset(x: offsetX, y: offsetY)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 3...6))
                    .repeatForever(autoreverses: true)
                ) {
                    offsetY = CGFloat.random(in: -200...200)
                    offsetX = CGFloat.random(in: -100...100)
                    opacity = Double.random(in: 0.3...0.7)
                }
            }
    }
}

struct ParticleField: View {
    let particleCount: Int
    let colors: [Color]

    init(count: Int = 15, colors: [Color] = [.electricBlue, .neonPurple]) {
        self.particleCount = count
        self.colors = colors
    }

    var body: some View {
        ZStack {
            ForEach(0..<particleCount, id: \.self) { _ in
                FloatingParticle(
                    size: CGFloat.random(in: 20...80),
                    color: colors.randomElement() ?? .electricBlue
                )
                .position(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
            }
        }
    }
}

// MARK: - Gradient Text

extension View {
    func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .mask(self)
    }
}
