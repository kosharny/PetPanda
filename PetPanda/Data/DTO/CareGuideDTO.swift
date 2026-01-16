//
//  CareGuideDTO.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

struct CareGuideDTO: Decodable {
    let id: String
    let title: String
    let difficulty: String
    let category: String
    let duration: Int
    let tags: [String]
    let steps: [CareGuideStepDTO]
    let summary: [String]
    let faq: [QADTO]
}

struct CareGuidesResponseDTO: Decodable {
    let guides: [CareGuideDTO]
}

struct CareGuideStepDTO: Decodable {
    let id: String
    let title: String
    let content: [String]
    let image: String?
    let hint: String?
}
