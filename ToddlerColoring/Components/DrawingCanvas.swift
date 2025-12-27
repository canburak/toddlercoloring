import SwiftUI

struct DrawingCanvas: View {
    @EnvironmentObject var viewModel: ColoringViewModel
    let coloringPage: ColoringPage?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // White background
                Color.white

                // Coloring page outline (if any)
                if let page = coloringPage {
                    page.outlineShape
                        .stroke(Color.black, lineWidth: 3)
                        .padding(20)
                }

                // Drawing layer
                Canvas { context, size in
                    // Draw all completed strokes
                    for stroke in viewModel.strokes {
                        drawStroke(stroke, in: &context, size: size)
                    }

                    // Draw current stroke
                    if let currentStroke = viewModel.currentStroke {
                        drawStroke(currentStroke, in: &context, size: size)
                    }
                }

                // Touch handling overlay
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                handleDrag(value, in: geometry.size)
                            }
                            .onEnded { value in
                                handleDragEnd(value, in: geometry.size)
                            }
                    )
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                // Handle tap for fill tool
                                if viewModel.currentTool == .fill {
                                    // Fill would be handled here
                                    HapticManager.shared.impact(.medium)
                                }
                            }
                    )
            }
        }
    }

    private func drawStroke(_ stroke: Stroke, in context: inout GraphicsContext, size: CGSize) {
        guard stroke.points.count > 0 else { return }

        var path = Path()

        if stroke.points.count == 1 {
            // Single point - draw a circle
            let point = stroke.points[0]
            let rect = CGRect(
                x: point.x - stroke.width / 2,
                y: point.y - stroke.width / 2,
                width: stroke.width,
                height: stroke.width
            )
            path.addEllipse(in: rect)
        } else {
            // Multiple points - draw a smooth line
            path.move(to: stroke.points[0])

            if stroke.points.count == 2 {
                path.addLine(to: stroke.points[1])
            } else {
                for i in 1..<stroke.points.count {
                    let mid = CGPoint(
                        x: (stroke.points[i - 1].x + stroke.points[i].x) / 2,
                        y: (stroke.points[i - 1].y + stroke.points[i].y) / 2
                    )
                    path.addQuadCurve(to: mid, control: stroke.points[i - 1])
                }
                path.addLine(to: stroke.points.last!)
            }
        }

        // Apply stroke style
        context.stroke(
            path,
            with: .color(stroke.color),
            style: StrokeStyle(
                lineWidth: stroke.width,
                lineCap: .round,
                lineJoin: .round
            )
        )
    }

    private func handleDrag(_ value: DragGesture.Value, in size: CGSize) {
        let point = value.location

        // Clamp point to canvas bounds
        let clampedPoint = CGPoint(
            x: max(0, min(size.width, point.x)),
            y: max(0, min(size.height, point.y))
        )

        if viewModel.currentStroke == nil {
            // Start new stroke
            viewModel.startStroke(at: clampedPoint)
            HapticManager.shared.impact(.light)
        } else {
            // Continue stroke
            viewModel.continueStroke(to: clampedPoint)
        }
    }

    private func handleDragEnd(_ value: DragGesture.Value, in size: CGSize) {
        viewModel.endStroke()
    }
}

struct Stroke: Identifiable {
    let id = UUID()
    var points: [CGPoint]
    let color: Color
    let width: CGFloat
    let tool: DrawingTool

    init(points: [CGPoint] = [], color: Color, width: CGFloat, tool: DrawingTool) {
        self.points = points
        self.color = tool == .eraser ? .white : color
        self.width = tool == .eraser ? width * 2 : width
        self.tool = tool
    }
}

#Preview {
    DrawingCanvas(coloringPage: nil)
        .frame(width: 400, height: 400)
        .environmentObject(ColoringViewModel())
}
