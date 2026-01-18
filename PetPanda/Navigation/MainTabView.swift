//
//  MainTabView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                JournalView()
                    .tag(1)
                Text("Search")
                    .tag(2)
                FavoritesView()
                    .tag(3)
                Text("Stats")
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

#Preview {
    MainTabView()
}
