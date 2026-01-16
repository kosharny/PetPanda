//
//  CareGuideMapper.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation
import CoreData

protocol CareGuideMapping {
    func map(dto: CareGuideDTO, in context: NSManagedObjectContext) throws
}

final class CareGuideMapper: CareGuideMapping {

    func map(
        dto: CareGuideDTO,
        in context: NSManagedObjectContext
    ) throws {

        let entity = try fetchOrCreate(id: dto.id, in: context)

        if entity.isInserted {
            entity.id = dto.id
            entity.isCompleted = false
            entity.currentStepIndex = 0
        }
    }
}

private extension CareGuideMapper {

    func fetchOrCreate(
        id: String,
        in context: NSManagedObjectContext
    ) throws -> CareGuideProgressEntity {

        let request: NSFetchRequest<CareGuideProgressEntity> =
            CareGuideProgressEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        if let existing = try context.fetch(request).first {
            return existing
        }

        let new = CareGuideProgressEntity(context: context)
        new.id = id
        return new
    }
}


