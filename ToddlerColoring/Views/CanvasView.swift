import SwiftUI

struct CanvasView: View {
    @EnvironmentObject var viewModel: ColoringViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showSaveConfirmation = false
    @State private var showClearConfirmation = false
    @State private var savedSuccessfully = false

    let coloringPage: ColoringPage?

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let toolbarWidth: CGFloat = isLandscape ? 100 : 0
            let toolbarHeight: CGFloat = isLandscape ? 0 : 100
            let paletteWidth: CGFloat = isLandscape ? 100 : 0
            let paletteHeight: CGFloat = isLandscape ? 0 : 120
            let canvasWidth = geometry.size.width - toolbarWidth - paletteWidth
            let canvasHeight = geometry.size.height - toolbarHeight - paletteHeight

            ZStack {
                Color(red: 0.95, green: 0.95, blue: 0.97)
                    .ignoresSafeArea()

                if isLandscape {
                    // Landscape layout
                    HStack(spacing: 0) {
                        // Left toolbar
                        ToolBar(
                            onBack: { dismiss() },
                            onUndo: { viewModel.undo() },
                            onClear: { showClearConfirmation = true },
                            onSave: { saveDrawing() },
                            isVertical: true
                        )
                        .frame(width: toolbarWidth)

                        // Canvas
                        canvasArea(width: canvasWidth, height: canvasHeight)

                        // Right color palette
                        ColorPalette(isVertical: true)
                            .frame(width: paletteWidth)
                    }
                } else {
                    // Portrait layout
                    VStack(spacing: 0) {
                        // Top toolbar
                        ToolBar(
                            onBack: { dismiss() },
                            onUndo: { viewModel.undo() },
                            onClear: { showClearConfirmation = true },
                            onSave: { saveDrawing() },
                            isVertical: false
                        )
                        .frame(height: toolbarHeight)

                        // Canvas
                        canvasArea(width: canvasWidth, height: canvasHeight)

                        // Bottom color palette
                        ColorPalette(isVertical: false)
                            .frame(height: paletteHeight)
                    }
                }

                // Save confirmation overlay
                if savedSuccessfully {
                    SavedOverlay()
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Clear Drawing?", isPresented: $showClearConfirmation) {
            Button("Clear", role: .destructive) {
                viewModel.clearCanvas()
                HapticManager.shared.notification(.warning)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will erase everything. Are you sure?")
        }
        .onAppear {
            viewModel.setColoringPage(coloringPage)
        }
    }

    @ViewBuilder
    private func canvasArea(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            // White canvas background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                .padding(10)

            // Drawing canvas
            DrawingCanvas(coloringPage: coloringPage)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(15)
        }
        .frame(width: width, height: height)
    }

    private func saveDrawing() {
        viewModel.saveCurrentDrawing { success in
            if success {
                savedSuccessfully = true
                HapticManager.shared.notification(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        savedSuccessfully = false
                    }
                }
            }
        }
    }
}

struct SavedOverlay: View {
    @State private var scale: CGFloat = 0.5

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)

                Text("Saved!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white.opacity(0.9))
                    .shadow(radius: 20)
            )
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1
            }
        }
    }
}

#Preview {
    CanvasView(coloringPage: nil)
        .environmentObject(ColoringViewModel())
}
