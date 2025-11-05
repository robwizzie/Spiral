//
//  ScreenTimeMonitor.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import Foundation
import FamilyControls
import DeviceActivity
import SwiftUI

/// Monitors screen time and triggers doom scroll detection
@MainActor
class ScreenTimeMonitor: ObservableObject {
    // MARK: - Published Properties

    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    @Published var isMonitoring: Bool = false
    @Published var currentSession: ScrollSession?

    // MARK: - Private Properties

    private let center = AuthorizationCenter.shared
    private let activityCenter = DeviceActivityCenter()

    // MARK: - Authorization

    /// Request Screen Time authorization from the user
    func requestAuthorization() async throws {
        do {
            try await center.requestAuthorization(for: .individual)
            authorizationStatus = center.authorizationStatus
        } catch {
            print("❌ Failed to request Screen Time authorization: \(error)")
            throw error
        }
    }

    /// Check current authorization status
    func checkAuthorizationStatus() {
        authorizationStatus = center.authorizationStatus
    }

    // MARK: - Monitoring

    /// Start monitoring screen time for doom scroll detection
    func startMonitoring() {
        guard authorizationStatus == .approved else {
            print("⚠️ Cannot start monitoring: Screen Time not authorized")
            return
        }

        // Create schedule for monitoring (all day, every day)
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        // Create activity name
        let activityName = DeviceActivityName("com.spiral.monitoring")

        do {
            try activityCenter.startMonitoring(activityName, during: schedule)
            isMonitoring = true
            print("✅ Screen Time monitoring started")
        } catch {
            print("❌ Failed to start monitoring: \(error)")
        }
    }

    /// Stop monitoring screen time
    func stopMonitoring() {
        let activityName = DeviceActivityName("com.spiral.monitoring")
        activityCenter.stopMonitoring([activityName])
        isMonitoring = false
        print("⏹️ Screen Time monitoring stopped")
    }

    // MARK: - Session Tracking

    /// Start a new scroll session
    func startSession(appName: String) {
        currentSession = ScrollSession(
            startTime: Date(),
            appName: appName
        )
        print("📱 Started session for \(appName)")
    }

    /// End the current scroll session
    func endSession() {
        guard let session = currentSession else { return }

        var updatedSession = session
        updatedSession.endTime = Date()
        updatedSession.duration = Date().timeIntervalSince(session.startTime)

        // TODO: Save session to SwiftData

        currentSession = nil
        print("⏹️ Ended session: \(updatedSession.duration)s")
    }

    /// Track a scroll event in the current session
    func trackScrollEvent() {
        guard var session = currentSession else { return }
        session.scrollEvents += 1
        currentSession = session
    }

    /// Track an interaction (like, comment, post, etc.)
    func trackInteraction() {
        guard var session = currentSession else { return }
        session.interactions += 1
        currentSession = session
    }

    /// Track an app switch
    func trackAppSwitch() {
        guard var session = currentSession else { return }
        session.appSwitches += 1
        currentSession = session
    }

    // MARK: - Doom Scroll Detection

    /// Check if current session qualifies as doom scrolling
    func checkDoomScrollStatus() -> Bool {
        guard let session = currentSession else { return false }

        // Check duration threshold
        guard session.duration >= AppConstants.defaultTimeThreshold else { return false }

        // Check if it's active doom scrolling
        return session.isActiveDoomScrolling
    }

    /// Trigger intervention based on current session
    func triggerIntervention(mode: InterventionMode, interventionsToday: Int) {
        guard let session = currentSession else { return }

        print("🌀 DOOM SCROLL DETECTED - Triggering intervention")

        // Mark session as interrupted
        var updatedSession = session
        updatedSession.wasInterrupted = true
        currentSession = updatedSession

        // TODO: Show InterventionView
        // This would be handled by the app's main coordinator/navigation
    }
}

// MARK: - Helper Types

extension ScreenTimeMonitor {
    /// Get authorization status as a readable string
    var authorizationStatusString: String {
        switch authorizationStatus {
        case .notDetermined:
            return "Not Determined"
        case .denied:
            return "Denied"
        case .approved:
            return "Approved"
        @unknown default:
            return "Unknown"
        }
    }
}
