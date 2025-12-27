import SwiftUI

enum ColoringCategory: String, CaseIterable {
    case animals = "animals"
    case shapes = "shapes"
    case nature = "nature"
    case vehicles = "vehicles"
    case food = "food"

    var displayName: String {
        switch self {
        case .animals: return "Animals"
        case .shapes: return "Shapes"
        case .nature: return "Nature"
        case .vehicles: return "Vehicles"
        case .food: return "Food"
        }
    }

    var icon: String {
        switch self {
        case .animals: return "pawprint.fill"
        case .shapes: return "star.fill"
        case .nature: return "leaf.fill"
        case .vehicles: return "car.fill"
        case .food: return "fork.knife"
        }
    }

    var color: Color {
        switch self {
        case .animals: return .orange
        case .shapes: return .purple
        case .nature: return .green
        case .vehicles: return .blue
        case .food: return .red
        }
    }
}

struct ColoringPage: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let category: ColoringCategory
    let pathData: ColoringPathData

    static func == (lhs: ColoringPage, rhs: ColoringPage) -> Bool {
        lhs.id == rhs.id
    }

    var outlineShape: some Shape {
        ColoringShape(pathData: pathData)
    }

    var previewShape: some Shape {
        ColoringShape(pathData: pathData)
    }
}

struct ColoringPathData {
    let paths: [PathElement]

    enum PathElement {
        case move(to: CGPoint)
        case line(to: CGPoint)
        case curve(to: CGPoint, control1: CGPoint, control2: CGPoint)
        case quadCurve(to: CGPoint, control: CGPoint)
        case arc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)
        case close
        case circle(center: CGPoint, radius: CGFloat)
        case rect(CGRect, cornerRadius: CGFloat)
        case ellipse(in: CGRect)
    }
}

struct ColoringShape: Shape {
    let pathData: ColoringPathData

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Scale factor to fit the shape in the rect
        let scale = min(rect.width, rect.height) / 200
        let offsetX = (rect.width - 200 * scale) / 2
        let offsetY = (rect.height - 200 * scale) / 2

        func transformPoint(_ point: CGPoint) -> CGPoint {
            CGPoint(
                x: point.x * scale + offsetX,
                y: point.y * scale + offsetY
            )
        }

        for element in pathData.paths {
            switch element {
            case .move(let to):
                path.move(to: transformPoint(to))

            case .line(let to):
                path.addLine(to: transformPoint(to))

            case .curve(let to, let control1, let control2):
                path.addCurve(
                    to: transformPoint(to),
                    control1: transformPoint(control1),
                    control2: transformPoint(control2)
                )

            case .quadCurve(let to, let control):
                path.addQuadCurve(
                    to: transformPoint(to),
                    control: transformPoint(control)
                )

            case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                path.addArc(
                    center: transformPoint(center),
                    radius: radius * scale,
                    startAngle: Angle(radians: startAngle),
                    endAngle: Angle(radians: endAngle),
                    clockwise: clockwise
                )

            case .close:
                path.closeSubpath()

            case .circle(let center, let radius):
                let transformedCenter = transformPoint(center)
                path.addEllipse(in: CGRect(
                    x: transformedCenter.x - radius * scale,
                    y: transformedCenter.y - radius * scale,
                    width: radius * scale * 2,
                    height: radius * scale * 2
                ))

            case .rect(let rect, let cornerRadius):
                let transformedRect = CGRect(
                    x: rect.origin.x * scale + offsetX,
                    y: rect.origin.y * scale + offsetY,
                    width: rect.width * scale,
                    height: rect.height * scale
                )
                path.addRoundedRect(in: transformedRect, cornerSize: CGSize(width: cornerRadius * scale, height: cornerRadius * scale))

            case .ellipse(let rect):
                let transformedRect = CGRect(
                    x: rect.origin.x * scale + offsetX,
                    y: rect.origin.y * scale + offsetY,
                    width: rect.width * scale,
                    height: rect.height * scale
                )
                path.addEllipse(in: transformedRect)
            }
        }

        return path
    }
}
