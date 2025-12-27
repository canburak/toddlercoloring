import SwiftUI

@main
struct ToddlerColoringApp: App {
    @StateObject private var coloringViewModel = ColoringViewModel()

    init() {
        // Configure appearance for toddler-friendly interface
        configureAppAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coloringViewModel)
                .preferredColorScheme(.light)
                .statusBarHidden(true)
        }
    }

    private func configureAppAppearance() {
        // Disable idle timer so screen doesn't dim while coloring
        UIApplication.shared.isIdleTimerDisabled = true
    }
}
