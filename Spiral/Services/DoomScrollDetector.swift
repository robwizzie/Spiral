//
//  DoomScrollDetector.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import Foundation
import Combine

/// Detects active vs passive doom scrolling patterns
@MainActor
class DoomScrollDetector: ObservableObject {
    // MARK: - Published Properties

    @Published var isDetecting: Bool = false
    @Published var currentDoomScore: Int = 0

    // MARK: - Private Properties

    private var currentSession: DoomScrollSession?
    private var detectionTimer: Timer?
    private let checkInterval: TimeInterval = 5.0 // Check every 5 seconds

    // MARK: - Detection Session

    struct DoomScrollSession {
        var startTime: Date
        var duration: TimeInterval
        var scrollEvents: Int
        var interactions: Int
        var appSwitches: Int
        var scrollVelocity: Double
        var timeOfDay: Date

        init(startTime: Date = Date()) {
            self.startTime = startTime
            self.duration = 0
            self.scrollEvents = 0
            self.interactions = 0
            self.appSwitches = 0
            self.scrollVelocity = 0
            self.timeOfDay = startTime
        }

        mutating func updateDuration() {
            duration = Date().timeIntervalSince(startTime)
        }
    }

    // MARK: - Start/Stop Detection

    /// Start detecting doom scroll patterns
    func startDetection() {
        guard !isDetecting else { return }

        currentSession = DoomScrollSession()
        isDetecting = true

        // Start periodic checking
        detectionTimer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.performDetectionCheck()
            }
        }

        print("🔍 Doom scroll detection started")
    }

    /// Stop detecting
    func stopDetection() {
        detectionTimer?.invalidate()
        detectionTimer = nil
        currentSession = nil
        isDetecting = false

        print("⏹️ Doom scroll detection stopped")
    }

    // MARK: - Event Tracking

    /// Track a scroll event
    func trackScrollEvent(velocity: Double = 100.0) {
        guard var session = currentSession else { return }

        session.scrollEvents += 1
        session.scrollVelocity = velocity
        session.updateDuration()

        currentSession = session
    }

    /// Track an interaction (like, comment, post)
    func trackInteraction() {
        guard var session = currentSession else { return }

        session.interactions += 1
        session.updateDuration()

        currentSession = session
    }

    /// Track an app switch
    func trackAppSwitch() {
        guard var session = currentSession else { return }

        session.appSwitches += 1
        session.updateDuration()

        currentSession = session
    }

    // MARK: - Detection Logic

    /// Perform a detection check
    private func performDetectionCheck() {
        guard var session = currentSession else { return }

        session.updateDuration()
        currentSession = session

        if isDoomScrolling(session) {
            print("🌀 DOOM SCROLLING DETECTED!")
            // Would trigger intervention here
        }
    }

    /// Determine if current session is doom scrolling
    func isDoomScrolling(_ session: DoomScrollSession) -> Bool {
        // 1. Duration check
        guard session.duration >= AppConstants.defaultTimeThreshold else {
            return false
        }

        // 2. Interaction ratio check (KEY METRIC)
        let interactionRatio = Double(session.interactions) / max(Double(session.scrollEvents), 1.0)
        if interactionRatio > AppConstants.interactionRatioThreshold {
            // More than 10% active - they're engaging, not doom scrolling
            return false
        }

        // 3. Scroll velocity check
        if session.scrollVelocity < AppConstants.minScrollVelocityThreshold {
            // Slow, deliberate scrolling - probably reading
            return false
        }

        // 4. App switching pattern
        if session.appSwitches > AppConstants.maxAppSwitchesForDoomScroll {
            // Context switching = active use
            return false
        }

        // 5. Time of day multiplier
        let hour = Calendar.current.component(.hour, from: session.timeOfDay)
        var doomMultiplier = 1.0

        if AppConstants.lateNightHours.contains(hour) {
            doomMultiplier = 1.5 // Night scrolling is worse
        }

        // All checks passed - this is doom scrolling
        return true
    }

    /// Get a detailed report of current session
    func getSessionReport() -> String {
        guard let session = currentSession else {
            return "No active session"
        }

        let interactionRatio = Double(session.interactions) / max(Double(session.scrollEvents), 1.0)

        return """
        📊 Session Report:
        Duration: \(Int(session.duration))s
        Scroll Events: \(session.scrollEvents)
        Interactions: \(session.interactions)
        Interaction Ratio: \(String(format: "%.2f%%", interactionRatio * 100))
        App Switches: \(session.appSwitches)
        Scroll Velocity: \(String(format: "%.1f", session.scrollVelocity)) px/s
        Is Doom Scrolling: \(isDoomScrolling(session) ? "YES ⚠️" : "NO ✅")
        """
    }

    // MARK: - Statistics

    /// Calculate current doom score based on session
    func calculateCurrentDoomScore() -> Int {
        guard let session = currentSession else { return 0 }

        var score = 0

        // Time spent (0-4 points)
        switch session.duration {
        case 0..<900: score += 0       // < 15 min
        case 900..<1800: score += 1    // 15-30 min
        case 1800..<3600: score += 2   // 30-60 min
        case 3600..<7200: score += 3   // 1-2 hours
        default: score += 4            // 2+ hours
        }

        // Low interaction ratio penalty (0-2 points)
        let interactionRatio = Double(session.interactions) / max(Double(session.scrollEvents), 1.0)
        if interactionRatio < 0.05 { score += 2 }
        else if interactionRatio < 0.1 { score += 1 }

        // High velocity scrolling (0-2 points)
        if session.scrollVelocity > 150 { score += 2 }
        else if session.scrollVelocity > 100 { score += 1 }

        // Late night bonus penalty (0-2 points)
        let hour = Calendar.current.component(.hour, from: session.timeOfDay)
        if AppConstants.lateNightHours.contains(hour) { score += 2 }

        currentDoomScore = min(score, 10)
        return currentDoomScore
    }

    // MARK: - Cleanup

    deinit {
        detectionTimer?.invalidate()
    }
}
