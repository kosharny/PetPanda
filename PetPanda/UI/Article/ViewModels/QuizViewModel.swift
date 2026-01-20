//
//  QuizViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 20.01.2026.
//

import Foundation
import Combine

@MainActor
final class QuizViewModel: ObservableObject {
    
    @Published var isQuizStarted: Bool = false
    @Published private(set) var quiz: Quiz?
    @Published var currentStepIndex: Int = 0
    
    @Published var selectedAnswerIndex: Int? = nil
    @Published var isAnswered: Bool = false
    @Published var score: Int = 0                 
    
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var isFavorite = false
    
    private let quizId: String
    private let repository: QuizRepository
    private let favorites: FavoritesRepository
    
    
    var currentQuestion: QuizQuestion? {
        guard let quiz = quiz, currentStepIndex < quiz.questions.count else { return nil }
        return quiz.questions[currentStepIndex]
    }
    
    var totalSteps: Int {
        quiz?.questions.count ?? 0
    }
    
    var progressTitle: String {
        "Question \(currentStepIndex + 1) of \(totalSteps)"
    }
    
    var firstSentenceOfDescription: String {
        guard let description = quiz?.description else { return "" }
        if let firstDotIndex = description.firstIndex(of: ".") {
            return String(description[...firstDotIndex])
        }
        return description
    }
    
    
    init(
        quizId: String,
        repository: QuizRepository,
        favorites: FavoritesRepository
    ) {
        self.quizId = quizId
        self.repository = repository
        self.favorites = favorites
    }
    
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let allQuizzes = try repository.fetchAll()
            guard let foundQuiz = allQuizzes.first(where: { $0.id == quizId }) else {
                throw NSError(domain: "QuizViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "Quiz not found"])
            }
            self.quiz = foundQuiz
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isFavorite = favorites.isFavorite(id: quizId, type: .quiz)
        isLoading = false
    }
    
    func startQuiz() {
        currentStepIndex = 0
        score = 0
        resetStepState()
        isQuizStarted = true
    }
    
    func selectAnswer(at index: Int) {
        guard !isAnswered, let question = currentQuestion else { return }
        
        selectedAnswerIndex = index
        isAnswered = true
        
        if index == question.correctIndex {
            score += 1
        }
    }
    
    func nextStep() {
        guard let quiz = quiz, currentStepIndex < quiz.questions.count - 1 else { return }
        
        currentStepIndex += 1
        resetStepState()
    }
    
    func completeQuiz() {
        try? repository.saveResult(quizId: quizId, score: score, totalQuestions: totalSteps)
    }
    
    func toggleFavorite() {
        favorites.toggle(id: quizId, type: .quiz)
        isFavorite = favorites.isFavorite(id: quizId, type: .quiz)
    }
    
    private func resetStepState() {
        selectedAnswerIndex = nil
        isAnswered = false
    }
}
