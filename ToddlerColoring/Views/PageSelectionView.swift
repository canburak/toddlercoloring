import SwiftUI

struct PageSelectionView: View {
    @EnvironmentObject var viewModel: ColoringViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: ColoringCategory = .animals
    @State private var animateCards = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()

                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.blue)
                        }

                        Spacer()

                        Text("Pick a Picture!")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

                        Spacer()

                        // Placeholder for symmetry
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)

                    // Category selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(ColoringCategory.allCases, id: \.self) { category in
                                CategoryTab(
                                    category: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedCategory = category
                                    }
                                    HapticManager.shared.selection()
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                    }

                    // Coloring pages grid
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 200, maximum: 280), spacing: 25)
                            ],
                            spacing: 25
                        ) {
                            ForEach(Array(ColoringPageData.pages(for: selectedCategory).enumerated()), id: \.element.id) { index, page in
                                NavigationLink(destination: CanvasView(coloringPage: page)) {
                                    ColoringPageCard(page: page)
                                        .scaleEffect(animateCards ? 1 : 0.8)
                                        .opacity(animateCards ? 1 : 0)
                                        .animation(
                                            .spring(response: 0.5, dampingFraction: 0.7)
                                            .delay(Double(index) * 0.05),
                                            value: animateCards
                                        )
                                }
                            }
                        }
                        .padding(30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            animateCards = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateCards = true
            }
        }
        .onChange(of: selectedCategory) { _, _ in
            animateCards = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                animateCards = true
            }
        }
    }
}

struct CategoryTab: View {
    let category: ColoringCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: category.icon)
                    .font(.system(size: 22))
                Text(category.displayName)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            .background(
                Capsule()
                    .fill(isSelected ? category.color : Color.white)
                    .shadow(color: isSelected ? category.color.opacity(0.4) : .gray.opacity(0.2),
                            radius: isSelected ? 8 : 4,
                            y: isSelected ? 4 : 2)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

struct ColoringPageCard: View {
    let page: ColoringPage
    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 12) {
            // Preview of the coloring page
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2), radius: 8, y: 4)

                // Page outline preview
                page.previewShape
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    .padding(20)
            }
            .aspectRatio(1, contentMode: .fit)

            // Page name
            Text(page.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
        }
        .scaleEffect(isPressed ? 0.95 : 1)
        .animation(.spring(response: 0.3), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in
                    isPressed = false
                    HapticManager.shared.impact(.light)
                }
        )
    }
}

#Preview {
    NavigationStack {
        PageSelectionView()
    }
    .environmentObject(ColoringViewModel())
}
