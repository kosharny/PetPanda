//
//  ArticlesListViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI
import CoreData
import Combine

@MainActor
final class TestDataViewModel: ObservableObject {

    @Published var articles: [ArticleUIModel] = []
    @Published var guides: [CareGuide] = []
    @Published var quizzes: [Quiz] = []
    @Published var errorMessage: String?

    private let coreDataStack: CoreDataStack
    private let importer: ContentImporting
    private let articlesRepository: ArticlesRepositoryImpl
    private let guidesRepository: CareGuideRepositoryImpl
    private let quizzesRepository: QuizRepositoryImpl

    init(coreDataStack: CoreDataStack, importer: ContentImporting) {
        self.coreDataStack = coreDataStack
        self.importer = importer
        self.articlesRepository = ArticlesRepositoryImpl(context: coreDataStack.viewContext)
        self.guidesRepository = CareGuideRepositoryImpl(context: coreDataStack.viewContext)
        self.quizzesRepository = QuizRepositoryImpl(context: coreDataStack.viewContext)
    }

    func loadData() async {
        do {
            // Импорт всех данных
            try await importer.importAll()

            // Загружаем данные из репозиториев
            articles = try articlesRepository.fetchAll().map { ArticleUIModel(from: $0) }
            guides = try guidesRepository.fetchAll()
            quizzes = try quizzesRepository.fetchAll()

        } catch {
            errorMessage = "❌ Failed to load data: \(error)"
        }
    }
}
