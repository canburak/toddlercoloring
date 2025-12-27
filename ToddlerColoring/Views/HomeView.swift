import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ColoringViewModel
    @State private var animateButtons = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Playful background
                BackgroundView()

                VStack(spacing: 40) {
                    // Title
                    Text("What do you want to do?")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.top, 40)

                    // Main menu buttons
                    HStack(spacing: 40) {
                        // Color a Picture
                        NavigationLink(destination: PageSelectionView()) {
                            MenuButton(
                                title: "Color a Picture",
                                icon: "paintpalette.fill",
                                colors: [.orange, .pink],
                                size: min(geometry.size.width * 0.35, 280)
                            )
                        }
                        .scaleEffect(animateButtons ? 1 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: animateButtons)

                        // Free Draw
                        NavigationLink(destination: CanvasView(coloringPage: nil)) {
                            MenuButton(
                                title: "Free Draw",
                                icon: "pencil.tip.crop.circle.fill",
                                colors: [.blue, .purple],
                                size: min(geometry.size.width * 0.35, 280)
                            )
                        }
                        .scaleEffect(animateButtons ? 1 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: animateButtons)
                    }

                    // Secondary button - Gallery
                    NavigationLink(destination: GalleryView()) {
                        HStack(spacing: 15) {
                            Image(systemName: "photo.stack.fill")
                                .font(.system(size: 28))
                            Text("My Drawings")
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.green, .teal],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .green.opacity(0.4), radius: 10, y: 5)
                        )
                    }
                    .scaleEffect(animateButtons ? 1 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3), value: animateButtons)

                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            animateButtons = true
            HapticManager.shared.impact(.light)
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let colors: [Color]
    let size: CGFloat

    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: size * 0.5, height: size * 0.5)

                Image(systemName: icon)
                    .font(.system(size: size * 0.2))
                    .foregroundColor(.white)
            }

            // Title
            Text(title)
                .font(.system(size: size * 0.1, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: size, height: size)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: colors[0].opacity(0.4), radius: 15, y: 10)
        )
        .scaleEffect(isPressed ? 0.95 : 1)
        .animation(.spring(response: 0.3), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in
                    isPressed = false
                    HapticManager.shared.impact(.medium)
                }
        )
    }
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.95, blue: 1.0),
                    Color(red: 0.95, green: 0.98, blue: 1.0),
                    Color(red: 1.0, green: 0.98, blue: 0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative circles
            GeometryReader { geometry in
                // Top left decoration
                Circle()
                    .fill(Color.pink.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .offset(x: -50, y: -50)

                // Top right decoration
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 150, height: 150)
                    .offset(x: geometry.size.width - 100, y: 50)

                // Bottom left decoration
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 180, height: 180)
                    .offset(x: 30, y: geometry.size.height - 150)

                // Bottom right decoration
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 220, height: 220)
                    .offset(x: geometry.size.width - 150, y: geometry.size.height - 200)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(ColoringViewModel())
}
