//
//  CategoryDTO.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

struct CategoryDTO: Decodable {
    let id: String
    let name: String
    let icon: String
    let order: Int
}

struct CategoriesResponseDTO: Decodable {
    let categories: [CategoryDTO]
}
