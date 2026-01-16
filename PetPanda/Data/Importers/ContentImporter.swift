//
//  ContentImporter.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation
import CoreData

protocol ContentImporting {
    func importAll() async throws
}

final class ContentImporter: ContentImporting {

    private let jsonLoader: JSONLoading
    private let coreDataStack: CoreDataStack
    private let articleMapper: ArticleMapping
    private let guideMapper: CareGuideMapping
    private let quizMapper: QuizMapping

    init(
        jsonLoader: JSONLoading = JSONLoader(),
        coreDataStack: CoreDataStack,
        articleMapper: ArticleMapping = ArticleMapper(),
        guideMapper: CareGuideMapping = CareGuideMapper(),
        quizMapper: QuizMapping = QuizMapper()
    ) {
        self.jsonLoader = jsonLoader
        self.coreDataStack = coreDataStack
        self.articleMapper = articleMapper
        self.guideMapper = guideMapper
        self.quizMapper = quizMapper
    }
}

extension ContentImporter {

    func importAll() async throws {

        try await coreDataStack.persistentContainer.performBackgroundTask { context in

            do {
                try self.importArticles(in: context)
                try self.importGuides(in: context)
                try self.importQuizzes(in: context)

                if context.hasChanges {
                    try context.save()
                }
            } catch {
                context.rollback()
                throw error
            }
        }
    }
}

private extension ContentImporter {

    func importArticles(in context: NSManagedObjectContext) throws {

        let response = try jsonLoader.load(
            ArticlesResponseDTO.self,
            from: "articles"
        )

        response.articles.forEach { dto in
            _ = try? articleMapper.map(dto: dto, in: context)
        }
    }
}



private extension ContentImporter {

    func importGuides(in context: NSManagedObjectContext) throws {

        let response = try jsonLoader.load(
            CareGuidesResponseDTO.self,
            from: "care_guides"
        )

        response.guides.forEach { dto in
            _ = try? guideMapper.map(dto: dto, in: context)
        }
    }
}

private extension ContentImporter {

    func importQuizzes(in context: NSManagedObjectContext) throws {

        let response = try jsonLoader.load(
            QuizzesResponseDTO.self,
            from: "quizzes"
        )

        response.quizzes.forEach { dto in
            _ = try? quizMapper.map(dto: dto, in: context)
        }
    }
}
