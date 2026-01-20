//
//  FavoritesRepository.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 20.01.2026.
//

import Foundation

protocol FavoritesRepository {
    func toggle(id: String, type: FavoriteType)
    func isFavorite(id: String, type: FavoriteType) -> Bool
    func fetchAll() throws -> [FavoriteItem]
}

final class FavoritesRepositoryImpl: FavoritesRepository {
    
    private let articlesRepo: ArticlesRepository
    private let careRepo: CareGuideRepository
    private let quizRepo: QuizRepository
    
    private let storageKey = "saved_favorites_list"
    private var favorites = Set<FavoriteRef>()
    
    init(articlesRepo: ArticlesRepository, careRepo: CareGuideRepository, quizRepo: QuizRepository) {
        self.articlesRepo = articlesRepo
        self.careRepo = careRepo
        self.quizRepo = quizRepo
        
        loadFromDisk()
    }
    
    func toggle(id: String, type: FavoriteType) {
        let ref = FavoriteRef(id: id, type: type)
        
        if favorites.contains(ref) {
            favorites.remove(ref)
        } else {
            favorites.insert(ref)
        }
        
        saveToDisk()
    }
    
    private func saveToDisk() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadFromDisk() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(Set<FavoriteRef>.self, from: data) {
            self.favorites = decoded
        }
    }
    
    
    func isFavorite(id: String, type: FavoriteType) -> Bool {
        favorites.contains(FavoriteRef(id: id, type: type))
    }
    
    func fetchAll() throws -> [FavoriteItem] {
        var result: [FavoriteItem] = []
        
        for ref in favorites {
            switch ref.type {
                
            case .article:
                let article = try articlesRepo.fetch(byId: ref.id)
                result.append(
                    FavoriteItem(
                        id: article.id,
                        type: .article,
                        title: article.title,
                        subtitle: article.categoryId,
                        tag: article.tags.first ?? ""
                    )
                )
                
            case .care:
                let guide = try careRepo.fetchAll()
                    .first { $0.id == ref.id }
                
                if let guide {
                    result.append(
                        FavoriteItem(
                            id: guide.id,
                            type: .care,
                            title: guide.title,
                            subtitle: guide.category,
                            tag: guide.tags.first ?? ""
                        )
                    )
                }
                
            case .quiz:
                let quiz = try quizRepo.fetchAll()
                    .first { $0.id == ref.id }
                
                if let quiz {
                    result.append(
                        FavoriteItem(
                            id: quiz.id,
                            type: .quiz,
                            title: quiz.title,
                            subtitle: "\(quiz.questions.count) Questions",
                            tag: quiz.tags.first ?? ""
                        )
                    )
                }
            }
        }
        
        return result
    }
    
}
