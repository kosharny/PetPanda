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

    // MARK: - Dependencies
    private let articleId: String
    private let repository: ArticlesRepository
    private let importer: ContentImporting
    private let favorites: FavoritesRepository
    
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
        favorites: FavoritesRepository
    ) {
        self.articleId = articleId
        self.repository = repository
        self.importer = importer
        self.favorites = favorites
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

    func markAsRead() {
        guard let article else { return }
        try? repository.markAsRead(articleId: article.id)
    }
    
    func toggleFavorite() {
        favorites.toggle(id: articleId, type: .article)
        isFavorite = favorites.isFavorite(id: articleId, type: .article)
    }

}

