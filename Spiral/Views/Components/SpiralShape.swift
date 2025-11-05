//
//  SpiralShape.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import SwiftUI

/// Custom shape that draws a Fibonacci/golden ratio spiral
struct SpiralShape: Shape {
    var rotations: Double = 2.5
    var growthFactor: Double = 1.618 // Golden ratio

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let points = 200

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

/// Animatable version of the spiral shape
struct AnimatableSpiralShape: Shape {
    var rotations: Double
    var progress: Double = 1.0 // 0 to 1, controls how much of the spiral is drawn

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(rotations, progress) }
        set {
            rotations = newValue.first
            progress = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let points = Int(200 * progress)
        let growthFactor = 1.618

        guard points > 0 else { return path }

        for i in 0...points {
            let pointProgress = Double(i) / Double(points)
            let angle = rotations * 2 * .pi * pointProgress
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
