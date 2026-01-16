//
//  ArticlesDTO.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

struct ArticlesResponseDTO: Decodable {
    let articles: [ArticleDTO]
}

struct ArticleDTO: Decodable {
    let id: String
    let title: String
    let categoryId: String
    let tags: [String]
    let readTime: Int
    let coverImage: String
    let lastUpdated: String
    let contentBlocks: [ContentBlockDTO]
}
