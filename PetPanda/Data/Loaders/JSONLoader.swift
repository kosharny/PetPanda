//
//  JSONLoader.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import Foundation

protocol JSONLoading {
    func load<T: Decodable>(
        _ type: T.Type,
        from fileName: String
    ) throws -> T
}

enum JSONLoaderError: Error, LocalizedError {
    case fileNotFound(String)
    case decodingFailed(String, Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let file):
            return "JSON file not found: \(file).json"
        case .decodingFailed(let file, let error):
            return "Failed to decode \(file).json: \(error.localizedDescription)"
        }
    }
}

final class JSONLoader: JSONLoading {

    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func load<T: Decodable>(
        _ type: T.Type,
        from fileName: String
    ) throws -> T {

        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw JSONLoaderError.fileNotFound(fileName)
        }

        let data = try Data(contentsOf: url)

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw JSONLoaderError.decodingFailed(fileName, error)
        }
    }
}
