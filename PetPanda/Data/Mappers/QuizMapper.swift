//
//  QuizMapper.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation
import CoreData

protocol QuizMapping {
    func map(dto: QuizDTO, in context: NSManagedObjectContext) throws
}

final class QuizMapper: QuizMapping {

    func map(
        dto: QuizDTO,
        in context: NSManagedObjectContext
    ) throws {


        _ = dto.id 
    }
}
