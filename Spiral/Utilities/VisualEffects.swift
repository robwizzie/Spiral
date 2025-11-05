//
//  VisualEffects.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI

// MARK: - Modern Card (Clean, Apple-inspired)

struct ModernCard: ViewModifier {
    let cornerRadius: CGFloat
    let padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemGray6).opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}

extension View {
    func modernCard(cornerRadius: CGFloat = 16, padding: CGFloat = 20) -> some View {
        self.modifier(ModernCard(cornerRadius: cornerRadius, padding: padding))
    }
}

// MARK: - Accent Card (for highlighted content)

struct AccentCard: ViewModifier {
    let accentColor: Color
    let cornerRadius: CGFloat
    let padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(accentColor.opacity(0.1))

                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    accentColor.opacity(0.6),
                                    accentColor.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: accentColor.opacity(0.15), radius: 12, x: 0, y: 6)
    }
}

extension View {
    func accentCard(color: Color = .electricBlue, cornerRadius: CGFloat = 16, padding: CGFloat = 20) -> some View {
        self.modifier(AccentCard(accentColor: color, cornerRadius: cornerRadius, padding: padding))
    }
}

// MARK: - Subtle Glow (for emphasis only)

struct SubtleGlow: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.3), radius: radius, x: 0, y: 0)
    }
}

extension View {
    func subtleGlow(color: Color = .electricBlue, radius: CGFloat = 8) -> some View {
        modifier(SubtleGlow(color: color, radius: radius))
    }
}

// MARK: - Clean Background

struct CleanBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.black,
                Color(.systemGray6).opacity(0.1),
                Color.black
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - Subtle Pulse (breathing effect)

struct SubtlePulse: ViewModifier {
    @State private var isPulsing = false
    let duration: Double

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.03 : 1.0)
            .opacity(isPulsing ? 0.9 : 1.0)
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
    func subtlePulse(duration: Double = 2.0) -> some View {
        modifier(SubtlePulse(duration: duration))
    }
}

// MARK: - Gradient Text (refined)

extension View {
    func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .mask(self)
    }
}

// MARK: - Shimmer Effect (for special moments only)

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = -200

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.2),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 100)
                    .offset(x: phase)
                    .onAppear {
                        withAnimation(
                            .linear(duration: 2)
                            .repeatForever(autoreverses: false)
                        ) {
                            phase = geometry.size.width + 200
                        }
                    }
                }
            )
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}
