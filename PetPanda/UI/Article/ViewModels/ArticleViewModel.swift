//
//  ArticleViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 20.01.2026.
//

import Foundation
import Combine

@MainActor
final class ArticleViewModel: ObservableObject {

    // MARK: - State
    @Published private(set) var article: Article?
    @Published private(set) var contentBlocks: [ContentBlockDTO] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var isFavorite = false
    @Published var readProgress: Double = 0.0

    // MARK: - Dependencies
    private let articleId: String
    private let repository: ArticlesRepository
    private let importer: ContentImporting
    private let favorites: FavoritesRepository
    private let journalRepo: JournalRepository
    private var viewedIndices: Set<Int> = []
    
    var lastUpdatedText: String {
        guard let date = article?.lastUpdated else { return "" }
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            return formatter.string(from: date)
    }
    
    var firstSentenceOfContent: String {
        guard let firstBlock = contentBlocks.first(where: { $0.type == .text }),
              case .text(let fullText) = firstBlock.value else {
            return ""
        }
        
        if let firstDotIndex = fullText.firstIndex(of: ".") {
            return String(fullText[...firstDotIndex])
        }
        
        return fullText
    }

    init(
        articleId: String,
        repository: ArticlesRepository,
        importer: ContentImporting,
        favorites: FavoritesRepository,
        journalRepo: JournalRepository
    ) {
        self.articleId = articleId
        self.repository = repository
        self.importer = importer
        self.favorites = favorites
        self.journalRepo = journalRepo
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedArticle = try? repository.fetch(byId: articleId)

            if fetchedArticle == nil {
                try await importer.importAll()
            }
            
            let finalArticle = try repository.fetch(byId: articleId)
            self.article = finalArticle
            
            if let article = self.article {
                self.readProgress = article.readProgress
                
                if article.readProgress >= 1.0 {
                    self.readProgress = 1.0
                }
                
                let historyItem = JournalItem(
                    id: article.id,
                    type: .article,
                    date: Date(),
                    title: article.title,
                    category: "Article", // Для отображения в карточке
                    tag: article.categoryId
                )
                journalRepo.saveVisit(item: historyItem)
            }

            if let response = try? JSONLoader().load(ArticlesResponseDTO.self, from: "articles") {
                if let dto = response.articles.first(where: { "\($0.id)" == "\(articleId)" }) {
                    self.contentBlocks = dto.contentBlocks
                } else {
                    print("❌ ОШИБКА: Контент для ID \(articleId) не найден в JSON файле")
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            
        }
        isFavorite = favorites.isFavorite(id: articleId, type: .article)
        isLoading = false
    }
    
    func updateProgress(for index: Int) {
            guard readProgress < 1.0, !contentBlocks.isEmpty else { return }
            
            viewedIndices.insert(index)
            
            let total = Double(contentBlocks.count)
            let currentViewed = Double(viewedIndices.count)
            
            let newProgress = (currentViewed / total) * 0.9
            
            if newProgress > self.readProgress {
                self.readProgress = newProgress
                try? repository.updateProgress(articleId: articleId, progress: newProgress)
            }
        }

    func markAsRead() {
        guard let article = article else { return }
        self.readProgress = 1.0
        try? repository.updateProgress(articleId: article.id, progress: 1.0)
    }
    
    func toggleFavorite() {
        favorites.toggle(id: articleId, type: .article)
        isFavorite = favorites.isFavorite(id: articleId, type: .article)
    }
}

