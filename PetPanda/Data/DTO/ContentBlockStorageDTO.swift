//
//  ContentBlockStorageDTO.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

struct ContentBlockStorageDTO: Codable {
    let type: String
    let title: String?
    let value: CodableValue

    enum CodableValue: Codable {

        case string(String)
        case array([String])
        case qa([QADTO])

        enum CodingKeys: String, CodingKey {
            case string
            case array
            case qa
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {
            case .string(let value):
                try container.encode(value, forKey: .string)
            case .array(let value):
                try container.encode(value, forKey: .array)
            case .qa(let value):
                try container.encode(value, forKey: .qa)
            }
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let value = try container.decodeIfPresent(String.self, forKey: .string) {
                self = .string(value)
            } else if let value = try container.decodeIfPresent([String].self, forKey: .array) {
                self = .array(value)
            } else if let value = try container.decodeIfPresent([QADTO].self, forKey: .qa) {
                self = .qa(value)
            } else {
                throw DecodingError.dataCorrupted(
                    .init(codingPath: decoder.codingPath,
                          debugDescription: "Unsupported CodableValue")
                )
            }
        }
    }

}
