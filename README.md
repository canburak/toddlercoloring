# Toddler Coloring

A delightful iPad coloring app designed specifically for toddlers aged 2-5 years old. Features large, easy-to-tap buttons, vibrant colors, and simple coloring pages that encourage creativity and fine motor skill development.

## Features

### For Little Artists
- **Free Draw Mode** - Blank canvas for unlimited creativity
- **Coloring Pages** - 30+ pre-made outlines across 5 categories:
  - Animals (Cat, Dog, Fish, Butterfly, Bird, Bunny)
  - Shapes (Circle, Square, Triangle, Star, Heart, Diamond, Oval, Rectangle)
  - Nature (Sun, Cloud, Flower, Tree, Rainbow, Moon)
  - Vehicles (Car, Airplane, Boat, Train, Rocket, Bicycle)
  - Food (Apple, Ice Cream, Pizza, Cupcake, Banana, Cookie)

### Toddler-Friendly Design
- **Large Touch Targets** - Big buttons easy for small fingers
- **Vibrant Colors** - 12 bright, rainbow colors
- **Simple Tools** - Brush, Fill, and Eraser
- **Three Brush Sizes** - Small, Medium, and Big
- **Easy Navigation** - Minimal, intuitive interface

### Parent-Friendly Features
- **No Ads** - Completely ad-free experience
- **Offline Mode** - Works without internet
- **Auto-Save** - Drawings saved to gallery
- **Haptic Feedback** - Gentle vibrations for interaction feedback
- **Full Screen** - No distracting navigation bars

## Requirements

- iPad running iOS 17.0 or later
- Xcode 15.0 or later (for building)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/your-repo/toddlercoloring.git
```

2. Open `ToddlerColoring.xcodeproj` in Xcode

3. Select your iPad or iPad Simulator as the target device

4. Build and run (Cmd+R)

## Project Structure

```
ToddlerColoring/
├── ToddlerColoringApp.swift     # App entry point
├── ContentView.swift            # Main content view with splash screen
├── Views/
│   ├── HomeView.swift           # Main menu
│   ├── CanvasView.swift         # Drawing canvas screen
│   ├── PageSelectionView.swift  # Coloring page selection
│   └── GalleryView.swift        # Saved drawings gallery
├── Components/
│   ├── ColorPalette.swift       # Color picker component
│   ├── DrawingCanvas.swift      # Canvas for drawing
│   ├── ToolBar.swift            # Drawing tools bar
│   ├── BrushSizeSelector.swift  # Brush size picker
│   ├── AnimatedButton.swift     # Animated button styles
│   └── ParticleEffect.swift     # Celebration effects
├── Models/
│   ├── ColoringPage.swift       # Coloring page data model
│   ├── ColoringPageData.swift   # Pre-defined coloring pages
│   └── ColoringViewModel.swift  # App state management
├── Utilities/
│   ├── DrawingEngine.swift      # Path smoothing algorithms
│   ├── SoundManager.swift       # Sound effects
│   ├── FloodFill.swift          # Fill tool algorithm
│   ├── HapticManager.swift      # Haptic feedback
│   └── StorageManager.swift     # Drawing persistence
└── Resources/
    └── Assets.xcassets          # App icons and colors
```

## Technical Details

- **Framework**: SwiftUI
- **Architecture**: MVVM
- **Drawing**: Custom Canvas with CGPath
- **Storage**: FileManager + UserDefaults
- **Haptics**: Core Haptics + UIKit Feedback Generators
- **Target**: iPad only (optimized for larger screen)

## Customization

### Adding New Coloring Pages

Add new pages in `ColoringPageData.swift`:

```swift
ColoringPage(
    name: "Your Shape",
    category: .shapes,
    pathData: ColoringPathData(paths: [
        .circle(center: CGPoint(x: 100, y: 100), radius: 50),
        // Add more path elements...
    ])
)
```

### Adding New Colors

Modify the color arrays in `ColorPalette.swift`:

```swift
static let rainbow: [Color] = [
    Color(red: 1.0, green: 0.2, blue: 0.2), // Red
    // Add more colors...
]
```

## License

This project is available for educational and personal use.

## Credits

Created with love for little artists everywhere.
