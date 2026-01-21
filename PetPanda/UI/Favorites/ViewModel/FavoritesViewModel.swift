//
//  FavoritesViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 20.01.2026.
//

import Foundation
import Combine

enum FavoritesFilter {
    case all
    case article
    case care
    case quiz
}

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published private(set) var items: [FavoriteItem] = []
    @Published var selectedFilter: FavoritesFilter = .all
    @Published var isLoading = false

    private let repository: FavoritesRepository
    
    private let articlesRepo: ArticlesRepository
    private let careRepo: CareGuideRepository
    private let quizRepo: QuizRepository

    init(
        repository: FavoritesRepository,
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository
    ) {
        self.repository = repository
        self.articlesRepo = articlesRepo
        self.careRepo = careRepo
        self.quizRepo = quizRepo
        load()
    }

    func load() {
        let favoriteRefs = (try? repository.fetchAll()) ?? []
        
        self.items = favoriteRefs.map { item in
            let currentProgress: Double
            
            switch item.type {
            case .article:
                let article = (try? articlesRepo.fetchAll())?.first(where: { $0.id == item.id })
                currentProgress = article?.readProgress ?? 0.0
            case .care:
                currentProgress = careRepo.getCalculatedProgress(for: item.id)
            case .quiz:
                let results = (try? quizRepo.fetchResults(quizId: item.id)) ?? []
                currentProgress = results.isEmpty ? 0.0 : 1.0
            }
            
            return FavoriteItem(
                id: item.id,
                type: item.type,
                title: item.title,
                subtitle: item.subtitle,
                tag: item.tag,
                progress: currentProgress
            )
        }
    }

    func selectFilter(_ filter: FavoritesFilter) {
        selectedFilter = filter
    }

    var filteredItems: [FavoriteItem] {
        switch selectedFilter {
        case .all: return items
        case .article: return items.filter { $0.type == .article }
        case .care: return items.filter { $0.type == .care }
        case .quiz: return items.filter { $0.type == .quiz }
        }
    }

    var isEmpty: Bool {
        filteredItems.isEmpty
    }
}

