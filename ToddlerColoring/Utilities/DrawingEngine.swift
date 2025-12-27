import SwiftUI
import CoreGraphics

class DrawingEngine {
    // Smoothing for toddler-friendly drawing (more forgiving of shaky hands)
    static func smoothPath(points: [CGPoint], tension: CGFloat = 0.5) -> Path {
        var path = Path()

        guard points.count > 1 else {
            if let point = points.first {
                path.move(to: point)
            }
            return path
        }

        path.move(to: points[0])

        if points.count == 2 {
            path.addLine(to: points[1])
            return path
        }

        for i in 1..<points.count {
            let previousPoint = points[i - 1]
            let currentPoint = points[i]

            let midPoint = CGPoint(
                x: (previousPoint.x + currentPoint.x) / 2,
                y: (previousPoint.y + currentPoint.y) / 2
            )

            path.addQuadCurve(to: midPoint, control: previousPoint)
        }

        if let lastPoint = points.last {
            path.addLine(to: lastPoint)
        }

        return path
    }

    // Catmull-Rom spline for ultra-smooth curves
    static func catmullRomPath(points: [CGPoint], alpha: CGFloat = 0.5) -> Path {
        var path = Path()

        guard points.count >= 2 else { return path }

        path.move(to: points[0])

        if points.count == 2 {
            path.addLine(to: points[1])
            return path
        }

        for i in 0..<points.count - 1 {
            let p0 = i > 0 ? points[i - 1] : points[0]
            let p1 = points[i]
            let p2 = points[i + 1]
            let p3 = i + 2 < points.count ? points[i + 2] : points[i + 1]

            let d1 = length(CGPoint(x: p1.x - p0.x, y: p1.y - p0.y))
            let d2 = length(CGPoint(x: p2.x - p1.x, y: p2.y - p1.y))
            let d3 = length(CGPoint(x: p3.x - p2.x, y: p3.y - p2.y))

            let d1a = pow(d1, alpha)
            let d2a = pow(d2, alpha)
            let d3a = pow(d3, alpha)

            var b1: CGPoint
            var b2: CGPoint

            if d1a > 0.0001 && d2a > 0.0001 {
                b1 = CGPoint(
                    x: (d1a * d1a * p2.x - d2a * d2a * p0.x + (2 * d1a * d1a + 3 * d1a * d2a + d2a * d2a) * p1.x) / (3 * d1a * (d1a + d2a)),
                    y: (d1a * d1a * p2.y - d2a * d2a * p0.y + (2 * d1a * d1a + 3 * d1a * d2a + d2a * d2a) * p1.y) / (3 * d1a * (d1a + d2a))
                )
            } else {
                b1 = p1
            }

            if d3a > 0.0001 && d2a > 0.0001 {
                b2 = CGPoint(
                    x: (d3a * d3a * p1.x - d2a * d2a * p3.x + (2 * d3a * d3a + 3 * d3a * d2a + d2a * d2a) * p2.x) / (3 * d3a * (d3a + d2a)),
                    y: (d3a * d3a * p1.y - d2a * d2a * p3.y + (2 * d3a * d3a + 3 * d3a * d2a + d2a * d2a) * p2.y) / (3 * d3a * (d3a + d2a))
                )
            } else {
                b2 = p2
            }

            path.addCurve(to: p2, control1: b1, control2: b2)
        }

        return path
    }

    private static func length(_ point: CGPoint) -> CGFloat {
        sqrt(point.x * point.x + point.y * point.y)
    }

    // Simplify path by removing points that are too close together
    static func simplifyPoints(_ points: [CGPoint], tolerance: CGFloat = 2.0) -> [CGPoint] {
        guard points.count > 2 else { return points }

        var simplified = [points[0]]

        for i in 1..<points.count {
            let lastPoint = simplified.last!
            let currentPoint = points[i]
            let distance = hypot(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y)

            if distance >= tolerance {
                simplified.append(currentPoint)
            }
        }

        // Always include last point
        if let last = points.last, simplified.last != last {
            simplified.append(last)
        }

        return simplified
    }

    // Calculate bounding box of points
    static func boundingBox(of points: [CGPoint]) -> CGRect {
        guard !points.isEmpty else { return .zero }

        var minX = CGFloat.infinity
        var minY = CGFloat.infinity
        var maxX = -CGFloat.infinity
        var maxY = -CGFloat.infinity

        for point in points {
            minX = min(minX, point.x)
            minY = min(minY, point.y)
            maxX = max(maxX, point.x)
            maxY = max(maxY, point.y)
        }

        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    // Check if a point is inside a path (for fill tool)
    static func isPoint(_ point: CGPoint, insidePath path: Path) -> Bool {
        path.contains(point)
    }
}

// Extension for creating pressure-sensitive strokes (for Apple Pencil)
extension DrawingEngine {
    struct PressurePoint {
        let location: CGPoint
        let pressure: CGFloat
    }

    static func variableWidthPath(points: [PressurePoint], baseWidth: CGFloat) -> Path {
        var path = Path()

        guard points.count >= 2 else { return path }

        for i in 0..<points.count - 1 {
            let start = points[i]
            let end = points[i + 1]

            let startWidth = baseWidth * start.pressure
            let endWidth = baseWidth * end.pressure

            // Calculate perpendicular vectors
            let dx = end.location.x - start.location.x
            let dy = end.location.y - start.location.y
            let length = sqrt(dx * dx + dy * dy)

            guard length > 0 else { continue }

            let perpX = -dy / length
            let perpY = dx / length

            // Create quad for this segment
            let p1 = CGPoint(x: start.location.x + perpX * startWidth / 2, y: start.location.y + perpY * startWidth / 2)
            let p2 = CGPoint(x: start.location.x - perpX * startWidth / 2, y: start.location.y - perpY * startWidth / 2)
            let p3 = CGPoint(x: end.location.x - perpX * endWidth / 2, y: end.location.y - perpY * endWidth / 2)
            let p4 = CGPoint(x: end.location.x + perpX * endWidth / 2, y: end.location.y + perpY * endWidth / 2)

            path.move(to: p1)
            path.addLine(to: p2)
            path.addLine(to: p3)
            path.addLine(to: p4)
            path.closeSubpath()
        }

        return path
    }
}
