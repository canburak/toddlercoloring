import SwiftUI

struct AnimatedButton<Content: View>: View {
    let action: () -> Void
    let content: () -> Content

    @State private var isPressed = false
    @State private var showRipple = false

    init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }

    var body: some View {
        Button(action: {
            action()
            triggerRipple()
        }) {
            ZStack {
                content()

                // Ripple effect
                if showRipple {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .scaleEffect(showRipple ? 2 : 0)
                        .opacity(showRipple ? 0 : 1)
                }
            }
        }
        .scaleEffect(isPressed ? 0.92 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }

    private func triggerRipple() {
        withAnimation(.easeOut(duration: 0.4)) {
            showRipple = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showRipple = false
        }
    }
}

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct WiggleModifier: ViewModifier {
    @State private var isWiggling = false
    let duration: Double
    let angle: Double

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isWiggling ? angle : -angle))
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isWiggling
            )
            .onAppear {
                isWiggling = true
            }
    }
}

struct PulseModifier: ViewModifier {
    @State private var isPulsing = false
    let minScale: CGFloat
    let maxScale: CGFloat
    let duration: Double

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? maxScale : minScale)
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

extension View {
    func wiggle(duration: Double = 0.15, angle: Double = 2) -> some View {
        modifier(WiggleModifier(duration: duration, angle: angle))
    }

    func pulse(minScale: CGFloat = 0.95, maxScale: CGFloat = 1.05, duration: Double = 0.8) -> some View {
        modifier(PulseModifier(minScale: minScale, maxScale: maxScale, duration: duration))
    }
}

#Preview {
    VStack(spacing: 30) {
        AnimatedButton(action: {}) {
            Text("Tap Me!")
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
        }

        Text("Wiggling")
            .font(.title)
            .wiggle()

        Circle()
            .fill(Color.green)
            .frame(width: 50, height: 50)
            .pulse()
    }
}
