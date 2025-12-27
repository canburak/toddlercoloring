import SwiftUI
import Foundation

struct SavedDrawing: Identifiable, Codable {
    let id: UUID
    let imageFileName: String
    let thumbnailFileName: String
    let date: Date
    let coloringPageName: String?

    init(image: UIImage, date: Date, coloringPageName: String? = nil) {
        self.id = UUID()
        self.imageFileName = "\(id.uuidString).png"
        self.thumbnailFileName = "\(id.uuidString)_thumb.png"
        self.date = date
        self.coloringPageName = coloringPageName

        // Save images
        StorageManager.shared.saveImage(image, fileName: imageFileName)
        if let thumbnail = image.preparingThumbnail(of: CGSize(width: 300, height: 300)) {
            StorageManager.shared.saveImage(thumbnail, fileName: thumbnailFileName)
        }
    }

    var fullImage: UIImage? {
        StorageManager.shared.loadImage(fileName: imageFileName)
    }

    var thumbnailImage: UIImage? {
        StorageManager.shared.loadImage(fileName: thumbnailFileName)
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

class StorageManager {
    static let shared = StorageManager()

    private let drawingsKey = "saved_drawings"
    private let fileManager = FileManager.default

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var drawingsDirectory: URL {
        let url = documentsDirectory.appendingPathComponent("Drawings", isDirectory: true)
        if !fileManager.fileExists(atPath: url.path) {
            try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
        return url
    }

    private init() {}

    // MARK: - Drawing Storage

    func saveDrawing(_ drawing: SavedDrawing) {
        var drawings = loadDrawingMetadata()
        drawings.insert(drawing, at: 0) // Add to beginning (most recent first)

        // Limit to 50 drawings to save space
        if drawings.count > 50 {
            let removedDrawings = drawings.suffix(from: 50)
            for drawing in removedDrawings {
                deleteDrawingFiles(drawing)
            }
            drawings = Array(drawings.prefix(50))
        }

        saveDrawingMetadata(drawings)
    }

    func loadAllDrawings() -> [SavedDrawing] {
        loadDrawingMetadata()
    }

    func deleteDrawing(_ drawing: SavedDrawing) {
        deleteDrawingFiles(drawing)

        var drawings = loadDrawingMetadata()
        drawings.removeAll { $0.id == drawing.id }
        saveDrawingMetadata(drawings)
    }

    private func deleteDrawingFiles(_ drawing: SavedDrawing) {
        let imageURL = drawingsDirectory.appendingPathComponent(drawing.imageFileName)
        let thumbURL = drawingsDirectory.appendingPathComponent(drawing.thumbnailFileName)

        try? fileManager.removeItem(at: imageURL)
        try? fileManager.removeItem(at: thumbURL)
    }

    // MARK: - Metadata Storage

    private func loadDrawingMetadata() -> [SavedDrawing] {
        guard let data = UserDefaults.standard.data(forKey: drawingsKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([SavedDrawing].self, from: data)
        } catch {
            print("Failed to load drawing metadata: \(error)")
            return []
        }
    }

    private func saveDrawingMetadata(_ drawings: [SavedDrawing]) {
        do {
            let data = try JSONEncoder().encode(drawings)
            UserDefaults.standard.set(data, forKey: drawingsKey)
        } catch {
            print("Failed to save drawing metadata: \(error)")
        }
    }

    // MARK: - Image Storage

    func saveImage(_ image: UIImage, fileName: String) {
        let url = drawingsDirectory.appendingPathComponent(fileName)
        guard let data = image.pngData() else { return }

        do {
            try data.write(to: url)
        } catch {
            print("Failed to save image: \(error)")
        }
    }

    func loadImage(fileName: String) -> UIImage? {
        let url = drawingsDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    // MARK: - Utility

    func clearAllDrawings() {
        let drawings = loadDrawingMetadata()
        for drawing in drawings {
            deleteDrawingFiles(drawing)
        }
        UserDefaults.standard.removeObject(forKey: drawingsKey)
    }

    func getStorageUsed() -> String {
        var totalSize: Int64 = 0

        if let enumerator = fileManager.enumerator(at: drawingsDirectory, includingPropertiesForKeys: [.fileSizeKey]) {
            while let fileURL = enumerator.nextObject() as? URL {
                if let fileSize = try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                    totalSize += Int64(fileSize)
                }
            }
        }

        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: totalSize)
    }
}
