//
//  ArticleMapper.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation
import CoreData

protocol ArticleMapping {
    func map(dto: ArticleDTO, in context: NSManagedObjectContext) throws -> ArticleEntity
}

final class ArticleMapper: ArticleMapping {

    func map(
        dto: ArticleDTO,
        in context: NSManagedObjectContext
    ) throws -> ArticleEntity {

        let entity = try fetchOrCreateArticle(id: dto.id, in: context)

        // MARK: - Immutable content (from JSON)
        entity.id = dto.id
        entity.title = dto.title
        entity.categoryId = dto.categoryId
        entity.tagsArray = dto.tags
        entity.readTime = Int16(dto.readTime)
        entity.coverImage = dto.coverImage
        entity.lastUpdated = DateParser.articleDateFormatter.date(from: dto.lastUpdated)

        // Content blocks → Data (JSON encoded)
        entity.contentBlocksData = try encodeContentBlocks(dto.contentBlocks)

        // MARK: - Do NOT touch user progress here
        if entity.isInserted {
            entity.isRead = false
            entity.readProgress = 0.0
            entity.lastOpenedAt = nil
        }

        return entity
    }
}

extension ArticleEntity {

    var tagsArray: [String] {
        get {
            tags as? [String] ?? []
        }
        set {
            tags = newValue as NSObject
        }
    }
}


private extension ArticleMapper {

    func fetchOrCreateArticle(
        id: String,
        in context: NSManagedObjectContext
    ) throws -> ArticleEntity {

        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        if let existing = try context.fetch(request).first {
            return existing
        }

        let new = ArticleEntity(context: context)
        new.id = id
        return new
    }
}

private extension ArticleMapper {

    func encodeContentBlocks(
        _ blocks: [ContentBlockDTO]
    ) throws -> Data {

        let storageBlocks: [ContentBlockStorageDTO] = blocks.map { block in
            ContentBlockStorageDTO(
                type: block.type.rawValue,
                title: block.title,
                value: mapValue(block.value)
            )
        }

        return try JSONEncoder().encode(storageBlocks)
    }

    func mapValue(_ value: ContentBlockValueDTO) -> ContentBlockStorageDTO.CodableValue {
        switch value {
        case .text(let text):
            return .string(text)
        case .list(let list):
            return .array(list)
        case .qa(let qa):
            return .qa(qa)
        }
    }
}





