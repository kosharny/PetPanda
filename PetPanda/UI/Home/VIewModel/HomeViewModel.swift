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
    
    init(
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository
    ) {
        self.articlesRepo = articlesRepo
        self.careRepo = careRepo
        self.quizRepo = quizRepo
    }
    
    func loadData() async {
        isLoading = true
        
        do {
            let fetchedArticle = try articlesRepo.fetchAll().first
            let fetchedCare = try careRepo.fetchAll().last
            let fetchedQuiz = try quizRepo.fetchAll().last
            
            var newRecommendations: [HomeRecommendation] = []
            
            if let article = fetchedArticle {
                newRecommendations.append(HomeRecommendation(
                    id: article.id,
                    title: article.title,
                    category: "Article",
                    tag: article.categoryId,
                    type: .article
                ))
            }
            
            if let care = fetchedCare {
                newRecommendations.append(HomeRecommendation(
                    id: care.id,
                    title: care.title,
                    category: "Guides",
                    tag: care.category,
                    type: .care
                ))
            }
            
            if let quiz = fetchedQuiz {
                newRecommendations.append(HomeRecommendation(
                    id: quiz.id,
                    title: quiz.title,
                    category: "Quizzes",
                    tag: quiz.categoryId,
                    type: .quiz
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
}

enum ContentType {
    case article, care, quiz
}
