//
//  Article.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

struct Article: Identifiable, Equatable {
    let id: String
    let title: String
    let categoryId: String
    let tags: [String]
    let readTime: Int
    let coverImage: String
    let lastUpdated: Date?

    let isRead: Bool
    let readProgress: Double
}

extension ArticleEntity {

    func toDomain() -> Article {
        Article(
            id: id ?? "",
            title: title ?? "",
            categoryId: categoryId ?? "",
            tags: tagsArray,
            readTime: Int(readTime),
            coverImage: coverImage ?? "",
            lastUpdated: lastUpdated,
            isRead: isRead,
            readProgress: readProgress
        )
    }
}


