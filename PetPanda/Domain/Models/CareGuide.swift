//
//  CareGuide.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

struct CareGuide: Identifiable, Equatable {
    let id: String
    let title: String
    let difficulty: String
    let duration: Int
    let category: String
    let tags: [String]
    let steps: [CareGuideStep]
    let summary: [String]
    let faq: [FAQItem]
}

struct CareGuideStep: Identifiable, Equatable {
    let id: String
    let title: String
    let content: [String]
    let image: String?
    let hint: String?
}

struct FAQItem: Identifiable, Equatable {
    let id = UUID().uuidString
    let question: String
    let answer: String
}

extension CareGuideDTO {
    func toDomain() -> CareGuide {
        CareGuide(
            id: id,
            title: title,
            difficulty: difficulty,
            duration: duration,
            category: category,
            tags: tags,
            steps: steps.map { $0.toDomain() },
            summary: summary,
            faq: faq.map { FAQItem(question: $0.question, answer: $0.answer) }
        )
    }
}

extension CareGuideStepDTO {
    func toDomain() -> CareGuideStep {
        CareGuideStep(
            id: id,
            title: title,
            content: content,
            image: image,
            hint: hint
        )
    }
}
