//
//  FavoriteItem.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 20.01.2026.
//

import Foundation

enum FavoriteType: String, Codable {
    case article
    case care
    case quiz
}

struct FavoriteItem: Identifiable, Hashable {
    let id: String
    let type: FavoriteType
    let title: String
    let subtitle: String
    let tag: String
    let progress: Double
}

struct FavoriteRef: Hashable, Codable {
    let id: String
    let type: FavoriteType
}

extension FavoriteType {
    init(contentType: ContentType) {
        switch contentType {
        case .article: self = .article
        case .care: self = .care
        case .quiz: self = .quiz
        }
    }
}
