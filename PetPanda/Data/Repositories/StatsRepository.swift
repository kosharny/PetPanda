//
//  StatsRepository.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 21.01.2026.
//

import Foundation
import CoreData

protocol StatsRepository {
    func fetchUserProgress(filter: StatsFilter) -> [UserProgress]
}

final class StatsRepositoryImpl: StatsRepository {

    private let journalRepo: JournalRepository
    private let articlesRepo: ArticlesRepository
    private let guidesRepo: CareGuideRepository
    private let quizzesRepo: QuizRepository

    init(
        journalRepo: JournalRepository,
        articlesRepo: ArticlesRepository,
        guidesRepo: CareGuideRepository,
        quizzesRepo: QuizRepository
    ) {
        self.journalRepo = journalRepo
        self.articlesRepo = articlesRepo
        self.guidesRepo = guidesRepo
        self.quizzesRepo = quizzesRepo
    }

    func fetchUserProgress(filter: StatsFilter) -> [UserProgress] {

        let fromDate = filter.startDate
        let allItems: [JournalItem]
        do {
            allItems = try journalRepo.fetchAll()
        } catch {
            print("Failed to fetch journal items:", error)
            return []
        }


        let filteredItems = allItems.filter {
            guard let fromDate else { return true }
            return $0.date >= fromDate
        }
        
        let groupedByDay = Dictionary(grouping: filteredItems) { item in
            Calendar.current.startOfDay(for: item.date)
        }

        return groupedByDay.map { day, items in
            let articlesRead = items.filter { $0.type == .article }.count
            let guidesCompleted = items.filter { $0.type == .care }.count
            let quizzesCompleted = items.filter { $0.type == .quiz }.count

            return UserProgress(
                date: day,
                articlesRead: articlesRead,
                guidesCompleted: guidesCompleted,
                quizzesCompleted: quizzesCompleted,
                readingStreak: calculateStreak(from: filteredItems),
                lastActiveDate: day
            )
        }
        .sorted { $0.date < $1.date }
    }

    private func calculateStreak(from visits: [JournalItem]) -> Int {
        let days = Set(visits.map {
            Calendar.current.startOfDay(for: $0.date)
        })

        var streak = 0
        var current = Calendar.current.startOfDay(for: Date())

        while days.contains(current) {
            streak += 1
            current = Calendar.current.date(byAdding: .day, value: -1, to: current)!
        }

        return streak
    }
}

