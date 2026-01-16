//
//  QuizRepository.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation
import CoreData

protocol QuizRepository {
    func fetchAll() throws -> [Quiz]
    func fetch(by categoryId: String) throws -> [Quiz]
    func saveResult(quizId: String, score: Int, totalQuestions: Int) throws
    func fetchResults(quizId: String) throws -> [QuizResultEntity]
}

final class QuizRepositoryImpl: QuizRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [Quiz] {
        let loader = JSONLoader()
        let response = try loader.load(QuizzesResponseDTO.self, from: "quizzes")
        return response.quizzes.map { $0.toDomain() }
    }

    func fetch(by categoryId: String) throws -> [Quiz] {
        try fetchAll().filter { $0.categoryId == categoryId }
    }

    func saveResult(quizId: String, score: Int, totalQuestions: Int) throws {
        let entity = QuizResultEntity(context: context)
        entity.id = UUID()
        entity.quizId = quizId
        entity.score = Int16(score)
        entity.totalQuestions = Int16(totalQuestions)
        entity.date = Date()
        try context.save()
    }

    func fetchResults(quizId: String) throws -> [QuizResultEntity] {
        let request: NSFetchRequest<QuizResultEntity> = QuizResultEntity.fetchRequest()
        request.predicate = NSPredicate(format: "quizId == %@", quizId)
        return try context.fetch(request)
    }
}
