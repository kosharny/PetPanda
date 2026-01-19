//
//  FilterMenuView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct FilterMenuView: View {
    let isSearchView: Bool
    @State private var unreadOnly = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if !isSearchView {
                FilterGroup(title: "By title:") {
                    HStack {
                        CotegoryButton(title: "A - Z", onTap: {})
                        CotegoryButton(title: "Z - A", onTap: {})
                    }
                }
            }
            if isSearchView {
                FilterGroup(title: "Type:") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        CotegoryButton(title: "Articles", onTap: {})
                        CotegoryButton(title: "Guides", onTap: {})
                        CotegoryButton(title: "Quizzes", onTap: {})
                    }
                }
            }
            FilterGroup(title: "Categories:") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                    CotegoryButton(title: "Habitat", onTap: {})
                    CotegoryButton(title: "Diet", onTap: {})
                    CotegoryButton(title: "Behavior", onTap: {})
                    CotegoryButton(title: "Fun Facts", onTap: {})
                    CotegoryButton(title: "Health", onTap: {})
                }
            }
            FilterGroup(title: "Reading Time:") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                    CotegoryButton(title: "< 5 min", onTap: {})
                    CotegoryButton(title: "5 - 10 min", onTap: {})
                    CotegoryButton(title: "10+ min", onTap: {})
                }
            }
            if !isSearchView {
                FilterGroup(title: "By progress:") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        CotegoryButton(title: "< 20%", onTap: {})
                        CotegoryButton(title: "20 - 70%", onTap: {})
                        CotegoryButton(title: "70 - 100%", onTap: {})
                    }
                }
            }
            HStack {
                Toggle("Unread only", isOn: $unreadOnly)
                    .toggleStyle(GlassToggleStyle())
                    .padding(.horizontal, 20)
            }
            HStack {
                MainButtonTransparentView(title: "Reset", onTap: {})
                MainButtonsFillView(title: "Apply", onReady: {})
            }
        }
        .padding()
        .frame(width: 320)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Material.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.endBg.opacity(0.7))
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.text.opacity(0.3), lineWidth: 1)
        )
    }
}


struct FilterGroup<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.customSen(.semiBold, size: 16))
                .foregroundStyle(.text)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GlassToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.customSen(.semiBold, size: 16))
                .foregroundColor(.text)
            
            Spacer()
            
            ZStack {
                Capsule()
                    .fill(Color.text.opacity(0.05))
                    .frame(width: 84, height: 34)
                    .overlay(
                        Capsule()
                            .stroke(Color.text.opacity(0.1), lineWidth: 1.5)
                    )
                
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(Color.mainGreen.opacity(configuration.isOn ? 1 : 0.1))
                    )
                    .frame(width: 54, height: 28)
                    .offset(x: configuration.isOn ? 12 : -12)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
