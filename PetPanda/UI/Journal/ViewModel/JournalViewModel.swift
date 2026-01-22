//
//  JournalViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 21.01.2026.
//

import Foundation
import Combine
import PDFKit

@MainActor
final class JournalViewModel: ObservableObject {
    
    @Published private(set) var items: [JournalItem] = []
    @Published var selectedFilter: FavoritesFilter = .all
    
    private let journalRepo: JournalRepository
    private let favoritesRepo: FavoritesRepository
    private let articlesRepo: ArticlesRepository
    private let careRepo: CareGuideRepository
    private let quizRepo: QuizRepository
    
    
    init(
        journalRepo: JournalRepository,
        favoritesRepo: FavoritesRepository,
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository
    ) {
        self.journalRepo = journalRepo
        self.favoritesRepo = favoritesRepo
        self.articlesRepo = articlesRepo
        self.careRepo = careRepo
        self.quizRepo = quizRepo
        load()
    }
    
    func load() {
        items = (try? journalRepo.fetchAll()) ?? []
    }
    
    func isFavorite(id: String, type: ContentType) -> Bool {
        favoritesRepo.isFavorite(id: id, type: FavoriteType(contentType: type))
    }
    
    func saveVisit(_ item: JournalItem) {
        journalRepo.saveVisit(item: item)
        
        items.removeAll { $0.id == item.id && $0.type == item.type }
        items.insert(item, at: 0)
    }
    
    var groupedItems: [(Date, [JournalItem])] {
        let filtered = filter(items)
        
        let grouped = Dictionary(grouping: filtered) {
            Calendar.current.startOfDay(for: $0.date)
        }
        
        return grouped
            .sorted { $0.key > $1.key }
            .map { ($0.key, $0.value) }
    }
    
    func duration(for item: JournalItem) -> Int {
        switch item.type {
        case .article:
            return (try? articlesRepo.fetchAll()
                .first { $0.id == item.id }?
                .readTime) ?? 0

        case .care:
            return (try? careRepo.fetchAll()
                .first { $0.id == item.id }?
                .duration) ?? 0

        case .quiz:
            return (try? quizRepo.fetchAll()
                .first { $0.id == item.id }?
                .duration) ?? 0
        }
    }

    
    func select(_ filter: FavoritesFilter) {
        selectedFilter = filter
    }
    
    func isSelected(_ filter: FavoritesFilter) -> Bool {
        selectedFilter == filter
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    private func filter(_ items: [JournalItem]) -> [JournalItem] {
        switch selectedFilter {
        case .all: return items
        case .article: return items.filter { $0.type == .article }
        case .care: return items.filter { $0.type == .care }
        case .quiz: return items.filter { $0.type == .quiz }
        }
    }
    
    func exportJournalToPDF() -> URL? {
        guard !items.isEmpty else { return nil }
        
        let pdfMetaData = [
            kCGPDFContextCreator: "MyApp",
            kCGPDFContextAuthor: "User Journal",
            kCGPDFContextTitle: "Journal Export"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 595.2 // A4 width in points
        let pageHeight = 841.8 // A4 height in points
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            var yPosition: CGFloat = 20
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24)
            ]
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16)
            ]
            
            let title = "Journal Export\n\n"
            title.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: titleAttributes)
            yPosition += 40
            
            for item in items {
                let dateString = formattedDate(item.date)
                let line = "\(dateString) | \(item.typeDisplayName) | \(item.title)\n"
                line.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: textAttributes)
                yPosition += 22
                
                if yPosition > pageHeight - 40 {
                    context.beginPage()
                    yPosition = 20
                }
            }
        }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("JournalExport.pdf")
        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            print("Failed to write PDF: \(error)")
            return nil
        }
    }
}

