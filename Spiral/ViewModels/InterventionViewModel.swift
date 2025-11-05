//
//  InterventionViewModel.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class InterventionViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var roastMessage: String = ""
    @Published var duration: TimeInterval = 0
    @Published var waitTime: Int = 0
    @Published var canDismiss: Bool = true
    @Published var dismissalsToday: Int = 0
    @Published var note: String = ""
    @Published var selectedResponse: ResponseType?
    @Published var taskCompleted: Bool = false
    @Published var lockdownChallenge: String = ""
    @Published var userAnswer: String = ""

    // MARK: - Properties

    let mode: InterventionMode
    let context: InterventionContext
    private let roastEngine = RoastEngine()
    private var timer: Timer?
    private let maxDismissals = AppConstants.maxDismissalsPerDay
    private var onDismiss: (() -> Void)?

    // Lockdown challenge answer
    private var correctAnswer: Int = 0

    // MARK: - Initialization

    init(
        mode: InterventionMode,
        duration: TimeInterval,
        interventionsToday: Int = 0,
        dismissalsToday: Int = 0,
        onDismiss: (() -> Void)? = nil
    ) {
        self.mode = mode
        self.duration = duration
        self.dismissalsToday = dismissalsToday
        self.onDismiss = onDismiss

        let hour = Calendar.current.component(.hour, from: Date())
        self.context = InterventionContext(
            interventionsToday: interventionsToday,
            hour: hour,
            scrollDuration: duration,
            doomScore: 0, // Would be fetched from UserStats
            currentStreak: 0 // Would be fetched from UserStats
        )

        // Generate roast message
        self.roastMessage = roastEngine.selectRoast(context: context)

        // Setup based on mode
        setupMode()
    }

    // MARK: - Setup

    private func setupMode() {
        switch mode {
        case .gentle:
            canDismiss = true

        case .accountability:
            waitTime = AppConstants.accountabilityWaitTime
            canDismiss = false
            startCountdown()

        case .lockdown:
            canDismiss = false
            taskCompleted = false
            generateLockdownChallenge()
        }
    }

    // MARK: - Accountability Mode

    private func startCountdown() {
        guard mode == .accountability else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            Task { @MainActor in
                if self.waitTime > 0 {
                    self.waitTime -= 1
                } else {
                    self.timer?.invalidate()
                    self.updateCanDismiss()
                }
            }
        }
    }

    private func updateCanDismiss() {
        switch mode {
        case .gentle:
            canDismiss = true

        case .accountability:
            canDismiss = waitTime == 0 && dismissalsToday < maxDismissals

        case .lockdown:
            canDismiss = taskCompleted
        }
    }

    // MARK: - Lockdown Mode

    private func generateLockdownChallenge() {
        let num1 = Int.random(in: 10...50)
        let num2 = Int.random(in: 10...50)
        correctAnswer = num1 + num2
        lockdownChallenge = "What's \(num1) + \(num2)?"
    }

    func checkAnswer() {
        guard mode == .lockdown else { return }

        if let answer = Int(userAnswer), answer == correctAnswer {
            taskCompleted = true
            updateCanDismiss()
        }
    }

    func startWaitTimer() {
        guard mode == .lockdown else { return }

        waitTime = 60 // 60 seconds for lockdown

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            Task { @MainActor in
                if self.waitTime > 0 {
                    self.waitTime -= 1
                } else {
                    self.timer?.invalidate()
                    self.taskCompleted = true
                    self.updateCanDismiss()
                }
            }
        }
    }

    // MARK: - User Actions

    func recordResponse(_ response: ResponseType, note: String = "") {
        selectedResponse = response
        self.note = note

        // Here we would save to SwiftData
        // For now, just track the response
    }

    func dismiss() {
        timer?.invalidate()

        // Track dismissal for accountability mode
        if mode == .accountability {
            dismissalsToday += 1

            // Check if we need to switch to lockdown
            if dismissalsToday >= maxDismissals {
                // Would trigger lockdown mode
                print("⚠️ Maximum dismissals reached. Switching to lockdown mode.")
            }
        }

        onDismiss?()
    }

    // MARK: - Haptics & Sound

    func triggerHaptics() {
        switch mode {
        case .gentle:
            HapticsManager.shared.playGentlePattern()

        case .accountability:
            HapticsManager.shared.playAccountabilityPattern()

        case .lockdown:
            HapticsManager.shared.playLockdownPattern()
        }

        // Also play spiral breaking haptic
        HapticsManager.shared.playSpiralBreakPattern()
    }

    func playSound() {
        SoundManager.shared.play(.intervention)
    }

    // MARK: - Formatted Properties

    var durationFormatted: String {
        let minutes = Int(duration / 60)
        if minutes < 60 {
            return "\(minutes) minutes"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours)h \(remainingMinutes)m"
        }
    }

    var interventionHeader: String {
        roastEngine.getInterventionHeader(mode: mode, context: context)
    }

    var durationMessage: String {
        roastEngine.getDurationMessage(duration: duration)
    }

    // MARK: - Cleanup

    deinit {
        timer?.invalidate()
    }
}
