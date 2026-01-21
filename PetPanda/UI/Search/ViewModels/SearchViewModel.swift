//
//  SearchViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 21.01.2026.
//

import SwiftUI
import Combine

enum SearchType: String, CaseIterable, Identifiable {
    case article = "Articles"
    case guide = "Guides"
    case quiz = "Quizzes"
    var id: String { rawValue }
}

enum ReadingTimeType: String, CaseIterable, Identifiable {
    case short = "< 5 min"
    case medium = "5 - 10 min"
    case long = "10+ min"
    var id: String { rawValue }
}

@MainActor
final class SearchViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var recentSearches: [String] = []
    @Published var isLoading = false
    
    @Published var selectedType: SearchType? = nil
    @Published var selectedCategory: String? = nil
    @Published var selectedTime: ReadingTimeType? = nil
    @Published var unreadOnly: Bool = false
    @Published var selectedProgress: String? = nil
    
    private let articlesRepo: ArticlesRepository
    private let careRepo: CareGuideRepository
    private let quizRepo: QuizRepository
    
    init(
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository
    ) {
        self.articlesRepo = articlesRepo
        self.careRepo = careRepo
        self.quizRepo = quizRepo
        loadHistory()
    }
    
    private func loadHistory() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    }
    
    private func saveHistory(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        var history = recentSearches
        if let index = history.firstIndex(of: query) {
            history.remove(at: index)
        }
        history.insert(query, at: 0)
        
        if history.count > 10 { history = Array(history.prefix(10)) }
        
        recentSearches = history
        UserDefaults.standard.set(history, forKey: "RecentSearches")
    }
    
    func clearHistory() {
        recentSearches = []
        UserDefaults.standard.removeObject(forKey: "RecentSearches")
    }
    
    func resetFilters() {
        selectedType = nil
        selectedCategory = nil
        selectedTime = nil
        unreadOnly = false
        selectedProgress = nil
    }
    
    func performSearch() -> [String] {
        isLoading = true
        defer { isLoading = false }
        
        if !searchText.isEmpty {
            saveHistory(query: searchText)
        }
        
        var resultIDs: [String] = []
        
        // 1. Fetch all data
        let articles = (try? articlesRepo.fetchAll()) ?? []
        let guides = (try? careRepo.fetchAll()) ?? []
        let quizzes = (try? quizRepo.fetchAll()) ?? []
        
        let includeArticles = selectedType == nil || selectedType == .article
        let includeGuides = selectedType == nil || selectedType == .guide
        let includeQuizzes = selectedType == nil || selectedType == .quiz
        
        if includeArticles {
            let filtered = articles.filter { item in
                matchesText(item.title, item.tags) &&
                matchesCategory(item.categoryId) &&
                matchesTime(5) &&
                matchesUnread(item.readProgress)
            }
            resultIDs.append(contentsOf: filtered.map { $0.id })
        }
        
        if includeGuides {
            let filtered = guides.filter { item in
                let progress = careRepo.getCalculatedProgress(for: item.id)
                return matchesText(item.title, item.tags) &&
                matchesCategory(item.category) &&
                matchesTime(item.duration) &&
                matchesUnread(progress)
            }
            resultIDs.append(contentsOf: filtered.map { $0.id })
        }
        
        if includeQuizzes {
            let filtered = quizzes.filter { item in
                let results = (try? quizRepo.fetchResults(quizId: item.id)) ?? []
                let progress = results.isEmpty ? 0.0 : 1.0
                
                return matchesText(item.title, item.tags) &&
                matchesCategory("Quizzes") &&
                matchesUnread(progress)
            }
            resultIDs.append(contentsOf: filtered.map { $0.id })
        }
        
        return resultIDs
    }
    
    
    private func matchesText(_ title: String, _ tags: [String]) -> Bool {
        guard !searchText.isEmpty else { return true }
        let query = searchText.lowercased()
        return title.lowercased().contains(query) || tags.contains { $0.lowercased().contains(query) }
    }
    
    private func matchesCategory(_ category: String) -> Bool {
        guard let selected = selectedCategory else { return true }
        return category.lowercased() == selected.lowercased()
    }
    
    private func matchesTime(_ duration: Int) -> Bool {
        guard let selected = selectedTime else { return true }
        switch selected {
        case .short: return duration < 5
        case .medium: return duration >= 5 && duration <= 10
        case .long: return duration > 10
        }
    }
    
    private func matchesUnread(_ progress: Double) -> Bool {
        if unreadOnly {
            return progress == 0.0
        }
        if let progFilter = selectedProgress {
            switch progFilter {
            case "< 20%": return progress < 0.2
            case "20 - 70%": return progress >= 0.2 && progress <= 0.7
            case "70 - 100%": return progress > 0.7
            default: return true
            }
        }
        return true
    }
}
