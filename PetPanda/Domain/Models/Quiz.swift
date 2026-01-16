//
//  Quiz.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

struct Quiz: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let categoryId: String
    let tags: [String]
    let duration: Int
    let lastUpdated: Date?
    let coverImage: String
    let questions: [QuizQuestion]
}

struct QuizQuestion: Identifiable, Equatable {
    let id: String
    let text: String
    let answers: [String]
    let correctIndex: Int
    let explanation: String
}

extension QuizDTO {
    func toDomain() -> Quiz {
        let lastUpdatedDate: Date?
        let formatter = ISO8601DateFormatter()
        lastUpdatedDate = formatter.date(from: lastUpdated)
        

        return Quiz(
            id: id,
            title: title,
            description: description,
            categoryId: categoryId,
            tags: tags,
            duration: duration,
            lastUpdated: lastUpdatedDate,
            coverImage: coverImage,
            questions: questions.map { $0.toDomain() }
        )
    }
}

extension QuizQuestionDTO {
    func toDomain() -> QuizQuestion {
        QuizQuestion(
            id: id,
            text: text,
            answers: answers,
            correctIndex: correctIndex,
            explanation: explanation
        )
    }
}
