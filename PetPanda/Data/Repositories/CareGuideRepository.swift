//
//  CareGuideRepository.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation
import CoreData

protocol CareGuideRepository {
    func fetchAll() throws -> [CareGuide]
    func fetch(by categoryId: String) throws -> [CareGuide]
    func updateProgress(guideId: String, stepIndex: Int, completed: Bool) throws
    func fetchProgress(guideId: String) throws -> CareGuideProgressEntity?
}

final class CareGuideRepositoryImpl: CareGuideRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [CareGuide] {
        let loader = JSONLoader()
        let response = try loader.load(CareGuidesResponseDTO.self, from: "care_guides")
        return response.guides.map { $0.toDomain() }
    }

    func fetch(by categoryId: String) throws -> [CareGuide] {
        try fetchAll().filter { $0.category == categoryId }
    }

    func updateProgress(guideId: String, stepIndex: Int, completed: Bool) throws {
        let entity = try fetchOrCreate(guideId: guideId)
        entity.currentStepIndex = Int16(stepIndex)
        entity.isCompleted = completed
        try context.save()
    }

    func fetchProgress(guideId: String) throws -> CareGuideProgressEntity? {
        let request: NSFetchRequest<CareGuideProgressEntity> = CareGuideProgressEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", guideId)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func fetchOrCreate(guideId: String) throws -> CareGuideProgressEntity {
        if let existing = try fetchProgress(guideId: guideId) {
            return existing
        }
        let entity = CareGuideProgressEntity(context: context)
        entity.id = guideId
        entity.isCompleted = false
        entity.currentStepIndex = 0
        return entity
    }
}
