import SwiftUI
import CoreGraphics

class FloodFill {
    private var pixelData: UnsafeMutablePointer<UInt8>?
    private var width: Int
    private var height: Int
    private var bytesPerRow: Int
    private var context: CGContext?

    init(image: CGImage) {
        self.width = image.width
        self.height = image.height
        self.bytesPerRow = width * 4

        // Create bitmap context
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: height * bytesPerRow)

        context = CGContext(
            data: pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )

        context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
    }

    deinit {
        pixelData?.deallocate()
    }

    // MARK: - Public Methods

    func fill(at point: CGPoint, with color: Color) -> CGImage? {
        let x = Int(point.x)
        let y = Int(point.y)

        guard x >= 0, x < width, y >= 0, y < height else { return nil }

        let targetColor = getPixelColor(x: x, y: y)
        let fillColor = color.toRGBA()

        // Don't fill if same color
        if colorsEqual(targetColor, fillColor, tolerance: 10) {
            return context?.makeImage()
        }

        // Use scanline flood fill for better performance
        scanlineFill(x: x, y: y, targetColor: targetColor, fillColor: fillColor)

        return context?.makeImage()
    }

    // MARK: - Scanline Flood Fill

    private func scanlineFill(x: Int, y: Int, targetColor: RGBA, fillColor: RGBA) {
        var stack: [(Int, Int)] = [(x, y)]

        while !stack.isEmpty {
            var (currentX, currentY) = stack.removeLast()

            // Move left to find the start of the line
            while currentX > 0 && colorsEqual(getPixelColor(x: currentX - 1, y: currentY), targetColor, tolerance: 30) {
                currentX -= 1
            }

            var spanAbove = false
            var spanBelow = false

            while currentX < width && colorsEqual(getPixelColor(x: currentX, y: currentY), targetColor, tolerance: 30) {
                setPixelColor(x: currentX, y: currentY, color: fillColor)

                // Check above
                if currentY > 0 {
                    let aboveColor = getPixelColor(x: currentX, y: currentY - 1)
                    if !spanAbove && colorsEqual(aboveColor, targetColor, tolerance: 30) {
                        stack.append((currentX, currentY - 1))
                        spanAbove = true
                    } else if spanAbove && !colorsEqual(aboveColor, targetColor, tolerance: 30) {
                        spanAbove = false
                    }
                }

                // Check below
                if currentY < height - 1 {
                    let belowColor = getPixelColor(x: currentX, y: currentY + 1)
                    if !spanBelow && colorsEqual(belowColor, targetColor, tolerance: 30) {
                        stack.append((currentX, currentY + 1))
                        spanBelow = true
                    } else if spanBelow && !colorsEqual(belowColor, targetColor, tolerance: 30) {
                        spanBelow = false
                    }
                }

                currentX += 1
            }
        }
    }

    // MARK: - Pixel Operations

    private struct RGBA {
        var r: UInt8
        var g: UInt8
        var b: UInt8
        var a: UInt8
    }

    private func getPixelColor(x: Int, y: Int) -> RGBA {
        guard let data = pixelData else { return RGBA(r: 0, g: 0, b: 0, a: 0) }

        let offset = (y * bytesPerRow) + (x * 4)
        return RGBA(
            r: data[offset],
            g: data[offset + 1],
            b: data[offset + 2],
            a: data[offset + 3]
        )
    }

    private func setPixelColor(x: Int, y: Int, color: RGBA) {
        guard let data = pixelData else { return }

        let offset = (y * bytesPerRow) + (x * 4)
        data[offset] = color.r
        data[offset + 1] = color.g
        data[offset + 2] = color.b
        data[offset + 3] = color.a
    }

    private func colorsEqual(_ c1: RGBA, _ c2: RGBA, tolerance: Int) -> Bool {
        let dr = abs(Int(c1.r) - Int(c2.r))
        let dg = abs(Int(c1.g) - Int(c2.g))
        let db = abs(Int(c1.b) - Int(c2.b))
        return dr <= tolerance && dg <= tolerance && db <= tolerance
    }
}

// MARK: - Color Extension

extension Color {
    func toRGBA() -> (r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        return (
            r: UInt8(r * 255),
            g: UInt8(g * 255),
            b: UInt8(b * 255),
            a: UInt8(a * 255)
        )
    }
}

// MARK: - UIImage Extension for Flood Fill

extension UIImage {
    func floodFill(at point: CGPoint, with color: Color) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let floodFill = FloodFill(image: cgImage)
        guard let filledImage = floodFill.fill(at: point, with: color) else { return nil }

        return UIImage(cgImage: filledImage)
    }
}
