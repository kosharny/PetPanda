//
//  SearchBarView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct SearchBarView: View {
    let isSearchView: Bool
    @Binding var searchText: String
    @Binding var showFilters: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.mainGreen)
                .padding(.leading, 16)
            
            TextField("", text: $searchText, prompt:
                Text("Search by title, tags, brief description")
                    .font(.customSen(.regular, size: 12))
                    .foregroundStyle(.text.opacity(0.5))
            )
            .font(.customSen(.regular, size: 12))
            .foregroundStyle(.text)
            .padding(.leading, 12)
            .padding(.vertical, 14)
            
            Rectangle()
                .fill(Color.text.opacity(0.1))
                .frame(width: 1)
                .padding(.vertical, 8)
            
            Button(action: {
                showFilters.toggle()
            }) {
                Image("filterButton")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 20)
                    .padding(.horizontal, 16)
            }
            .popover(isPresented: $showFilters) {
                FilterMenuView(isSearchView: isSearchView)
                    .presentationCompactAdaptation(.popover)
            }
        }
        .background(
            Capsule()
                .fill(Material.ultraThinMaterial.opacity(0.2))
                .overlay(
                    Capsule()
                        .fill(Color.mainGreen.opacity(0))
                )
        )
        .overlay(
            Capsule()
                .stroke(Color.text.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}


