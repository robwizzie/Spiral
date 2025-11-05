//
//  SoundManager.swift
//  Spiral
//
//  Created by Robert Wiscount on 11/5/25.
//

import Foundation
import AVFoundation

/// Manages audio playback for app sounds
class SoundManager: ObservableObject {
    static let shared = SoundManager()

    // MARK: - Sound Types

    enum SoundType: String {
        case intervention = "intervention"
        case success = "success"
        case `break` = "break"
        case achievement = "achievement"

        var filename: String {
            rawValue
        }
    }

    // MARK: - Private Properties

    private var players: [SoundType: AVAudioPlayer] = [:]
    private var isSoundEnabled: Bool {
        UserDefaults.standard.object(forKey: "soundEnabled") as? Bool ?? true
    }

    private var volume: Float {
        UserDefaults.standard.object(forKey: "soundVolume") as? Float ?? 0.8
    }

    // MARK: - Initialization

    private init() {
        setupAudioSession()
        preloadSounds()
    }

    // MARK: - Setup

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ Failed to setup audio session: \(error)")
        }
    }

    private func preloadSounds() {
        // Preload all sounds for instant playback
        for soundType in SoundType.allCases {
            loadSound(soundType)
        }
    }

    private func loadSound(_ soundType: SoundType) {
        // In a real app, you would load actual audio files
        // For now, we'll use system sounds as placeholders

        // Note: Actual sound files would be added to the project
        // and loaded like this:
        /*
        guard let url = Bundle.main.url(forResource: soundType.filename, withExtension: "mp3") else {
            print("❌ Sound file not found: \(soundType.filename)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = volume
            players[soundType] = player
        } catch {
            print("❌ Failed to load sound: \(error)")
        }
        */
    }

    // MARK: - Playback

    /// Play a sound effect
    func play(_ soundType: SoundType) {
        guard isSoundEnabled else { return }

        // System sound fallback (since we don't have actual audio files yet)
        playSystemSound(for: soundType)

        // Actual implementation would use:
        /*
        players[soundType]?.play()
        */
    }

    private func playSystemSound(for soundType: SoundType) {
        // Use system sounds as placeholders
        let systemSoundID: SystemSoundID

        switch soundType {
        case .intervention:
            systemSoundID = 1053 // Tock sound
        case .success:
            systemSoundID = 1054 // New mail sound
        case .break:
            systemSoundID = 1057 // Anticipate sound
        case .achievement:
            systemSoundID = 1025 // Fanfare/Success
        }

        AudioServicesPlaySystemSound(systemSoundID)
    }

    /// Stop a currently playing sound
    func stop(_ soundType: SoundType) {
        players[soundType]?.stop()
    }

    /// Stop all sounds
    func stopAll() {
        players.values.forEach { $0.stop() }
    }

    // MARK: - Settings

    /// Update volume for all sounds
    func setVolume(_ newVolume: Float) {
        let clampedVolume = max(0.0, min(1.0, newVolume))
        UserDefaults.standard.set(clampedVolume, forKey: "soundVolume")

        players.values.forEach { player in
            player.volume = clampedVolume
        }
    }

    /// Enable or disable sounds
    func setSoundEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "soundEnabled")

        if !enabled {
            stopAll()
        }
    }
}

// MARK: - SoundType CaseIterable

extension SoundManager.SoundType: CaseIterable {}
