//
//  JournalRepository.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 21.01.2026.
//

import Foundation

protocol JournalRepository {
    func saveVisit(item: JournalItem)
    func fetchAll() throws -> [JournalItem]
    func clearHistory()
}

final class JournalRepositoryImpl: JournalRepository {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let key = "user_journal_history"
    private let maxItems = 100

    func saveVisit(item: JournalItem) {
        var items = (try? fetchAll()) ?? []
        
        items.removeAll { $0.id == item.id && $0.type == item.type }
        
        items.insert(item, at: 0)
        
        if items.count > maxItems {
            items = Array(items.prefix(maxItems))
        }
        
        saveToStorage(items)
    }

    func fetchAll() throws -> [JournalItem] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return try decoder.decode([JournalItem].self, from: data)
    }

    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    private func saveToStorage(_ items: [JournalItem]) {
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
