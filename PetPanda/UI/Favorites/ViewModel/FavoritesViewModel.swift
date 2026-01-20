//
//  FavoritesViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 20.01.2026.
//

import Foundation
import Combine

enum FavoritesFilter {
    case all
    case article
    case care
    case quiz
}

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published private(set) var items: [FavoriteItem] = []
    @Published var selectedFilter: FavoritesFilter = .all
    @Published var isLoading = false

    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
        load()
    }

    func load() {
        isLoading = true
        items = (try? repository.fetchAll()) ?? []
        isLoading = false
    }

    func selectFilter(_ filter: FavoritesFilter) {
        selectedFilter = filter
    }

    var filteredItems: [FavoriteItem] {
        switch selectedFilter {
        case .all: return items
        case .article: return items.filter { $0.type == .article }
        case .care: return items.filter { $0.type == .care }
        case .quiz: return items.filter { $0.type == .quiz }
        }
    }

    var isEmpty: Bool {
        filteredItems.isEmpty
    }
}

