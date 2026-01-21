//
//  MainTabView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct MainTabView: View {
    
    let articlesRepository: ArticlesRepository
    let contentImporter: ContentImporting
    let careRepository: CareGuideRepository
    let quizRepository: QuizRepository
    let favoritesRepository: FavoritesRepository
    let journalRepository: JournalRepository
    
    @State private var selectedTab = 0
    @StateObject private var router = AppRouter()
    
    init(
        articlesRepository: ArticlesRepository,
        contentImporter: ContentImporting,
        careRepository: CareGuideRepository,
        quizRepository: QuizRepository,
        favoritesRepository: FavoritesRepository,
        journalRepository: JournalRepository
    ) {
        self.articlesRepository = articlesRepository
        self.contentImporter = contentImporter
        self.careRepository = careRepository
        self.quizRepository = quizRepository
        self.favoritesRepository = favoritesRepository
        self.journalRepository = journalRepository
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack(path: $router.homePath) {
                    HomeView(
                        articlesRepo: articlesRepository, 
                        careRepo: careRepository,
                        quizRepo: quizRepository,
                        importer: contentImporter,
                        favoritesRepo: favoritesRepository,
                        onSettingsTap: {
                            router.homePath.append(AppRouter.Route.settings)
                        },
                        onArticleTap: { id, type in
                            switch type {
                            case .article: router.homePath.append(AppRouter.Route.article(id: id))
                            case .care:    router.homePath.append(AppRouter.Route.care(id: id))
                            case .quiz:    router.homePath.append(AppRouter.Route.quiz(id: id))
                            }
                        },
                        onCategoryTap: { category in
                            router.homePath.append(AppRouter.Route.results(articleIds: category))
                        },
                        onQuickAccessTap: { quickAccess in
                            router.homePath.append(AppRouter.Route.results(articleIds: quickAccess))
                        }, onJournalTap: {
                            selectedTab = 1
                        })
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        destination(for: route)
                    }
                }
                .tag(0)
                NavigationStack(path: $router.journalPath) {
                    JournalView(
                        repository: journalRepository,
                        onBackTap: {
                            selectedTab = 0
                        }, onSettingsTap: {
                            router.journalPath.append(AppRouter.Route.settings)
                        },
                        onArticleTap: {articleId, contentType in
                            switch contentType {
                            case .article: push(.article(id: articleId))
                            case .care:    push(.care(id: articleId))
                            case .quiz:    push(.quiz(id: articleId))
                            }
                        })
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        destination(for: route)
                    }
                }
                .tag(1)
                NavigationStack(path: $router.searchPath) {
                    SearchView(
                        articlesRepo: articlesRepository,
                        careRepo: careRepository,
                        quizRepo: quizRepository,
                        onSettingsTap: {
                            router.searchPath.append(AppRouter.Route.settings)
                        },
                        onBackTap: {
                            selectedTab = 0
                        },
                        onSerachTap: { results in
                            router.searchPath.append(AppRouter.Route.results(articleIds: results))
                        }
                    )
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        destination(for: route)
                    }
                }
                .tag(2)
                NavigationStack(path: $router.favoritesPath) {
                    FavoritesView(
                        repository: favoritesRepository,
                        articlesRepo: articlesRepository,
                        careRepo: careRepository,
                        quizRepo: quizRepository,
                        onBackTap: {
                            selectedTab = 0
                        },
                        onSettingsTap: {
                            router.favoritesPath.append(AppRouter.Route.settings)
                        },
                        onItemTap: { item in
                            switch item.type {
                            case .article:
                                router.favoritesPath.append(.article(id: item.id))
                            case .care:
                                router.favoritesPath.append(.care(id: item.id))
                            case .quiz:
                                router.favoritesPath.append(.quiz(id: item.id))
                            }
                        }
                    )
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        destination(for: route)
                    }
                }
                .tag(3)
                NavigationStack(path: $router.statsPath) {
                    StatsView(
                        onSettingsTap: {
                            router.statsPath.append(AppRouter.Route.settings)
                        },
                        onBackTap: {
                            selectedTab = 0
                        },
                        onFilterTap: {
                            
                        })
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        destination(for: route)
                    }
                }
                .tag(4)
            }
            
            HStack {
                TabItem(icon: "home", label: "Home", isSelected: selectedTab == 0) { selectedTab = 0 }
                TabItem(icon: "journal", label: "Journal", isSelected: selectedTab == 1) { selectedTab = 1 }
                TabItem(icon: "search", label: "Search", isSelected: selectedTab == 2) { selectedTab = 2 }
                TabItem(icon: "favorite", label: "Favorite", isSelected: selectedTab == 3) { selectedTab = 3 }
                TabItem(icon: "stats", label: "Stats", isSelected: selectedTab == 4) { selectedTab = 4 }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(.ultraThinMaterial.opacity(0.5))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    private func destination(for route: AppRouter.Route) -> some View {
        switch route {

        case .settings:
            SettingsView(
                onBackTap: {
                    popCurrentPath()
                },
                onAboutTap: {
                    push(.about)
                }
            )

        case .results(let articleIds):
            ResultsSearchView(
                    articleIds: articleIds,
                    articlesRepo: articlesRepository,
                    careRepo: careRepository,
                    quizRepo: quizRepository,
                    onArticleTap: { id, type in
                        switch type {
                        case "Article":
                            push(.article(id: id))
                        case "Guide":
                            push(.care(id: id))
                        case "Quiz":
                            push(.quiz(id: id))
                        default:
                            push(.article(id: id))
                        }
                    },
                    onBackTap: {
                        popCurrentPath()
                    }
                )

        case .article(let id):
            ArticleView(
                articleId: id,
                repository: articlesRepository,
                importer: contentImporter,
                favorites: favoritesRepository,
                journalRepo: journalRepository,
                onBackTap: {
                    popCurrentPath()
                },
                onReady:  {
                    resetCurrentPathAndGoHome()
                }
            )

        case .about:
            AboutView(
                onBackTap: {
                    popCurrentPath()
                }
            )

        case .care(let id):
            CareView(
                careId: id,
                repository: careRepository,
                favorites: favoritesRepository,
                journalRepo: journalRepository,
                onBackTap: {
                    popCurrentPath()
                },
                onReady:  {
                    resetCurrentPathAndGoHome()
                }
            )

        case .quiz(let id):
            QuizView(
                quizId: id,
                repository: quizRepository,
                favorites: favoritesRepository,
                journalRepo: journalRepository,
                onBackTap: {
                    popCurrentPath()
                },
                onReady: {
                    resetCurrentPathAndGoHome()
                }
            )
        }
    }

    private func popCurrentPath() {
        switch selectedTab {
        case 0: router.homePath.removeLast()
        case 1: router.journalPath.removeLast()
        case 2: router.searchPath.removeLast()
        case 3: router.favoritesPath.removeLast()
        case 4: router.statsPath.removeLast()
        default: break
        }
    }

    private func push(_ route: AppRouter.Route) {
        switch selectedTab {
        case 0: router.homePath.append(route)
        case 1: router.journalPath.append(route)
        case 2: router.searchPath.append(route)
        case 3: router.favoritesPath.append(route)
        case 4: router.statsPath.append(route)
        default: break
        }
    }

    private func resetCurrentPathAndGoHome() {
        switch selectedTab {
        case 0: router.homePath.removeLast(router.homePath.count)
        case 1: router.journalPath.removeLast(router.journalPath.count)
        case 2: router.searchPath.removeLast(router.searchPath.count)
        case 3: router.favoritesPath.removeLast(router.favoritesPath.count)
        case 4: router.statsPath.removeLast(router.statsPath.count)
        default: break
        }
        
        selectedTab = 0
    }
}

struct TabItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(isSelected ? icon : "\(icon)Gray")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 40)
                Text(label)
                    .font(.customSen(.regular, size: 12))
            }
            .foregroundStyle(isSelected ? Color.mainGreen : Color.tabBarText)
            .frame(maxWidth: .infinity)
        }
    }
}

