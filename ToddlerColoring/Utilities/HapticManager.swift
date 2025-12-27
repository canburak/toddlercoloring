import UIKit
import CoreHaptics

class HapticManager {
    static let shared = HapticManager()

    private var engine: CHHapticEngine?
    private var isHapticsEnabled: Bool = true

    private init() {
        setupHapticEngine()
    }

    private func setupHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()

            // Restart engine when it stops
            engine?.stoppedHandler = { [weak self] reason in
                print("Haptic engine stopped: \(reason)")
                self?.restartEngine()
            }

            engine?.resetHandler = { [weak self] in
                print("Haptic engine reset")
                self?.restartEngine()
            }
        } catch {
            print("Failed to create haptic engine: \(error)")
        }
    }

    private func restartEngine() {
        do {
            try engine?.start()
        } catch {
            print("Failed to restart haptic engine: \(error)")
        }
    }

    // MARK: - Simple Haptics (UIKit)

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard isHapticsEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isHapticsEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    func selection() {
        guard isHapticsEnabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    // MARK: - Custom Haptics (Core Haptics)

    func playCustomHaptic(intensity: Float, sharpness: Float, duration: TimeInterval = 0.1) {
        guard isHapticsEnabled,
              CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }

        let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)

        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensityParam, sharpnessParam],
            relativeTime: 0,
            duration: duration
        )

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play custom haptic: \(error)")
        }
    }

    // MARK: - Toddler-Friendly Haptic Patterns

    func playDrawingStart() {
        playCustomHaptic(intensity: 0.4, sharpness: 0.3)
    }

    func playColorSelect() {
        playCustomHaptic(intensity: 0.6, sharpness: 0.8)
    }

    func playSaveSuccess() {
        guard isHapticsEnabled,
              CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else {
            notification(.success)
            return
        }

        // Happy pattern - two quick taps followed by a longer one
        let events: [CHHapticEvent] = [
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ],
                relativeTime: 0
            ),
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6)
                ],
                relativeTime: 0.1
            ),
            CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
                ],
                relativeTime: 0.2,
                duration: 0.2
            )
        ]

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play save success haptic: \(error)")
            notification(.success)
        }
    }

    func playClearWarning() {
        guard isHapticsEnabled,
              CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else {
            notification(.warning)
            return
        }

        // Warning pattern - gentle rumble
        let events: [CHHapticEvent] = [
            CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
                ],
                relativeTime: 0,
                duration: 0.3
            )
        ]

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play clear warning haptic: \(error)")
            notification(.warning)
        }
    }

    // MARK: - Settings

    func setHapticsEnabled(_ enabled: Bool) {
        isHapticsEnabled = enabled
    }

    var hapticsEnabled: Bool {
        isHapticsEnabled
    }
}
