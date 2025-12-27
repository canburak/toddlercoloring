import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var viewModel: ColoringViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var savedDrawings: [SavedDrawing] = []
    @State private var selectedDrawing: SavedDrawing?
    @State private var showDeleteConfirmation = false
    @State private var drawingToDelete: SavedDrawing?
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

                        Text("My Drawings")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

                        Spacer()

                        // Placeholder for symmetry
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)

                    if savedDrawings.isEmpty {
                        // Empty state
                        Spacer()
                        VStack(spacing: 20) {
                            Image(systemName: "photo.stack")
                                .font(.system(size: 80))
                                .foregroundColor(.gray.opacity(0.5))

                            Text("No drawings yet!")
                                .font(.system(size: 24, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)

                            Text("Start coloring to see your art here")
                                .font(.system(size: 18, design: .rounded))
                                .foregroundColor(.gray.opacity(0.8))
                        }
                        Spacer()
                    } else {
                        // Gallery grid
                        ScrollView {
                            LazyVGrid(
                                columns: [
                                    GridItem(.adaptive(minimum: 220, maximum: 300), spacing: 25)
                                ],
                                spacing: 25
                            ) {
                                ForEach(Array(savedDrawings.enumerated()), id: \.element.id) { index, drawing in
                                    GalleryCard(drawing: drawing)
                                        .scaleEffect(animateCards ? 1 : 0.8)
                                        .opacity(animateCards ? 1 : 0)
                                        .animation(
                                            .spring(response: 0.5, dampingFraction: 0.7)
                                            .delay(Double(index) * 0.05),
                                            value: animateCards
                                        )
                                        .onTapGesture {
                                            selectedDrawing = drawing
                                            HapticManager.shared.impact(.light)
                                        }
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                drawingToDelete = drawing
                                                showDeleteConfirmation = true
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }

                                            Button {
                                                shareDrawing(drawing)
                                            } label: {
                                                Label("Share", systemImage: "square.and.arrow.up")
                                            }
                                        }
                                }
                            }
                            .padding(30)
                        }
                    }
                }

                // Full screen preview
                if let drawing = selectedDrawing {
                    DrawingPreviewOverlay(drawing: drawing) {
                        withAnimation {
                            selectedDrawing = nil
                        }
                    }
                    .transition(.opacity)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadSavedDrawings()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateCards = true
            }
        }
        .alert("Delete Drawing?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if let drawing = drawingToDelete {
                    deleteDrawing(drawing)
                }
            }
            Button("Cancel", role: .cancel) {
                drawingToDelete = nil
            }
        } message: {
            Text("This cannot be undone.")
        }
    }

    private func loadSavedDrawings() {
        savedDrawings = StorageManager.shared.loadAllDrawings()
    }

    private func deleteDrawing(_ drawing: SavedDrawing) {
        StorageManager.shared.deleteDrawing(drawing)
        withAnimation {
            savedDrawings.removeAll { $0.id == drawing.id }
        }
        HapticManager.shared.notification(.warning)
    }

    private func shareDrawing(_ drawing: SavedDrawing) {
        // Share functionality would be implemented here
        HapticManager.shared.impact(.medium)
    }
}

struct GalleryCard: View {
    let drawing: SavedDrawing

    var body: some View {
        VStack(spacing: 12) {
            // Drawing preview
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2), radius: 8, y: 4)

                if let image = drawing.thumbnailImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(8)
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                }
            }
            .aspectRatio(1, contentMode: .fit)

            // Date
            Text(drawing.formattedDate)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
        }
    }
}

struct DrawingPreviewOverlay: View {
    let drawing: SavedDrawing
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacing: 20) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 30)

                // Full drawing
                if let image = drawing.fullImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 20)
                        .padding(30)
                }

                // Date
                Text(drawing.formattedDate)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    NavigationStack {
        GalleryView()
    }
    .environmentObject(ColoringViewModel())
}
