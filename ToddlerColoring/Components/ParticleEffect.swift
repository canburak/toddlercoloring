import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var color: Color
    var size: CGFloat
    var opacity: Double
    var rotation: Double
    var rotationSpeed: Double
}

struct ParticleEmitter: View {
    let particleCount: Int
    let colors: [Color]
    let particleSize: ClosedRange<CGFloat>
    let duration: Double

    @State private var particles: [Particle] = []
    @State private var isAnimating = false

    init(
        particleCount: Int = 30,
        colors: [Color] = AppColors.rainbow,
        particleSize: ClosedRange<CGFloat> = 10...25,
        duration: Double = 1.5
    ) {
        self.particleCount = particleCount
        self.colors = colors
        self.particleSize = particleSize
        self.duration = duration
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    ParticleView(particle: particle)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
                startAnimation()
            }
        }
    }

    private func createParticles(in size: CGSize) {
        particles = (0..<particleCount).map { _ in
            Particle(
                position: CGPoint(x: size.width / 2, y: size.height / 2),
                velocity: CGPoint(
                    x: CGFloat.random(in: -200...200),
                    y: CGFloat.random(in: -300...(-50))
                ),
                color: colors.randomElement() ?? .blue,
                size: CGFloat.random(in: particleSize),
                opacity: 1.0,
                rotation: Double.random(in: 0...360),
                rotationSpeed: Double.random(in: -180...180)
            )
        }
    }

    private func startAnimation() {
        isAnimating = true

        // Animate particles
        withAnimation(.easeOut(duration: duration)) {
            for i in particles.indices {
                particles[i].position.x += particles[i].velocity.x
                particles[i].position.y += particles[i].velocity.y + 100 // gravity effect
                particles[i].opacity = 0
                particles[i].rotation += particles[i].rotationSpeed
            }
        }
    }
}

struct ParticleView: View {
    let particle: Particle

    var body: some View {
        particle.shape
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .rotationEffect(.degrees(particle.rotation))
            .position(particle.position)
            .opacity(particle.opacity)
    }
}

extension Particle {
    var shape: AnyShape {
        switch Int.random(in: 0...2) {
        case 0:
            AnyShape(Circle())
        case 1:
            AnyShape(Rectangle())
        default:
            AnyShape(Star(corners: 5, smoothness: 0.45))
        }
    }
}

struct Star: Shape {
    let corners: Int
    let smoothness: CGFloat

    func path(in rect: CGRect) -> Path {
        guard corners >= 2 else { return Path() }

        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        var currentAngle = -CGFloat.pi / 2
        let angleAdjustment = .pi * 2 / CGFloat(corners * 2)
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness

        var path = Path()

        for corner in 0..<corners * 2 {
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: CGFloat

            if corner.isMultiple(of: 2) {
                bottom = center.y * 1
            } else {
                bottom = innerY
            }

            let point = CGPoint(
                x: center.x + cosAngle * (corner.isMultiple(of: 2) ? center.x : innerX),
                y: center.y + sinAngle * bottom
            )

            if corner == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }

            currentAngle += angleAdjustment
        }

        path.closeSubpath()
        return path
    }
}

struct ConfettiView: View {
    @Binding var isShowing: Bool
    let colors: [Color]

    var body: some View {
        ZStack {
            if isShowing {
                ParticleEmitter(
                    particleCount: 50,
                    colors: colors,
                    particleSize: 8...20,
                    duration: 2.0
                )
                .allowsHitTesting(false)
            }
        }
        .onChange(of: isShowing) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isShowing = false
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)

        ParticleEmitter()
            .frame(width: 300, height: 300)
    }
}
