import SwiftUI
import Combine

@MainActor
class ColoringViewModel: ObservableObject {
    // Drawing state
    @Published var strokes: [Stroke] = []
    @Published var currentStroke: Stroke?
    @Published var selectedColor: Color = AppColors.rainbow[0]
    @Published var brushSize: CGFloat = 25
    @Published var currentTool: DrawingTool = .brush

    // Coloring page
    @Published var currentColoringPage: ColoringPage?

    // Undo history
    private var undoStack: [[Stroke]] = []
    private let maxUndoSteps = 20

    // Canvas size for saving
    var canvasSize: CGSize = .zero

    init() {
        // Default state is set above
    }

    // MARK: - Color Selection

    func selectColor(_ color: Color) {
        selectedColor = color
        // If eraser is selected and user picks a color, switch to brush
        if currentTool == .eraser {
            currentTool = .brush
        }
    }

    // MARK: - Tool Selection

    func selectTool(_ tool: DrawingTool) {
        currentTool = tool
    }

    // MARK: - Brush Size

    func setBrushSize(_ size: CGFloat) {
        brushSize = size
    }

    // MARK: - Drawing

    func startStroke(at point: CGPoint) {
        let stroke = Stroke(
            points: [point],
            color: selectedColor,
            width: brushSize,
            tool: currentTool
        )
        currentStroke = stroke
    }

    func continueStroke(to point: CGPoint) {
        guard var stroke = currentStroke else { return }

        // Add point only if it's far enough from the last point (reduces jitter)
        if let lastPoint = stroke.points.last {
            let distance = hypot(point.x - lastPoint.x, point.y - lastPoint.y)
            if distance > 2 {
                stroke.points.append(point)
                currentStroke = stroke
            }
        } else {
            stroke.points.append(point)
            currentStroke = stroke
        }
    }

    func endStroke() {
        guard let stroke = currentStroke else { return }

        // Save current state for undo
        saveUndoState()

        // Add the completed stroke
        strokes.append(stroke)
        currentStroke = nil
    }

    // MARK: - Undo

    private func saveUndoState() {
        undoStack.append(strokes)
        if undoStack.count > maxUndoSteps {
            undoStack.removeFirst()
        }
    }

    func undo() {
        guard let previousState = undoStack.popLast() else { return }
        strokes = previousState
    }

    var canUndo: Bool {
        !undoStack.isEmpty
    }

    // MARK: - Clear

    func clearCanvas() {
        saveUndoState()
        strokes.removeAll()
        currentStroke = nil
    }

    // MARK: - Coloring Page

    func setColoringPage(_ page: ColoringPage?) {
        currentColoringPage = page
        clearCanvas()
        undoStack.removeAll()
    }

    // MARK: - Save

    func saveCurrentDrawing(completion: @escaping (Bool) -> Void) {
        // Create a snapshot of the current canvas
        guard !strokes.isEmpty else {
            completion(false)
            return
        }

        // Generate the image
        let renderer = ImageRenderer(content: DrawingSnapshotView(
            strokes: strokes,
            coloringPage: currentColoringPage
        ))

        renderer.scale = 2.0 // Retina quality

        if let uiImage = renderer.uiImage {
            let drawing = SavedDrawing(
                image: uiImage,
                date: Date(),
                coloringPageName: currentColoringPage?.name
            )

            StorageManager.shared.saveDrawing(drawing)
            completion(true)
        } else {
            completion(false)
        }
    }
}

// View for rendering snapshot
struct DrawingSnapshotView: View {
    let strokes: [Stroke]
    let coloringPage: ColoringPage?

    var body: some View {
        ZStack {
            Color.white

            if let page = coloringPage {
                page.outlineShape
                    .stroke(Color.black, lineWidth: 3)
                    .padding(20)
            }

            Canvas { context, size in
                for stroke in strokes {
                    var path = Path()

                    if stroke.points.count == 1 {
                        let point = stroke.points[0]
                        let rect = CGRect(
                            x: point.x - stroke.width / 2,
                            y: point.y - stroke.width / 2,
                            width: stroke.width,
                            height: stroke.width
                        )
                        path.addEllipse(in: rect)
                    } else if stroke.points.count > 1 {
                        path.move(to: stroke.points[0])
                        for i in 1..<stroke.points.count {
                            let mid = CGPoint(
                                x: (stroke.points[i - 1].x + stroke.points[i].x) / 2,
                                y: (stroke.points[i - 1].y + stroke.points[i].y) / 2
                            )
                            path.addQuadCurve(to: mid, control: stroke.points[i - 1])
                        }
                        path.addLine(to: stroke.points.last!)
                    }

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
            }
        }
        .frame(width: 800, height: 800)
    }
}
