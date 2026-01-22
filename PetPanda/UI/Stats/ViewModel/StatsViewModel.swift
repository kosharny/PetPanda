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

    var startDate: Date? {
        let calendar = Calendar.current
        let now = Date()

        switch self {
        case .allTime:
            return nil
        case .week:
            return calendar.date(byAdding: .day, value: -7, to: now)
        case .month:
            return calendar.date(byAdding: .month, value: -1, to: now)
        }
    }
}

@MainActor
final class StatsViewModel: ObservableObject {

    @Published private(set) var filter: StatsFilter = .allTime
    
    @Published private(set) var articlesRead = 0
    @Published private(set) var guidesCompleted = 0
    @Published private(set) var quizzesCompleted = 0
    @Published private(set) var streak = 0
    
    @Published private(set) var quizResultText: String = "–"
    
    @Published private(set) var dailyActivityData: [ChartData] = []
    @Published private(set) var categoryDistribution: [PandaCategory] = []
    
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
        loadProgressStats()
        loadQuizStats()
        buildCategoryDistribution()
    }
}

private extension StatsViewModel {

    func loadProgressStats() {
        let allProgress = statsRepo.fetchUserProgress(filter: .allTime)
        let filteredProgress = statsRepo.fetchUserProgress(filter: filter)

        calculateTotals(from: filteredProgress)
        streak = allProgress.map(\.readingStreak).max() ?? 0

        buildDailyActivity(from: filteredProgress)
    }

    func calculateTotals(from progress: [UserProgress]) {
        articlesRead = progress.reduce(0) { $0 + $1.articlesRead }
        guidesCompleted = progress.reduce(0) { $0 + $1.guidesCompleted }
        quizzesCompleted = progress.reduce(0) { $0 + $1.quizzesCompleted }
    }

    func buildDailyActivity(from progress: [UserProgress]) {
        let grouped = Dictionary(grouping: progress) {
            dateFormatter.string(from: $0.lastActiveDate)
        }

        dailyActivityData = grouped
            .map { date, items in
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
}

private extension StatsViewModel {

    func loadQuizStats() {
        do {
            let results = try quizRepo.fetchAllResults()
            let filtered = filterResultsByDate(results)
            calculateQuizStats(from: filtered)
        } catch {
            quizResultText = "–"
        }
    }

    func calculateQuizStats(from results: [QuizResultEntity]) {
        let correct = results.reduce(0) { $0 + Int($1.score) }
        let total = results.reduce(0) { $0 + Int($1.totalQuestions) }

        quizResultText = total > 0 ? "\(correct)/\(total)" : "0/0"
    }

    func filterResultsByDate(
        _ results: [QuizResultEntity]
    ) -> [QuizResultEntity] {

        guard let fromDate = filter.startDate else { return results }

        return results.filter {
            guard let date = $0.date else { return false }
            return date >= fromDate
        }
    }
}

private extension StatsViewModel {

    func buildCategoryDistribution() {
        guard let allItems = try? journalRepo.fetchAll() else {
            categoryDistribution = []
            return
        }

        let filtered = allItems.filter {
            guard let fromDate = filter.startDate else { return true }
            return $0.date >= fromDate
        }

        let grouped = Dictionary(grouping: filtered, by: \.tag)
        let total = Double(filtered.count)

        guard total > 0 else {
            categoryDistribution = []
            return
        }

        categoryDistribution = grouped.map { tag, items in
            PandaCategory(
                name: tag.capitalized,
                value: Double(items.count) / total * 100,
                color: PandaCategoryColorResolver.color(for: tag)
            )
        }
    }
}

private extension StatsViewModel {

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
}




enum PandaCategoryColorResolver {
    static func color(for tag: String) -> Color {
        switch tag.lowercased() {
        case "habitat": return .darkBlueChart
        case "population": return .mainGreen
        case "diet": return .darkGreenChart
        case "nutrition": return .blueCharts
        case "care": return .textButton
        case "health": return .greanCharts
        case "quiz": return .text
        default:
            return Color(hue: Double(abs(tag.hashValue % 100)) / 100.0, saturation: 0.7, brightness: 0.8)
        }
    }
}
