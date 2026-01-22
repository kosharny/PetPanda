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
    @Published private(set) var randomFact: Article?
    
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
            
            self.randomFact = allArticles
                .filter { $0.categoryId.lowercased() == "fun facts" }
                .randomElement()
            
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
                    isFavorite: favoritesRepo.isFavorite(id: article.id, type: .article),
                    progress: article.readProgress,
                    duration: article.readTime
                ))
            }
            
            if let care = fetchedCare {
                let progressValue = careRepo.getCalculatedProgress(for: care.id)
                    
                newRecommendations.append(HomeRecommendation(
                    id: care.id,
                    title: care.title,
                    category: "Guides",
                    tag: care.category,
                    type: .care,
                    isFavorite: favoritesRepo.isFavorite(id: care.id, type: .care),
                    progress: progressValue,
                    duration: care.duration
                ))
            }
            
            if let quiz = fetchedQuiz {
                let results = (try? quizRepo.fetchResults(quizId: quiz.id)) ?? []
                let isDone = !results.isEmpty
                
                newRecommendations.append(HomeRecommendation(
                    id: quiz.id,
                    title: quiz.title,
                    category: "Quizzes",
                    tag: quiz.categoryId,
                    type: .quiz,
                    isFavorite: favoritesRepo.isFavorite(id: quiz.id, type: .quiz),
                    progress: isDone ? 1.0 : 0.0,
                    duration: quiz.duration
                ))
            }
            
            self.recommendations = newRecommendations
            
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
}

extension HomeViewModel {
    func getIds(forCategory category: String) -> [String] {
        var resultIDs: [String] = []
        let query = category.lowercased()
        
        if let articles = try? articlesRepo.fetchAll() {
            let matches = articles.filter { $0.categoryId.lowercased() == query }
            resultIDs.append(contentsOf: matches.map { $0.id })
        }
        
        if let guides = try? careRepo.fetchAll() {
            let matches = guides.filter { $0.category.lowercased() == query }
            resultIDs.append(contentsOf: matches.map { $0.id })
        }
        
        if let quizzes = try? quizRepo.fetchAll() {
            let matches = quizzes.filter { $0.categoryId.lowercased() == query }
            resultIDs.append(contentsOf: matches.map { $0.id })
        }
        
        return resultIDs
    }
    func getIds(for type: ContentType) -> [String] {
        switch type {
        case .article:
            return (try? articlesRepo.fetchAll().map { $0.id }) ?? []
        case .care:
            return (try? careRepo.fetchAll().map { $0.id }) ?? []
        case .quiz:
            return (try? quizRepo.fetchAll().map { $0.id }) ?? []
        }
    }
}

struct HomeRecommendation: Identifiable {
    let id: String
    let title: String
    let category: String
    let tag: String
    let type: ContentType
    var isFavorite: Bool
    let progress: Double
    let duration: Int
}

enum ContentType: Codable {
    case article, care, quiz
}
