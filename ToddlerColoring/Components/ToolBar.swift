import SwiftUI

enum DrawingTool: String, CaseIterable {
    case brush = "paintbrush.fill"
    case fill = "drop.fill"
    case eraser = "eraser.fill"

    var displayName: String {
        switch self {
        case .brush: return "Brush"
        case .fill: return "Fill"
        case .eraser: return "Eraser"
        }
    }

    var color: Color {
        switch self {
        case .brush: return .blue
        case .fill: return .green
        case .eraser: return .orange
        }
    }
}

struct ToolBar: View {
    @EnvironmentObject var viewModel: ColoringViewModel
    let onBack: () -> Void
    let onUndo: () -> Void
    let onClear: () -> Void
    let onSave: () -> Void
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
        VStack(spacing: 15) {
            // Back button
            ToolButton(icon: "arrow.left", color: .gray) {
                onBack()
            }

            Divider()
                .padding(.horizontal, 10)

            // Drawing tools
            ForEach(DrawingTool.allCases, id: \.self) { tool in
                ToolButton(
                    icon: tool.rawValue,
                    color: tool.color,
                    isSelected: viewModel.currentTool == tool
                ) {
                    viewModel.selectTool(tool)
                    HapticManager.shared.selection()
                }
            }

            // Brush size selector
            BrushSizeSelector(isVertical: true)
                .frame(height: 80)

            Divider()
                .padding(.horizontal, 10)

            Spacer()

            // Undo button
            ToolButton(icon: "arrow.uturn.backward", color: .purple) {
                onUndo()
            }
            .disabled(viewModel.strokes.isEmpty)
            .opacity(viewModel.strokes.isEmpty ? 0.5 : 1)

            // Clear button
            ToolButton(icon: "trash", color: .red) {
                onClear()
            }
            .disabled(viewModel.strokes.isEmpty)
            .opacity(viewModel.strokes.isEmpty ? 0.5 : 1)

            // Save button
            ToolButton(icon: "square.and.arrow.down", color: .green) {
                onSave()
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 10)
    }

    private var horizontalLayout: some View {
        HStack(spacing: 15) {
            // Back button
            ToolButton(icon: "arrow.left", color: .gray, size: 50) {
                onBack()
            }

            Divider()
                .frame(height: 50)

            // Drawing tools
            ForEach(DrawingTool.allCases, id: \.self) { tool in
                ToolButton(
                    icon: tool.rawValue,
                    color: tool.color,
                    isSelected: viewModel.currentTool == tool,
                    size: 50
                ) {
                    viewModel.selectTool(tool)
                    HapticManager.shared.selection()
                }
            }

            // Brush size selector
            BrushSizeSelector(isVertical: false)
                .frame(width: 150)

            Spacer()

            // Undo button
            ToolButton(icon: "arrow.uturn.backward", color: .purple, size: 50) {
                onUndo()
            }
            .disabled(viewModel.strokes.isEmpty)
            .opacity(viewModel.strokes.isEmpty ? 0.5 : 1)

            // Clear button
            ToolButton(icon: "trash", color: .red, size: 50) {
                onClear()
            }
            .disabled(viewModel.strokes.isEmpty)
            .opacity(viewModel.strokes.isEmpty ? 0.5 : 1)

            // Save button
            ToolButton(icon: "square.and.arrow.down", color: .green, size: 50) {
                onSave()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

struct ToolButton: View {
    let icon: String
    let color: Color
    var isSelected: Bool = false
    var size: CGFloat = 45
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: size + 8, height: size + 8)
                }

                Circle()
                    .fill(isSelected ? color : Color.gray.opacity(0.1))
                    .frame(width: size, height: size)

                Image(systemName: icon)
                    .font(.system(size: size * 0.45))
                    .foregroundColor(isSelected ? .white : color)
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
    VStack {
        ToolBar(
            onBack: {},
            onUndo: {},
            onClear: {},
            onSave: {},
            isVertical: false
        )
        .frame(height: 100)

        ToolBar(
            onBack: {},
            onUndo: {},
            onClear: {},
            onSave: {},
            isVertical: true
        )
        .frame(width: 100, height: 500)
    }
    .padding()
    .environmentObject(ColoringViewModel())
}
