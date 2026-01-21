//
//  SearchView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var vm: SearchViewModel
    @State private var showFilters = false
    @FocusState private var isSearchFocused: Bool
    
    let onSettingsTap: () -> Void
    let onBackTap: () -> Void
    let onSerachTap: ([String]) -> Void
    
    init(
        articlesRepo: ArticlesRepository,
        careRepo: CareGuideRepository,
        quizRepo: QuizRepository,
        onSettingsTap: @escaping () -> Void,
        onBackTap: @escaping () -> Void,
        onSerachTap: @escaping ([String]) -> Void
    ) {
        _vm = StateObject(wrappedValue: SearchViewModel(
            articlesRepo: articlesRepo,
            careRepo: careRepo,
            quizRepo: quizRepo
        ))
        self.onSettingsTap = onSettingsTap
        self.onBackTap = onBackTap
        self.onSerachTap = onSerachTap
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
                .onTapGesture {
                    if isSearchFocused {
                        isSearchFocused = false
                    }
                }
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(
                    tilte: "Search",
                    leftBarButton: "chevron.left",
                    rightBarButton: "gearshape.fill",
                    onRightTap: {
                        onSettingsTap()
                    },
                    onLeftTap: {
                        vm.searchText = ""
                        vm.resetFilters()
                        onBackTap()
                    })
                
                
                ScrollView(showsIndicators: false) {
                    SearchBarView(searchText: $vm.searchText, showFilters: $showFilters)
                        .focused($isSearchFocused)
                        .searchKeyboardToolbar(
                            isFocused: $isSearchFocused,
                            onSearch: {
                                let results = vm.performSearch()
                                onSerachTap(results)
                            }
                        )
                    Spacer(minLength: 150)
                    if vm.recentSearches.isEmpty && vm.searchText.isEmpty {
                        Spacer(minLength: 50)
                        EmptyView(title: "Uh-oh, no pandas know this one :( Try another search.", imageName: "emptyImage", isButtonNeeded: false)
                    } else {
                        VStack {
                            
                            Text("Recent searches")
                                .font(.customSen(.semiBold, size: 16))
                                .foregroundStyle(.mainGreen)
                                .padding(.bottom)
                            
                            Spacer()
                            
                            Button("Clear") {
                                vm.clearHistory()
                            }
                            .font(.customSen(.regular, size: 12))
                            .foregroundStyle(.text.opacity(0.6))
                            
                            ForEach(vm.recentSearches, id: \.self) { historyItem in
                                RecentSearchButtonView(title: historyItem)
                                    .onTapGesture {
                                        vm.searchText = historyItem
                                        let results = vm.performSearch()
                                        onSerachTap(results)
                                    }
                            }
                        }
                    }
                    Spacer(minLength: 100)
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterMenuView(vm: vm, onApply: {
                    showFilters = false
                    let results = vm.performSearch()
                    onSerachTap(results)
                })
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
            .contentShape(Rectangle())
        }
    }
}

struct RecentSearchButtonView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.customSen(.regular, size: 14))
            .foregroundStyle(.text)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial.opacity(0.1))
            .cornerRadius(25)
            .padding(.horizontal)
            .contentShape(Rectangle())
    }
}

