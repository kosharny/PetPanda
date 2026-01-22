//
//  ResultsSearchViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 21.01.2026.
//

import SwiftUI
import Combine

struct ResultDisplayItem: Identifiable {
    let id: String
    let categoryType: String
    let title: String
    let tag: String
    let subTitle: String
    let duration: Int
    let progress: Double
    let isFavorite: Bool
}

enum SortOrder {
    case az, za
}

@MainActor
final class ResultsSearchViewModel: ObservableObject {
    
    private let resultIds: [String]
    private var allItems: [ResultDisplayItem] = []
    @Published var displayedItems: [ResultDisplayItem] = []
    
    @Published var sortOrder: SortOrder? = nil
    @Published var selectedTime: ReadingTimeType? = nil
    @Published var selectedProgress: String? = nil
    @Published var unreadOnly: Bool = false
    
    private let articlesRepo: ArticlesRepository
    private let careRepo: CareGuideRepository
    private let quizRepo: QuizRepository
    private let favoritesRepo: FavoritesRepository
    
    init(
        ids: [String],
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository,
        favoritesRepo: FavoritesRepository
    ) {
        self.resultIds = ids
        self.articlesRepo = articlesRepo
        self.careRepo = careRepo
        self.quizRepo = quizRepo
        self.favoritesRepo = favoritesRepo
        loadData()
    }
    
    
    private func loadData() {
        var tempItems: [ResultDisplayItem] = []
        
        if let articles = try? articlesRepo.fetchAll() {
            let matches = articles.filter { resultIds.contains($0.id) }
            let mapped = matches.map { item in
                ResultDisplayItem(
                    id: item.id,
                    categoryType: "Article",
                    title: item.title,
                    tag: item.tags.first ?? "Info",
                    subTitle: "Habitat",
                    duration: item.readTime,
                    progress: item.readProgress,
                    isFavorite: favoritesRepo.isFavorite(id: item.id, type: .article)
                )
            }
            tempItems.append(contentsOf: mapped)
        }
        
        if let guides = try? careRepo.fetchAll() {
            let matches = guides.filter { resultIds.contains($0.id) }
            let mapped = matches.map { item in
                let prog = careRepo.getCalculatedProgress(for: item.id)
                return ResultDisplayItem(
                    id: item.id,
                    categoryType: "Guide",
                    title: item.title,
                    tag: "Care",
                    subTitle: item.category,
                    duration: item.duration,
                    progress: prog,
                    isFavorite: favoritesRepo.isFavorite(id: item.id, type: .care)
                )
            }
            tempItems.append(contentsOf: mapped)
        }
        
        if let quizzes = try? quizRepo.fetchAll() {
            let matches = quizzes.filter { resultIds.contains($0.id) }
            let mapped = matches.map { item in
                let results = (try? quizRepo.fetchResults(quizId: item.id)) ?? []
                let prog = results.isEmpty ? 0.0 : 1.0
                
                return ResultDisplayItem(
                    id: item.id,
                    categoryType: "Quiz",
                    title: item.title,
                    tag: "Test",
                    subTitle: "Knowledge",
                    duration: item.duration,
                    progress: prog,
                    isFavorite: favoritesRepo.isFavorite(id: item.id, type: .care)
                )
            }
            tempItems.append(contentsOf: mapped)
        }
        
        self.allItems = tempItems
        applyFilters()
    }
    
    func applyFilters() {
        var result = allItems
        
        if unreadOnly {
            result = result.filter { $0.progress == 0 }
        }
        
        if let time = selectedTime {
            result = result.filter { item in
                switch time {
                case .short: return item.duration < 5
                case .medium: return item.duration >= 5 && item.duration <= 10
                case .long: return item.duration > 10
                }
            }
        }
        
        if let prog = selectedProgress {
            result = result.filter { item in
                switch prog {
                case "< 20%": return item.progress < 0.2
                case "20 - 70%": return item.progress >= 0.2 && item.progress <= 0.7
                case "70 - 100%": return item.progress > 0.7
                default: return true
                }
            }
        }
        
        if let order = sortOrder {
            result.sort { first, second in
                switch order {
                case .az: return first.title < second.title
                case .za: return first.title > second.title
                }
            }
        }
        
        displayedItems = result
    }
    
    func resetFilters() {
        sortOrder = nil
        selectedTime = nil
        selectedProgress = nil
        unreadOnly = false
        applyFilters()
    }
}
