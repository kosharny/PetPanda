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
    
    @State private var selectedTab = 0
    @StateObject private var router = AppRouter()
    
    init(
        articlesRepository: ArticlesRepository,
        contentImporter: ContentImporting,
        careRepository: CareGuideRepository,
        quizRepository: QuizRepository
    ) {
        self.articlesRepository = articlesRepository
        self.contentImporter = contentImporter
        self.careRepository = careRepository
        self.quizRepository = quizRepository
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
                        })
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        destination(for: route)
                    }
                }
                .tag(0)
                NavigationStack(path: $router.journalPath) {
                    JournalView(
                        onSettingsTap: {
                            router.journalPath.append(AppRouter.Route.settings)
                        },
                        onBackTap: {
                            selectedTab = 0
                        },
                        onFilterTap: {
                            
                        },
                        onArticleTap: { articleId in
                            router.journalPath.append(AppRouter.Route.article(id: articleId))
                        })
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        destination(for: route)
                    }
                }
                .tag(1)
                NavigationStack(path: $router.searchPath) {
                    SearchView(
                        onSettingsTap: {
                            router.searchPath.append(AppRouter.Route.settings)
                        },
                        onBackTap: {
                            selectedTab = 0
                        },
                        onSerachTap: { results in
                            router.searchPath.append(AppRouter.Route.results(articleIds: results))
                        })
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        destination(for: route)
                    }
                }
                .tag(2)
                NavigationStack(path: $router.favoritesPath) {
                    FavoritesView(
                        onSettingsTap: {
                            router.favoritesPath.append(AppRouter.Route.settings)
                        },
                        onBackTap: {
                            selectedTab = 0
                        },
                        onFilterTap: {
                            
                        },
                        onArticleTap: { articleId in
                            router.favoritesPath.append(AppRouter.Route.article(id: articleId))
                        })
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
                onArticleTap: { articleId in
                    push(.article(id: articleId))
                },
                onBackTap: {
                    popCurrentPath()
                }, onFilterTap: {}
            )

        case .article(let id):
            ArticleView(
                articleId: id,
                repository: articlesRepository,
                importer: contentImporter,
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

