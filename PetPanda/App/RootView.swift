//
//  RootView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI
import CoreData

struct RootView: View {
    
    @StateObject private var appState = AppState()
    let container: NSPersistentContainer
    
    private var coreDataStack: CoreDataStack {
        CoreDataStack()
    }
    
    private var articlesRepository: ArticlesRepository {
        ArticlesRepositoryImpl(
            context: container.viewContext
        )
    }
    
    private var careRepository: CareGuideRepository {
        CareGuideRepositoryImpl(context: container.viewContext)
    }
    
    private var quizRepository: QuizRepository {
        QuizRepositoryImpl(context: container.viewContext)
    }
    
    private var favoritesRepository: FavoritesRepository {
        FavoritesRepositoryImpl(
            articlesRepo: articlesRepository,
            careRepo: careRepository,
            quizRepo: quizRepository
        )
    }
    
    private var journalRepository: JournalRepository {
        JournalRepositoryImpl()
    }
    
    private var statsRepository: StatsRepository {
        StatsRepositoryImpl(
            journalRepo: journalRepository,
            articlesRepo: articlesRepository,
            guidesRepo: careRepository,
            quizzesRepo: quizRepository
        )
    }
    
    private var contentImporter: ContentImporting {
        ContentImporter(coreDataStack: coreDataStack)
    }
    
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    var body: some View {
        ZStack {
            switch appState.state {
            case .splash:
                SplashView()
                
            case .onboarding:
                OnboardingView(
                    onFinish: {
                        appState.finishOnboarding()
                    }
                )
                
            case .main:
                MainTabView(
                    articlesRepository: articlesRepository,
                    contentImporter: contentImporter,
                    careRepository: careRepository,
                    quizRepository: quizRepository,
                    favoritesRepository: favoritesRepository,
                    journalRepository: journalRepository,
                    statsRepository: statsRepository
                )
            }
        }
        .animation(.easeInOut, value: appState.state)
    }
}

