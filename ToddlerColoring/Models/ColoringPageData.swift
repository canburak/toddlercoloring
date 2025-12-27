import SwiftUI

struct ColoringPageData {
    static func pages(for category: ColoringCategory) -> [ColoringPage] {
        switch category {
        case .animals:
            return animalPages
        case .shapes:
            return shapePages
        case .nature:
            return naturePages
        case .vehicles:
            return vehiclePages
        case .food:
            return foodPages
        }
    }

    // MARK: - Animals

    static let animalPages: [ColoringPage] = [
        // Cat
        ColoringPage(
            name: "Cat",
            category: .animals,
            pathData: ColoringPathData(paths: [
                // Body
                .ellipse(in: CGRect(x: 60, y: 80, width: 80, height: 70)),
                // Head
                .circle(center: CGPoint(x: 100, y: 60), radius: 35),
                // Left ear
                .move(to: CGPoint(x: 70, y: 35)),
                .line(to: CGPoint(x: 60, y: 10)),
                .line(to: CGPoint(x: 85, y: 30)),
                .close,
                // Right ear
                .move(to: CGPoint(x: 130, y: 35)),
                .line(to: CGPoint(x: 140, y: 10)),
                .line(to: CGPoint(x: 115, y: 30)),
                .close,
                // Left eye
                .circle(center: CGPoint(x: 85, y: 55), radius: 8),
                // Right eye
                .circle(center: CGPoint(x: 115, y: 55), radius: 8),
                // Nose
                .move(to: CGPoint(x: 100, y: 65)),
                .line(to: CGPoint(x: 95, y: 72)),
                .line(to: CGPoint(x: 105, y: 72)),
                .close,
                // Tail
                .move(to: CGPoint(x: 140, y: 100)),
                .quadCurve(to: CGPoint(x: 170, y: 70), control: CGPoint(x: 180, y: 100)),
            ])
        ),

        // Dog
        ColoringPage(
            name: "Dog",
            category: .animals,
            pathData: ColoringPathData(paths: [
                // Body
                .ellipse(in: CGRect(x: 50, y: 90, width: 100, height: 60)),
                // Head
                .circle(center: CGPoint(x: 100, y: 60), radius: 40),
                // Left ear (floppy)
                .ellipse(in: CGRect(x: 55, y: 40, width: 20, height: 45)),
                // Right ear (floppy)
                .ellipse(in: CGRect(x: 125, y: 40, width: 20, height: 45)),
                // Left eye
                .circle(center: CGPoint(x: 85, y: 55), radius: 7),
                // Right eye
                .circle(center: CGPoint(x: 115, y: 55), radius: 7),
                // Nose
                .circle(center: CGPoint(x: 100, y: 75), radius: 10),
                // Tail
                .move(to: CGPoint(x: 150, y: 100)),
                .quadCurve(to: CGPoint(x: 175, y: 80), control: CGPoint(x: 170, y: 110)),
                // Front legs
                .rect(CGRect(x: 65, y: 140, width: 15, height: 35), cornerRadius: 5),
                .rect(CGRect(x: 120, y: 140, width: 15, height: 35), cornerRadius: 5),
            ])
        ),

        // Fish
        ColoringPage(
            name: "Fish",
            category: .animals,
            pathData: ColoringPathData(paths: [
                // Body
                .move(to: CGPoint(x: 40, y: 100)),
                .quadCurve(to: CGPoint(x: 140, y: 100), control: CGPoint(x: 90, y: 40)),
                .quadCurve(to: CGPoint(x: 40, y: 100), control: CGPoint(x: 90, y: 160)),
                // Tail
                .move(to: CGPoint(x: 140, y: 100)),
                .line(to: CGPoint(x: 175, y: 70)),
                .line(to: CGPoint(x: 160, y: 100)),
                .line(to: CGPoint(x: 175, y: 130)),
                .close,
                // Eye
                .circle(center: CGPoint(x: 65, y: 95), radius: 10),
                // Fin
                .move(to: CGPoint(x: 90, y: 75)),
                .quadCurve(to: CGPoint(x: 110, y: 75), control: CGPoint(x: 100, y: 50)),
            ])
        ),

        // Butterfly
        ColoringPage(
            name: "Butterfly",
            category: .animals,
            pathData: ColoringPathData(paths: [
                // Body
                .ellipse(in: CGRect(x: 95, y: 60, width: 10, height: 80)),
                // Head
                .circle(center: CGPoint(x: 100, y: 50), radius: 12),
                // Left top wing
                .ellipse(in: CGRect(x: 30, y: 40, width: 65, height: 50)),
                // Right top wing
                .ellipse(in: CGRect(x: 105, y: 40, width: 65, height: 50)),
                // Left bottom wing
                .ellipse(in: CGRect(x: 40, y: 90, width: 55, height: 45)),
                // Right bottom wing
                .ellipse(in: CGRect(x: 105, y: 90, width: 55, height: 45)),
                // Antennae
                .move(to: CGPoint(x: 95, y: 40)),
                .quadCurve(to: CGPoint(x: 75, y: 20), control: CGPoint(x: 80, y: 35)),
                .move(to: CGPoint(x: 105, y: 40)),
                .quadCurve(to: CGPoint(x: 125, y: 20), control: CGPoint(x: 120, y: 35)),
            ])
        ),

        // Bird
        ColoringPage(
            name: "Bird",
            category: .animals,
            pathData: ColoringPathData(paths: [
                // Body
                .ellipse(in: CGRect(x: 60, y: 80, width: 80, height: 50)),
                // Head
                .circle(center: CGPoint(x: 130, y: 75), radius: 25),
                // Eye
                .circle(center: CGPoint(x: 135, y: 70), radius: 6),
                // Beak
                .move(to: CGPoint(x: 150, y: 75)),
                .line(to: CGPoint(x: 175, y: 80)),
                .line(to: CGPoint(x: 150, y: 85)),
                .close,
                // Wing
                .ellipse(in: CGRect(x: 70, y: 85, width: 50, height: 25)),
                // Tail
                .move(to: CGPoint(x: 60, y: 95)),
                .line(to: CGPoint(x: 30, y: 80)),
                .line(to: CGPoint(x: 35, y: 100)),
                .line(to: CGPoint(x: 25, y: 115)),
                .line(to: CGPoint(x: 60, y: 105)),
                // Legs
                .move(to: CGPoint(x: 90, y: 130)),
                .line(to: CGPoint(x: 85, y: 155)),
                .move(to: CGPoint(x: 110, y: 130)),
                .line(to: CGPoint(x: 115, y: 155)),
            ])
        ),

        // Bunny
        ColoringPage(
            name: "Bunny",
            category: .animals,
            pathData: ColoringPathData(paths: [
                // Body
                .ellipse(in: CGRect(x: 60, y: 100, width: 80, height: 60)),
                // Head
                .circle(center: CGPoint(x: 100, y: 80), radius: 30),
                // Left ear
                .ellipse(in: CGRect(x: 70, y: 15, width: 15, height: 50)),
                // Right ear
                .ellipse(in: CGRect(x: 115, y: 15, width: 15, height: 50)),
                // Left eye
                .circle(center: CGPoint(x: 88, y: 75), radius: 6),
                // Right eye
                .circle(center: CGPoint(x: 112, y: 75), radius: 6),
                // Nose
                .circle(center: CGPoint(x: 100, y: 90), radius: 5),
                // Tail
                .circle(center: CGPoint(x: 145, y: 130), radius: 12),
            ])
        ),
    ]

    // MARK: - Shapes

    static let shapePages: [ColoringPage] = [
        // Circle
        ColoringPage(
            name: "Circle",
            category: .shapes,
            pathData: ColoringPathData(paths: [
                .circle(center: CGPoint(x: 100, y: 100), radius: 70)
            ])
        ),

        // Square
        ColoringPage(
            name: "Square",
            category: .shapes,
            pathData: ColoringPathData(paths: [
                .rect(CGRect(x: 30, y: 30, width: 140, height: 140), cornerRadius: 0)
            ])
        ),

        // Triangle
        ColoringPage(
            name: "Triangle",
            category: .shapes,
            pathData: ColoringPathData(paths: [
                .move(to: CGPoint(x: 100, y: 20)),
                .line(to: CGPoint(x: 180, y: 170)),
                .line(to: CGPoint(x: 20, y: 170)),
                .close
            ])
        ),

        // Star
        ColoringPage(
            name: "Star",
            category: .shapes,
            pathData: ColoringPathData(paths: [
                .move(to: CGPoint(x: 100, y: 20)),
                .line(to: CGPoint(x: 120, y: 70)),
                .line(to: CGPoint(x: 175, y: 75)),
                .line(to: CGPoint(x: 135, y: 115)),
                .line(to: CGPoint(x: 150, y: 170)),
                .line(to: CGPoint(x: 100, y: 140)),
                .line(to: CGPoint(x: 50, y: 170)),
                .line(to: CGPoint(x: 65, y: 115)),
                .line(to: CGPoint(x: 25, y: 75)),
                .line(to: CGPoint(x: 80, y: 70)),
                .close
            ])
        ),

        // Heart
        ColoringPage(
            name: "Heart",
            category: .shapes,
            pathData: ColoringPathData(paths: [
                .move(to: CGPoint(x: 100, y: 170)),
                .quadCurve(to: CGPoint(x: 20, y: 70), control: CGPoint(x: 20, y: 140)),
                .quadCurve(to: CGPoint(x: 100, y: 50), control: CGPoint(x: 20, y: 20)),
                .quadCurve(to: CGPoint(x: 180, y: 70), control: CGPoint(x: 180, y: 20)),
                .quadCurve(to: CGPoint(x: 100, y: 170), control: CGPoint(x: 180, y: 140)),
            ])
        ),

        // Diamond
        ColoringPage(
            name: "Diamond",
            category: .shapes,
            pathData: ColoringPathData(paths: [
                .move(to: CGPoint(x: 100, y: 20)),
                .line(to: CGPoint(x: 175, y: 100)),
                .line(to: CGPoint(x: 100, y: 180)),
                .line(to: CGPoint(x: 25, y: 100)),
                .close
            ])
        ),

        // Oval
        ColoringPage(
            name: "Oval",
            category: .shapes,
            pathData: ColoringPathData(paths: [
                .ellipse(in: CGRect(x: 25, y: 50, width: 150, height: 100))
            ])
        ),

        // Rectangle
        ColoringPage(
            name: "Rectangle",
            category: .shapes,
            pathData: ColoringPathData(paths: [
                .rect(CGRect(x: 25, y: 60, width: 150, height: 80), cornerRadius: 0)
            ])
        ),
    ]

    // MARK: - Nature

    static let naturePages: [ColoringPage] = [
        // Sun
        ColoringPage(
            name: "Sun",
            category: .nature,
            pathData: ColoringPathData(paths: [
                .circle(center: CGPoint(x: 100, y: 100), radius: 40),
                // Rays
                .move(to: CGPoint(x: 100, y: 50)),
                .line(to: CGPoint(x: 100, y: 20)),
                .move(to: CGPoint(x: 100, y: 150)),
                .line(to: CGPoint(x: 100, y: 180)),
                .move(to: CGPoint(x: 50, y: 100)),
                .line(to: CGPoint(x: 20, y: 100)),
                .move(to: CGPoint(x: 150, y: 100)),
                .line(to: CGPoint(x: 180, y: 100)),
                .move(to: CGPoint(x: 65, y: 65)),
                .line(to: CGPoint(x: 40, y: 40)),
                .move(to: CGPoint(x: 135, y: 65)),
                .line(to: CGPoint(x: 160, y: 40)),
                .move(to: CGPoint(x: 65, y: 135)),
                .line(to: CGPoint(x: 40, y: 160)),
                .move(to: CGPoint(x: 135, y: 135)),
                .line(to: CGPoint(x: 160, y: 160)),
            ])
        ),

        // Cloud
        ColoringPage(
            name: "Cloud",
            category: .nature,
            pathData: ColoringPathData(paths: [
                .circle(center: CGPoint(x: 60, y: 110), radius: 30),
                .circle(center: CGPoint(x: 100, y: 90), radius: 40),
                .circle(center: CGPoint(x: 145, y: 105), radius: 35),
                .rect(CGRect(x: 60, y: 100, width: 85, height: 45), cornerRadius: 0),
            ])
        ),

        // Flower
        ColoringPage(
            name: "Flower",
            category: .nature,
            pathData: ColoringPathData(paths: [
                // Center
                .circle(center: CGPoint(x: 100, y: 80), radius: 20),
                // Petals
                .ellipse(in: CGRect(x: 85, y: 25, width: 30, height: 40)),
                .ellipse(in: CGRect(x: 85, y: 100, width: 30, height: 40)),
                .ellipse(in: CGRect(x: 45, y: 65, width: 40, height: 30)),
                .ellipse(in: CGRect(x: 115, y: 65, width: 40, height: 30)),
                .ellipse(in: CGRect(x: 55, y: 35, width: 35, height: 35)),
                .ellipse(in: CGRect(x: 110, y: 35, width: 35, height: 35)),
                .ellipse(in: CGRect(x: 55, y: 90, width: 35, height: 35)),
                .ellipse(in: CGRect(x: 110, y: 90, width: 35, height: 35)),
                // Stem
                .rect(CGRect(x: 95, y: 120, width: 10, height: 60), cornerRadius: 3),
                // Leaves
                .ellipse(in: CGRect(x: 60, y: 140, width: 35, height: 20)),
                .ellipse(in: CGRect(x: 105, y: 155, width: 35, height: 20)),
            ])
        ),

        // Tree
        ColoringPage(
            name: "Tree",
            category: .nature,
            pathData: ColoringPathData(paths: [
                // Trunk
                .rect(CGRect(x: 80, y: 120, width: 40, height: 60), cornerRadius: 5),
                // Foliage
                .circle(center: CGPoint(x: 100, y: 70), radius: 50),
                .circle(center: CGPoint(x: 60, y: 90), radius: 35),
                .circle(center: CGPoint(x: 140, y: 90), radius: 35),
            ])
        ),

        // Rainbow
        ColoringPage(
            name: "Rainbow",
            category: .nature,
            pathData: ColoringPathData(paths: [
                .move(to: CGPoint(x: 20, y: 150)),
                .arc(center: CGPoint(x: 100, y: 150), radius: 80, startAngle: .pi, endAngle: 0, clockwise: false),
                .move(to: CGPoint(x: 30, y: 150)),
                .arc(center: CGPoint(x: 100, y: 150), radius: 70, startAngle: .pi, endAngle: 0, clockwise: false),
                .move(to: CGPoint(x: 40, y: 150)),
                .arc(center: CGPoint(x: 100, y: 150), radius: 60, startAngle: .pi, endAngle: 0, clockwise: false),
                .move(to: CGPoint(x: 50, y: 150)),
                .arc(center: CGPoint(x: 100, y: 150), radius: 50, startAngle: .pi, endAngle: 0, clockwise: false),
                .move(to: CGPoint(x: 60, y: 150)),
                .arc(center: CGPoint(x: 100, y: 150), radius: 40, startAngle: .pi, endAngle: 0, clockwise: false),
            ])
        ),

        // Moon
        ColoringPage(
            name: "Moon",
            category: .nature,
            pathData: ColoringPathData(paths: [
                .circle(center: CGPoint(x: 100, y: 100), radius: 60),
                // Stars around
                .circle(center: CGPoint(x: 40, y: 50), radius: 5),
                .circle(center: CGPoint(x: 160, y: 40), radius: 4),
                .circle(center: CGPoint(x: 170, y: 100), radius: 5),
                .circle(center: CGPoint(x: 30, y: 130), radius: 4),
                .circle(center: CGPoint(x: 150, y: 160), radius: 5),
            ])
        ),
    ]

    // MARK: - Vehicles

    static let vehiclePages: [ColoringPage] = [
        // Car
        ColoringPage(
            name: "Car",
            category: .vehicles,
            pathData: ColoringPathData(paths: [
                // Body
                .rect(CGRect(x: 30, y: 90, width: 140, height: 50), cornerRadius: 10),
                // Top
                .move(to: CGPoint(x: 55, y: 90)),
                .line(to: CGPoint(x: 70, y: 55)),
                .line(to: CGPoint(x: 130, y: 55)),
                .line(to: CGPoint(x: 145, y: 90)),
                // Windows
                .rect(CGRect(x: 75, y: 60, width: 50, height: 28), cornerRadius: 3),
                // Wheels
                .circle(center: CGPoint(x: 60, y: 140), radius: 20),
                .circle(center: CGPoint(x: 140, y: 140), radius: 20),
                // Wheel centers
                .circle(center: CGPoint(x: 60, y: 140), radius: 8),
                .circle(center: CGPoint(x: 140, y: 140), radius: 8),
                // Headlight
                .circle(center: CGPoint(x: 165, y: 110), radius: 8),
            ])
        ),

        // Airplane
        ColoringPage(
            name: "Airplane",
            category: .vehicles,
            pathData: ColoringPathData(paths: [
                // Body
                .ellipse(in: CGRect(x: 40, y: 85, width: 120, height: 30)),
                // Nose
                .move(to: CGPoint(x: 160, y: 100)),
                .line(to: CGPoint(x: 185, y: 100)),
                .line(to: CGPoint(x: 160, y: 95)),
                // Wings
                .move(to: CGPoint(x: 80, y: 85)),
                .line(to: CGPoint(x: 60, y: 50)),
                .line(to: CGPoint(x: 120, y: 50)),
                .line(to: CGPoint(x: 120, y: 85)),
                .move(to: CGPoint(x: 80, y: 115)),
                .line(to: CGPoint(x: 60, y: 150)),
                .line(to: CGPoint(x: 120, y: 150)),
                .line(to: CGPoint(x: 120, y: 115)),
                // Tail
                .move(to: CGPoint(x: 40, y: 90)),
                .line(to: CGPoint(x: 20, y: 60)),
                .line(to: CGPoint(x: 50, y: 85)),
                // Windows
                .circle(center: CGPoint(x: 130, y: 100), radius: 6),
                .circle(center: CGPoint(x: 115, y: 100), radius: 6),
            ])
        ),

        // Boat
        ColoringPage(
            name: "Boat",
            category: .vehicles,
            pathData: ColoringPathData(paths: [
                // Hull
                .move(to: CGPoint(x: 30, y: 130)),
                .line(to: CGPoint(x: 50, y: 170)),
                .line(to: CGPoint(x: 150, y: 170)),
                .line(to: CGPoint(x: 170, y: 130)),
                .close,
                // Cabin
                .rect(CGRect(x: 70, y: 100, width: 60, height: 30), cornerRadius: 5),
                // Mast
                .rect(CGRect(x: 95, y: 40, width: 10, height: 60), cornerRadius: 2),
                // Sail
                .move(to: CGPoint(x: 100, y: 45)),
                .line(to: CGPoint(x: 155, y: 95)),
                .line(to: CGPoint(x: 100, y: 95)),
                .close,
                // Flag
                .move(to: CGPoint(x: 100, y: 40)),
                .line(to: CGPoint(x: 100, y: 25)),
                .line(to: CGPoint(x: 120, y: 32)),
                .close,
            ])
        ),

        // Train
        ColoringPage(
            name: "Train",
            category: .vehicles,
            pathData: ColoringPathData(paths: [
                // Engine body
                .rect(CGRect(x: 30, y: 80, width: 80, height: 50), cornerRadius: 5),
                // Cabin
                .rect(CGRect(x: 70, y: 50, width: 40, height: 30), cornerRadius: 3),
                // Chimney
                .rect(CGRect(x: 40, y: 50, width: 20, height: 30), cornerRadius: 3),
                // Smoke
                .circle(center: CGPoint(x: 50, y: 35), radius: 12),
                .circle(center: CGPoint(x: 40, y: 20), radius: 8),
                // Wheels
                .circle(center: CGPoint(x: 50, y: 130), radius: 15),
                .circle(center: CGPoint(x: 90, y: 130), radius: 15),
                // Car
                .rect(CGRect(x: 120, y: 90, width: 60, height: 40), cornerRadius: 5),
                .circle(center: CGPoint(x: 135, y: 130), radius: 12),
                .circle(center: CGPoint(x: 165, y: 130), radius: 12),
            ])
        ),

        // Rocket
        ColoringPage(
            name: "Rocket",
            category: .vehicles,
            pathData: ColoringPathData(paths: [
                // Body
                .ellipse(in: CGRect(x: 75, y: 40, width: 50, height: 120)),
                // Nose
                .move(to: CGPoint(x: 100, y: 20)),
                .quadCurve(to: CGPoint(x: 75, y: 60), control: CGPoint(x: 75, y: 20)),
                .move(to: CGPoint(x: 100, y: 20)),
                .quadCurve(to: CGPoint(x: 125, y: 60), control: CGPoint(x: 125, y: 20)),
                // Fins
                .move(to: CGPoint(x: 75, y: 130)),
                .line(to: CGPoint(x: 50, y: 170)),
                .line(to: CGPoint(x: 75, y: 155)),
                .move(to: CGPoint(x: 125, y: 130)),
                .line(to: CGPoint(x: 150, y: 170)),
                .line(to: CGPoint(x: 125, y: 155)),
                // Window
                .circle(center: CGPoint(x: 100, y: 80), radius: 15),
                // Flames
                .move(to: CGPoint(x: 85, y: 160)),
                .quadCurve(to: CGPoint(x: 100, y: 185), control: CGPoint(x: 90, y: 175)),
                .quadCurve(to: CGPoint(x: 115, y: 160), control: CGPoint(x: 110, y: 175)),
            ])
        ),

        // Bicycle
        ColoringPage(
            name: "Bicycle",
            category: .vehicles,
            pathData: ColoringPathData(paths: [
                // Front wheel
                .circle(center: CGPoint(x: 50, y: 130), radius: 30),
                .circle(center: CGPoint(x: 50, y: 130), radius: 5),
                // Back wheel
                .circle(center: CGPoint(x: 150, y: 130), radius: 30),
                .circle(center: CGPoint(x: 150, y: 130), radius: 5),
                // Frame
                .move(to: CGPoint(x: 50, y: 130)),
                .line(to: CGPoint(x: 100, y: 90)),
                .line(to: CGPoint(x: 150, y: 130)),
                .move(to: CGPoint(x: 100, y: 90)),
                .line(to: CGPoint(x: 100, y: 60)),
                .move(to: CGPoint(x: 100, y: 90)),
                .line(to: CGPoint(x: 50, y: 130)),
                // Handlebars
                .move(to: CGPoint(x: 85, y: 60)),
                .line(to: CGPoint(x: 115, y: 60)),
                .move(to: CGPoint(x: 100, y: 60)),
                .line(to: CGPoint(x: 50, y: 130)),
                // Seat
                .ellipse(in: CGRect(x: 90, y: 55, width: 30, height: 12)),
                // Pedals
                .circle(center: CGPoint(x: 100, y: 130), radius: 8),
            ])
        ),
    ]

    // MARK: - Food

    static let foodPages: [ColoringPage] = [
        // Apple
        ColoringPage(
            name: "Apple",
            category: .food,
            pathData: ColoringPathData(paths: [
                // Body
                .circle(center: CGPoint(x: 100, y: 110), radius: 55),
                // Indent at top
                .move(to: CGPoint(x: 85, y: 60)),
                .quadCurve(to: CGPoint(x: 115, y: 60), control: CGPoint(x: 100, y: 75)),
                // Stem
                .rect(CGRect(x: 96, y: 40, width: 8, height: 25), cornerRadius: 3),
                // Leaf
                .move(to: CGPoint(x: 104, y: 45)),
                .quadCurve(to: CGPoint(x: 140, y: 35), control: CGPoint(x: 125, y: 30)),
                .quadCurve(to: CGPoint(x: 104, y: 45), control: CGPoint(x: 125, y: 55)),
            ])
        ),

        // Ice Cream
        ColoringPage(
            name: "Ice Cream",
            category: .food,
            pathData: ColoringPathData(paths: [
                // Cone
                .move(to: CGPoint(x: 60, y: 100)),
                .line(to: CGPoint(x: 100, y: 180)),
                .line(to: CGPoint(x: 140, y: 100)),
                .close,
                // Scoops
                .circle(center: CGPoint(x: 100, y: 85), radius: 40),
                .circle(center: CGPoint(x: 70, y: 70), radius: 25),
                .circle(center: CGPoint(x: 130, y: 70), radius: 25),
                // Cherry
                .circle(center: CGPoint(x: 100, y: 40), radius: 12),
                .move(to: CGPoint(x: 100, y: 30)),
                .quadCurve(to: CGPoint(x: 115, y: 20), control: CGPoint(x: 105, y: 20)),
            ])
        ),

        // Pizza
        ColoringPage(
            name: "Pizza",
            category: .food,
            pathData: ColoringPathData(paths: [
                // Slice shape
                .move(to: CGPoint(x: 100, y: 30)),
                .line(to: CGPoint(x: 40, y: 170)),
                .quadCurve(to: CGPoint(x: 160, y: 170), control: CGPoint(x: 100, y: 190)),
                .close,
                // Toppings (pepperoni)
                .circle(center: CGPoint(x: 90, y: 90), radius: 15),
                .circle(center: CGPoint(x: 120, y: 110), radius: 12),
                .circle(center: CGPoint(x: 85, y: 140), radius: 14),
                .circle(center: CGPoint(x: 130, y: 150), radius: 11),
                // Crust edge
                .move(to: CGPoint(x: 45, y: 160)),
                .quadCurve(to: CGPoint(x: 155, y: 160), control: CGPoint(x: 100, y: 175)),
            ])
        ),

        // Cupcake
        ColoringPage(
            name: "Cupcake",
            category: .food,
            pathData: ColoringPathData(paths: [
                // Cup
                .move(to: CGPoint(x: 55, y: 110)),
                .line(to: CGPoint(x: 65, y: 170)),
                .line(to: CGPoint(x: 135, y: 170)),
                .line(to: CGPoint(x: 145, y: 110)),
                .close,
                // Cup ridges
                .move(to: CGPoint(x: 60, y: 120)),
                .line(to: CGPoint(x: 140, y: 120)),
                .move(to: CGPoint(x: 62, y: 135)),
                .line(to: CGPoint(x: 138, y: 135)),
                .move(to: CGPoint(x: 64, y: 150)),
                .line(to: CGPoint(x: 136, y: 150)),
                // Frosting
                .move(to: CGPoint(x: 55, y: 110)),
                .quadCurve(to: CGPoint(x: 100, y: 60), control: CGPoint(x: 50, y: 70)),
                .quadCurve(to: CGPoint(x: 145, y: 110), control: CGPoint(x: 150, y: 70)),
                // Cherry on top
                .circle(center: CGPoint(x: 100, y: 50), radius: 12),
            ])
        ),

        // Banana
        ColoringPage(
            name: "Banana",
            category: .food,
            pathData: ColoringPathData(paths: [
                .move(to: CGPoint(x: 50, y: 150)),
                .quadCurve(to: CGPoint(x: 100, y: 50), control: CGPoint(x: 30, y: 80)),
                .quadCurve(to: CGPoint(x: 150, y: 100), control: CGPoint(x: 140, y: 40)),
                .quadCurve(to: CGPoint(x: 100, y: 140), control: CGPoint(x: 160, y: 140)),
                .quadCurve(to: CGPoint(x: 50, y: 150), control: CGPoint(x: 70, y: 160)),
                // Stem
                .rect(CGRect(x: 45, y: 145, width: 15, height: 20), cornerRadius: 3),
            ])
        ),

        // Cookie
        ColoringPage(
            name: "Cookie",
            category: .food,
            pathData: ColoringPathData(paths: [
                // Cookie body (slightly irregular circle)
                .circle(center: CGPoint(x: 100, y: 100), radius: 60),
                // Chocolate chips
                .circle(center: CGPoint(x: 80, y: 80), radius: 8),
                .circle(center: CGPoint(x: 120, y: 75), radius: 7),
                .circle(center: CGPoint(x: 70, y: 110), radius: 9),
                .circle(center: CGPoint(x: 110, y: 105), radius: 8),
                .circle(center: CGPoint(x: 130, y: 120), radius: 7),
                .circle(center: CGPoint(x: 90, y: 130), radius: 8),
                .circle(center: CGPoint(x: 100, y: 90), radius: 6),
            ])
        ),
    ]
}
