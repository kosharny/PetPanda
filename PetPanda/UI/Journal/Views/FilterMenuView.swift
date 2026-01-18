//
//  FilterMenuView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct FilterMenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            FilterGroup(title: "By title:") {
                HStack {
                    CotegoryButton(title: "A - Z")
                    CotegoryButton(title: "Z - A")
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
            FilterGroup(title: "By progress:") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                    CotegoryButton(title: "< 20%")
                    CotegoryButton(title: "20 - 70%")
                    CotegoryButton(title: "70 - 100%")
                }
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
