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
                        CotegoryButton(title: "A - Z")
                        CotegoryButton(title: "Z - A")
                    }
                }
            }
            if isSearchView {
                FilterGroup(title: "Type:") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        CotegoryButton(title: "Articles")
                        CotegoryButton(title: "Guides")
                        CotegoryButton(title: "Quizzes")
                    }
                }
            }
            FilterGroup(title: "Categories:") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                    CotegoryButton(title: "Habitat")
                    CotegoryButton(title: "Diet")
                    CotegoryButton(title: "Behavior")
                    CotegoryButton(title: "Fun Facts")
                    CotegoryButton(title: "Health")
                }
            }
            FilterGroup(title: "Reading Time:") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                    CotegoryButton(title: "< 5 min")
                    CotegoryButton(title: "5 - 10 min")
                    CotegoryButton(title: "10+ min")
                }
            }
            if !isSearchView {
                FilterGroup(title: "By progress:") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                        CotegoryButton(title: "< 20%")
                        CotegoryButton(title: "20 - 70%")
                        CotegoryButton(title: "70 - 100%")
                    }
                }
            }
            HStack {
                Toggle("Unread only", isOn: $unreadOnly)
                    .toggleStyle(GlassToggleStyle())
                    .padding(.horizontal, 20)
            }
            HStack {
                MainButtonTransparentView(title: "Reset")
                MainButtonsFillView(title: "Apply")
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
