import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    static let shared = SoundManager()

    @Published var isSoundEnabled: Bool = true
    @Published var volume: Float = 0.7

    private var audioPlayers: [String: AVAudioPlayer] = [:]

    private init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    // MARK: - Sound Effects

    enum SoundEffect: String {
        case tap = "tap"
        case draw = "draw"
        case colorSelect = "color_select"
        case save = "save"
        case clear = "clear"
        case undo = "undo"
        case success = "success"
        case pop = "pop"
        case swoosh = "swoosh"
    }

    func playSound(_ effect: SoundEffect) {
        guard isSoundEnabled else { return }

        // Since we don't have actual sound files, we'll use system sounds
        // In a real app, you would load custom sound files
        playSystemSound(for: effect)
    }

    private func playSystemSound(for effect: SoundEffect) {
        // Map effects to system sounds
        let soundID: SystemSoundID

        switch effect {
        case .tap:
            soundID = 1104 // Tap sound
        case .draw:
            soundID = 1306 // Subtle sound
        case .colorSelect:
            soundID = 1057 // Selection sound
        case .save:
            soundID = 1001 // Positive sound
        case .clear:
            soundID = 1155 // Warning sound
        case .undo:
            soundID = 1105 // Undo sound
        case .success:
            soundID = 1025 // Success fanfare
        case .pop:
            soundID = 1152 // Pop sound
        case .swoosh:
            soundID = 1004 // Swoosh
        }

        AudioServicesPlaySystemSound(soundID)
    }

    // MARK: - Custom Sound Loading

    func loadSound(named name: String, withExtension ext: String = "wav") {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Sound file not found: \(name).\(ext)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = volume
            audioPlayers[name] = player
        } catch {
            print("Failed to load sound \(name): \(error)")
        }
    }

    func playCustomSound(named name: String) {
        guard isSoundEnabled else { return }
        guard let player = audioPlayers[name] else {
            print("Sound not loaded: \(name)")
            return
        }

        player.volume = volume
        player.currentTime = 0
        player.play()
    }

    // MARK: - Settings

    func toggleSound() {
        isSoundEnabled.toggle()
    }

    func setVolume(_ newVolume: Float) {
        volume = max(0, min(1, newVolume))
        for player in audioPlayers.values {
            player.volume = volume
        }
    }
}

// MARK: - Synthesized Sounds (for when no sound files are available)

extension SoundManager {
    func playSynthesizedNote(frequency: Double = 440, duration: TimeInterval = 0.1) {
        guard isSoundEnabled else { return }

        // This would require AVAudioEngine for actual synthesis
        // For simplicity, we just play a system sound
        AudioServicesPlaySystemSound(1057)
    }

    func playHappyChime() {
        guard isSoundEnabled else { return }

        // Play a sequence of ascending tones
        let sounds: [SystemSoundID] = [1057, 1104, 1025]
        var delay: TimeInterval = 0

        for soundID in sounds {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                AudioServicesPlaySystemSound(soundID)
            }
            delay += 0.15
        }
    }
}
