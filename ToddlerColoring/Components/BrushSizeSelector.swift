import SwiftUI

struct BrushSizeSelector: View {
    @EnvironmentObject var viewModel: ColoringViewModel
    let isVertical: Bool

    // Toddler-friendly brush sizes (larger than typical)
    private let sizes: [CGFloat] = [15, 25, 40]
    private let sizeNames = ["Small", "Medium", "Big"]

    var body: some View {
        Group {
            if isVertical {
                VStack(spacing: 8) {
                    ForEach(sizes.indices, id: \.self) { index in
                        BrushSizeButton(
                            size: sizes[index],
                            isSelected: viewModel.brushSize == sizes[index],
                            maxSize: sizes.last ?? 40
                        ) {
                            viewModel.setBrushSize(sizes[index])
                            HapticManager.shared.selection()
                        }
                    }
                }
            } else {
                HStack(spacing: 12) {
                    ForEach(sizes.indices, id: \.self) { index in
                        BrushSizeButton(
                            size: sizes[index],
                            isSelected: viewModel.brushSize == sizes[index],
                            maxSize: sizes.last ?? 40
                        ) {
                            viewModel.setBrushSize(sizes[index])
                            HapticManager.shared.selection()
                        }
                    }
                }
            }
        }
    }
}

struct BrushSizeButton: View {
    let size: CGFloat
    let isSelected: Bool
    let maxSize: CGFloat
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                // Selection background
                if isSelected {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: maxSize + 15, height: maxSize + 15)
                }

                // Button background
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: maxSize + 8, height: maxSize + 8)

                // Size indicator circle
                Circle()
                    .fill(isSelected ? Color.blue : Color.gray)
                    .frame(width: size, height: size)
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

#Preview {
    VStack(spacing: 40) {
        BrushSizeSelector(isVertical: false)
            .frame(width: 200)

        BrushSizeSelector(isVertical: true)
            .frame(height: 200)
    }
    .padding()
    .environmentObject(ColoringViewModel())
}
