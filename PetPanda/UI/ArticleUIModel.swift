//
//  ArticleUIModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

struct ArticleUIModel: Identifiable, Equatable {
    let id: String
    let title: String
    let categoryId: String
    let tags: [String]
    let readTime: Int
    let coverImage: String
    let lastUpdated: Date?
    let isRead: Bool
    let readProgress: Double

    init(from article: Article) {
        self.id = article.id
        self.title = article.title
        self.categoryId = article.categoryId
        self.tags = article.tags
        self.readTime = article.readTime
        self.coverImage = article.coverImage
        self.lastUpdated = article.lastUpdated
        self.isRead = article.isRead
        self.readProgress = article.readProgress
    }
}

