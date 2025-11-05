//
//  HapticsManager.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import UIKit
import CoreHaptics

/// Manages haptic feedback throughout the app
class HapticsManager: ObservableObject {
    static let shared = HapticsManager()

    // MARK: - Private Properties

    private var engine: CHHapticEngine?
    private var isHapticsEnabled: Bool {
        UserDefaults.standard.object(forKey: "hapticsEnabled") as? Bool ?? true
    }

    private var intensity: HapticsIntensity {
        if let rawValue = UserDefaults.standard.string(forKey: "hapticsIntensity"),
           let intensity = HapticsIntensity(rawValue: rawValue) {
            return intensity
        }
        return .medium
    }

    // MARK: - Initialization

    private init() {
        setupHapticsEngine()
    }

    // MARK: - Setup

    private func setupHapticsEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("⚠️ Device doesn't support haptics")
            return
        }

        do {
            engine = try CHHapticEngine()
            try engine?.start()

            engine?.stoppedHandler = { reason in
                print("⚠️ Haptic engine stopped: \(reason)")
            }

            engine?.resetHandler = { [weak self] in
                print("🔄 Haptic engine reset")
                do {
                    try self?.engine?.start()
                } catch {
                    print("❌ Failed to restart haptic engine: \(error)")
                }
            }
        } catch {
            print("❌ Failed to create haptic engine: \(error)")
        }
    }

    // MARK: - Simple Haptic Patterns

    /// Play a light tap (notifications, selections)
    func lightTap() {
        guard isHapticsEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    /// Play a medium impact (button presses)
    func mediumImpact() {
        guard isHapticsEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred(intensity: intensityValue())
    }

    /// Play a heavy impact (important actions)
    func heavyImpact() {
        guard isHapticsEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: intensityValue())
    }

    /// Play a success pattern
    func success() {
        guard isHapticsEnabled else { return }

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    /// Play a warning pattern
    func warning() {
        guard isHapticsEnabled else { return }

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    /// Play an error pattern
    func error() {
        guard isHapticsEnabled else { return }

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    // MARK: - Custom Patterns for Intervention Modes

    /// Gentle mode haptic pattern
    func playGentlePattern() {
        guard isHapticsEnabled else { return }

        warning()
    }

    /// Accountability mode haptic pattern (3 taps)
    func playAccountabilityPattern() {
        guard isHapticsEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: .medium)

        generator.impactOccurred(intensity: intensityValue())

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            generator.impactOccurred(intensity: self.intensityValue())
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            generator.impactOccurred(intensity: self.intensityValue())
        }
    }

    /// Lockdown mode haptic pattern (continuous buzz)
    func playLockdownPattern() {
        guard isHapticsEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: .heavy)

        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                generator.impactOccurred(intensity: self.intensityValue())
            }
        }
    }

    /// Achievement unlock pattern
    func playAchievementPattern() {
        guard isHapticsEnabled else { return }

        success()

        // Add a celebratory burst
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mediumImpact()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.lightTap()
        }
    }

    /// Spiral breaking pattern
    func playSpiralBreakPattern() {
        guard isHapticsEnabled else { return }

        playCustomPattern(
            events: [
                (intensity: 0.8, sharpness: 0.5, time: 0.0),
                (intensity: 1.0, sharpness: 0.8, time: 0.1),
                (intensity: 0.6, sharpness: 0.3, time: 0.3),
                (intensity: 0.3, sharpness: 0.1, time: 0.5),
            ]
        )
    }

    // MARK: - Custom Haptic Patterns

    private func playCustomPattern(events: [(intensity: Float, sharpness: Float, time: TimeInterval)]) {
        guard isHapticsEnabled,
              let engine = engine,
              CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }

        var hapticEvents: [CHHapticEvent] = []

        for event in events {
            let adjustedIntensity = event.intensity * intensityMultiplier()

            let intensityParam = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: adjustedIntensity
            )

            let sharpnessParam = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: event.sharpness
            )

            let hapticEvent = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensityParam, sharpnessParam],
                relativeTime: event.time
            )

            hapticEvents.append(hapticEvent)
        }

        do {
            let pattern = try CHHapticPattern(events: hapticEvents, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("❌ Failed to play custom haptic pattern: \(error)")
        }
    }

    // MARK: - Settings

    func setHapticsEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "hapticsEnabled")
    }

    func setIntensity(_ intensity: HapticsIntensity) {
        UserDefaults.standard.set(intensity.rawValue, forKey: "hapticsIntensity")
    }

    // MARK: - Helper Methods

    private func intensityValue() -> CGFloat {
        switch intensity {
        case .light:
            return 0.5
        case .medium:
            return 0.75
        case .strong:
            return 1.0
        }
    }

    private func intensityMultiplier() -> Float {
        switch intensity {
        case .light:
            return 0.6
        case .medium:
            return 0.8
        case .strong:
            return 1.0
        }
    }
}
