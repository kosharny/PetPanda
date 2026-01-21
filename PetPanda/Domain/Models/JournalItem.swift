//
//  JournalItem.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 21.01.2026.
//

import Foundation

struct JournalItem: Identifiable, Codable {
    let id: String
    let type: ContentType
    let date: Date
    let title: String
    let category: String
    let tag: String
    
    var typeDisplayName: String {
        switch type {
        case .article: return "Article"
        case .care:    return "Guide"
        case .quiz:    return "Quiz"
        }
    }
}
