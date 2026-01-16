//
//  QuizDTO.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

struct QuizDTO: Decodable {
    let id: String
    let title: String
    let description: String
    let categoryId: String
    let tags: [String]
    let duration: Int
    let lastUpdated: String
    let coverImage: String
    let questions: [QuizQuestionDTO]
}

struct QuizzesResponseDTO: Decodable {
    let quizzes: [QuizDTO]
}

struct QuizQuestionDTO: Decodable {
    let id: String
    let text: String
    let answers: [String]
    let correctIndex: Int
    let explanation: String
}
