import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ColoringViewModel
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                NavigationStack {
                    HomeView()
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .onAppear {
            // Show splash for 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Rainbow gradient background
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.8, blue: 0.9),
                    Color(red: 0.8, green: 0.9, blue: 1.0),
                    Color(red: 0.9, green: 1.0, blue: 0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // Animated crayon icons
                HStack(spacing: 20) {
                    ForEach(AppColors.rainbow.prefix(5), id: \.self) { color in
                        CrayonIcon(color: color)
                            .rotationEffect(.degrees(rotation))
                    }
                }
                .scaleEffect(scale)
                .opacity(opacity)

                // App title
                Text("Toddler Coloring")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue, .green],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(scale)
                    .opacity(opacity)

                // Fun subtitle
                Text("Let's Color!")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundColor(.orange)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                rotation = 5
            }
        }
    }
}

struct CrayonIcon: View {
    let color: Color

    var body: some View {
        ZStack {
            // Crayon body
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 20, height: 60)

            // Crayon tip
            Triangle()
                .fill(color.opacity(0.8))
                .frame(width: 20, height: 15)
                .offset(y: -37)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ContentView()
        .environmentObject(ColoringViewModel())
}
