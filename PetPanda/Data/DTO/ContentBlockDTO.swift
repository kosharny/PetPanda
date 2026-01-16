//
//  ContentBlockDTO.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

enum ContentBlockType: String, Decodable {
    case text
    case list
    case fact
    case qa
    case image
}

enum ContentBlockValueDTO: Decodable {
    case text(String)
    case list([String])
    case qa([QADTO])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let text = try? container.decode(String.self) {
            self = .text(text)
        } else if let list = try? container.decode([String].self) {
            self = .list(list)
        } else if let qa = try? container.decode([QADTO].self) {
            self = .qa(qa)
        } else {
            throw DecodingError.typeMismatch(
                ContentBlockValueDTO.self,
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Unsupported ContentBlock value")
            )
        }
    }
}

struct ContentBlockDTO: Decodable {
    let type: ContentBlockType
    let title: String?
    let value: ContentBlockValueDTO

    enum CodingKeys: String, CodingKey {
        case type
        case title
        case value
    }
}

struct QADTO: Codable {
    let question: String
    let answer: String
}
