import SwiftUI

struct AppColors {
    // Bright, toddler-friendly colors
    static let rainbow: [Color] = [
        Color(red: 1.0, green: 0.2, blue: 0.2),     // Red
        Color(red: 1.0, green: 0.5, blue: 0.0),     // Orange
        Color(red: 1.0, green: 0.85, blue: 0.0),    // Yellow
        Color(red: 0.2, green: 0.8, blue: 0.2),     // Green
        Color(red: 0.0, green: 0.7, blue: 1.0),     // Light Blue
        Color(red: 0.3, green: 0.3, blue: 0.9),     // Blue
        Color(red: 0.6, green: 0.2, blue: 0.8),     // Purple
        Color(red: 1.0, green: 0.4, blue: 0.7),     // Pink
        Color(red: 0.6, green: 0.4, blue: 0.2),     // Brown
        Color(red: 0.1, green: 0.1, blue: 0.1),     // Black
        Color(red: 0.5, green: 0.5, blue: 0.5),     // Gray
        Color(red: 1.0, green: 1.0, blue: 1.0)      // White (eraser visual)
    ]

    static let pastel: [Color] = [
        Color(red: 1.0, green: 0.7, blue: 0.7),     // Light Red
        Color(red: 1.0, green: 0.8, blue: 0.6),     // Light Orange
        Color(red: 1.0, green: 1.0, blue: 0.7),     // Light Yellow
        Color(red: 0.7, green: 1.0, blue: 0.7),     // Light Green
        Color(red: 0.7, green: 0.9, blue: 1.0),     // Light Blue
        Color(red: 0.8, green: 0.7, blue: 1.0),     // Light Purple
        Color(red: 1.0, green: 0.8, blue: 0.9),     // Light Pink
        Color(red: 0.9, green: 0.8, blue: 0.7)      // Light Brown
    ]

    static var all: [Color] {
        rainbow + pastel
    }
}

struct ColorPalette: View {
    @EnvironmentObject var viewModel: ColoringViewModel
    let isVertical: Bool

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .black.opacity(0.1), radius: 10)

            if isVertical {
                verticalLayout
            } else {
                horizontalLayout
            }
        }
    }

    private var verticalLayout: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 8) {
                ForEach(AppColors.rainbow.indices, id: \.self) { index in
                    ColorButton(
                        color: AppColors.rainbow[index],
                        isSelected: viewModel.selectedColor == AppColors.rainbow[index],
                        size: 50
                    ) {
                        viewModel.selectColor(AppColors.rainbow[index])
                        HapticManager.shared.selection()
                    }
                }
            }
            .padding(.vertical, 15)
        }
        .padding(.horizontal, 10)
    }

    private var horizontalLayout: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(AppColors.rainbow.indices, id: \.self) { index in
                    ColorButton(
                        color: AppColors.rainbow[index],
                        isSelected: viewModel.selectedColor == AppColors.rainbow[index],
                        size: 60
                    ) {
                        viewModel.selectColor(AppColors.rainbow[index])
                        HapticManager.shared.selection()
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 10)
    }
}

struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let size: CGFloat
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                // Selection ring
                if isSelected {
                    Circle()
                        .stroke(Color.gray, lineWidth: 4)
                        .frame(width: size + 10, height: size + 10)
                }

                // Color circle
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
                    .shadow(color: color.opacity(0.5), radius: isSelected ? 8 : 4, y: 2)

                // White border for visibility
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: size, height: size)

                // Checkmark for selected
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: size * 0.35, weight: .bold))
                        .foregroundColor(color.isLight ? .black : .white)
                }
            }
        }
        .scaleEffect(isPressed ? 0.9 : 1)
        .animation(.spring(response: 0.3), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

extension Color {
    var isLight: Bool {
        guard let components = UIColor(self).cgColor.components else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.5
    }
}

#Preview {
    HStack {
        ColorPalette(isVertical: true)
            .frame(width: 100, height: 400)

        ColorPalette(isVertical: false)
            .frame(width: 400, height: 120)
    }
    .padding()
    .environmentObject(ColoringViewModel())
}
