//
//  ArticlesRepository.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation
import CoreData

protocol ArticlesRepository {
    func fetchAll() throws -> [Article]
    func fetch(by categoryId: String) throws -> [Article]
    func fetch(byId id: String) throws -> Article
    func markAsRead(articleId: String) throws
    func updateProgress(articleId: String, progress: Double) throws
}

final class ArticlesRepositoryImpl: ArticlesRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension ArticlesRepositoryImpl {

    func fetchAll() throws -> [Article] {

        let request: NSFetchRequest<ArticleEntity> =
            ArticleEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "lastUpdated", ascending: false)
        ]

        let entities = try context.fetch(request)
        return entities.map { $0.toDomain() }
    }
}

extension ArticlesRepositoryImpl {

    func fetch(by categoryId: String) throws -> [Article] {

        let request: NSFetchRequest<ArticleEntity> =
            ArticleEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "categoryId == %@", categoryId
        )

        request.sortDescriptors = [
            NSSortDescriptor(key: "lastUpdated", ascending: false)
        ]

        let entities = try context.fetch(request)
        return entities.map { $0.toDomain() }
    }
}

extension ArticlesRepositoryImpl {

    func fetch(byId id: String) throws -> Article {
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        guard let entity = try context.fetch(request).first else {
            throw NSError(
                domain: "ArticlesRepository",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Article not found"]
            )
        }
        
        return entity.toDomain()
    }
}

extension ArticlesRepositoryImpl {

    func markAsRead(articleId: String) throws {
        let entity = try fetchEntity(id: articleId)
        entity.isRead = true
        entity.readProgress = 1.0
        entity.lastOpenedAt = Date()
        try context.save()
    }

    func updateProgress(articleId: String, progress: Double) throws {
        let entity = try fetchEntity(id: articleId)
        entity.readProgress = min(max(progress, 0), 1)
        entity.isRead = progress >= 1.0
        entity.lastOpenedAt = Date()
        try context.save()
    }
}

private extension ArticlesRepositoryImpl {

    func fetchEntity(id: String) throws -> ArticleEntity {

        let request: NSFetchRequest<ArticleEntity> =
            ArticleEntity.fetchRequest()

        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        guard let entity = try context.fetch(request).first else {
            throw NSError(
                domain: "ArticlesRepository",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Article not found"]
            )
        }

        return entity
    }
}


