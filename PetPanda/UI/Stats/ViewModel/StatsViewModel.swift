//
//  StatsViewModel.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 21.01.2026.
//

import SwiftUI
import CoreData
import Charts
import Combine

enum StatsFilter: String, CaseIterable {
    case allTime = "All time"
    case week = "Week"
    case month = "Month"
}

@MainActor
final class StatsViewModel: ObservableObject {

    @Published private(set) var filter: StatsFilter = .allTime
    
    @Published private(set) var articlesRead = 0
    @Published private(set) var guidesCompleted = 0
    @Published private(set) var quizzesCompleted = 0
    @Published private(set) var streak = 0
    
    @Published private(set) var dailyActivityData: [ChartData] = []
    @Published private(set) var categoryDistribution: [PandaCategory] = []
    
    @Published private(set) var quizResultText: String = "–"
    
    private let statsRepo: StatsRepository
    private let journalRepo: JournalRepository
    private let quizRepo: QuizRepository
    
    init(
        statsRepo: StatsRepository,
        journalRepo: JournalRepository,
        quizRepo: QuizRepository
    ) {
        self.statsRepo = statsRepo
        self.journalRepo = journalRepo
        self.quizRepo = quizRepo
        reload()
    }

    func setFilter(_ newFilter: StatsFilter) {
        guard filter != newFilter else { return }
        filter = newFilter
        reload()
    }

    func reload() {
        let progress = statsRepo.fetchUserProgress(filter: filter)

        calculateTotals(from: progress)
        buildDailyActivity(from: progress)
        buildCategoryDistribution()
    }


    private func calculateTotals(from progress: [UserProgress]) {
        articlesRead = progress.reduce(into: 0) { $0 += $1.articlesRead }
        guidesCompleted = progress.reduce(into: 0) { $0 += $1.guidesCompleted }
        quizzesCompleted = progress.reduce(into: 0) { $0 += $1.quizzesCompleted }

        streak = progress.map(\.readingStreak).max() ?? 0
    }
    
    private func loadQuizResults() {
        do {
            let results = try quizRepo.fetchResults(quizId: "all")
            let correct = results.reduce(0) { $0 + Int($1.score) }
            let total = results.reduce(0) { $0 + Int($1.totalQuestions) }
            quizResultText = total > 0 ? "\(correct)/\(total)" : "–"
        } catch {
            quizResultText = "–"
        }
    }




    private func buildDailyActivity(from progress: [UserProgress]) {
        let grouped = Dictionary(grouping: progress) {
            formatDate($0.lastActiveDate)
        }

        dailyActivityData = grouped.map { date, items in
            let total = items.reduce(0) {
                $0 + $1.articlesRead + $1.guidesCompleted + $1.quizzesCompleted
            }

            return ChartData(
                category: date,
                value: Double(total),
                color: .mainGreen
            )
        }
        .sorted { $0.category < $1.category }
    }


    private func buildCategoryDistribution() {
        guard let allItems = try? journalRepo.fetchAll() else {
            categoryDistribution = []
            return
        }

        let filtered = allItems.filter { item in
            guard let fromDate = filter.startDate else { return true }
            return item.date >= fromDate
        }

        let grouped = Dictionary(grouping: filtered, by: { $0.category })
        let total = Double(filtered.count)

        guard total > 0 else {
            categoryDistribution = []
            return
        }

        categoryDistribution = grouped.map { category, items in
            PandaCategory(
                name: category,
                value: Double(items.count) / total * 100,
                color: PandaCategoryColorResolver.color(for: category)
            )
        }
    }



    private func formatDate(_ date: Date?) -> String {
        guard let date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}

extension StatsFilter {
    var startDate: Date? {
        let calendar = Calendar.current
        switch self {
        case .allTime:
            return nil
        case .week:
            return calendar.date(byAdding: .day, value: -7, to: Date())
        case .month:
            return calendar.date(byAdding: .month, value: -1, to: Date())
        }
    }
}

enum PandaCategoryColorResolver {
    static func color(for category: String) -> Color {
        switch category {
        case "Health": return .mainGreen
        case "Training": return .blueCharts
        case "Nutrition": return .greanCharts
        default: return .gray
        }
    }
}
