//
//  HomeViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 20.01.2026.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var recommendations: [HomeRecommendation] = []
    @Published private(set) var isLoading = false
    
    private let articlesRepo: ArticlesRepository
    private let careRepo: CareGuideRepository
    private let quizRepo: QuizRepository
    private let importer: ContentImporting
    private let favoritesRepo: FavoritesRepository
    
    init(
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository,
        importer: ContentImporting,
        favoritesRepo: FavoritesRepository
    ) {
        self.articlesRepo = articlesRepo
        self.careRepo = careRepo
        self.quizRepo = quizRepo
        self.importer = importer
        self.favoritesRepo = favoritesRepo
    }
    
    func loadData() async {
        isLoading = true
        
        do {
            var allArticles = try articlesRepo.fetchAll()
            
            if allArticles.isEmpty {
                try await importer.importAll()
                allArticles = try articlesRepo.fetchAll()
            }
            
            let fetchedArticle = allArticles.first
            let fetchedCare = try careRepo.fetchAll().last
            let fetchedQuiz = try quizRepo.fetchAll().last
            
            var newRecommendations: [HomeRecommendation] = []
            
            if let article = fetchedArticle {
                newRecommendations.append(HomeRecommendation(
                    id: article.id,
                    title: article.title,
                    category: "Article",
                    tag: article.categoryId,
                    type: .article,
                    isFavorite: favoritesRepo.isFavorite(id: article.id, type: .article)
                ))
            }
            
            if let care = fetchedCare {
                newRecommendations.append(HomeRecommendation(
                    id: care.id,
                    title: care.title,
                    category: "Guides",
                    tag: care.category,
                    type: .care,
                    isFavorite: favoritesRepo.isFavorite(id: care.id, type: .care)
                ))
            }
            
            if let quiz = fetchedQuiz {
                newRecommendations.append(HomeRecommendation(
                    id: quiz.id,
                    title: quiz.title,
                    category: "Quizzes",
                    tag: quiz.categoryId,
                    type: .quiz,
                    isFavorite: favoritesRepo.isFavorite(id: quiz.id, type: .quiz)
                ))
            }
            
            self.recommendations = newRecommendations
            
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
}

struct HomeRecommendation: Identifiable {
    let id: String
    let title: String
    let category: String
    let tag: String
    let type: ContentType
    var isFavorite: Bool
}

enum ContentType {
    case article, care, quiz
}
