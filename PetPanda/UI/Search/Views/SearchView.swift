//
//  SearchView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct SearchView: View {
    
    let isLoading = true
    @State private var searchText = ""
    @State private var showFilters = false
    let onSettingsTap: () -> Void
    let onBackTap: () -> Void
    let onSerachTap: ([String]) -> Void
    
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            BackgroundView()
                .onTapGesture {
                    if isSearchFocused {
                        isSearchFocused = false
                        onSerachTap([""])
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
                        onBackTap()
                    })
                
                
                    ScrollView(showsIndicators: false) {
                        SearchBarView(isSearchView: true, searchText: $searchText, showFilters: $showFilters)
                            .focused($isSearchFocused)
                            .searchKeyboardToolbar(
                                isFocused: $isSearchFocused,
                                onSearch: {
                                    let results = [" "]//vm.search(text: searchText)
                                    onSerachTap(results)
                                }
                            )
                        Spacer(minLength: 150)
                        if !isLoading {
                            EmptyView(title: "Uh-oh, no pandas know this one :( Try another search.", imageName: "emptyImage", isButtonNeeded: false)
                        } else {
                            VStack {
                                
                                Text("Recent searches")
                                    .font(.customSen(.semiBold, size: 16))
                                    .foregroundStyle(.mainGreen)
                                    .padding(.bottom)
                                
                                
                                RecentSearchButtonView(title: "Bamboo nutrition facts")
                                RecentSearchButtonView(title: "Giant panda population 2025")
                                RecentSearchButtonView(title: "Panda habitat conservation tips")
                                RecentSearchButtonView(title: "Baby panda weight at birth")
                                RecentSearchButtonView(title: "Bamboo forest ecosystem species")
                            }
                        }
                        Spacer(minLength: 100)
                }
            }
        }
        .contentShape(Rectangle())
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
    }
}

#Preview {
    SearchView(onSettingsTap: { }, onBackTap: { }, onSerachTap: { _ in })
}
