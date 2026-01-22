//
//  AboutView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    let onBackTap: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 20) {
                
                HeaderView(
                    tilte: "About App",
                    leftBarButton: "chevron.left",
                    rightBarButton: nil,
                    onRightTap: {
                    },
                    onLeftTap: {
                        onBackTap()
                    })
                ScrollView(showsIndicators: false) {
                    Image("mainLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                    
                    Text("PetPanda is an offline educational companion app about pandas, offering daily facts, care guides, quizzes, favorites, reading history, and PDF export.")
                        .font(.customSen(.regular, size: 15, offset: settingsVM.fontSizeOffset))
                        .foregroundStyle(.text)
                        .padding()
                    
                    
                    VStack(spacing: 16) {
                        NavigationLink(destination: AboutDetailView(title: "Privacy Policy", content: LegalTexts.privacyPolicy)) {
                            menuRow(title: "Privacy Policy")
                        }
                        
                        divider
                        
                        NavigationLink(destination: AboutDetailView(title: "Terms of Use", content: LegalTexts.termsOfUse)) {
                            menuRow(title: "Terms of Use")
                        }
                        
                        divider
                        
                        NavigationLink(destination: AboutDetailView(title: "Sources", content: LegalTexts.sources)) {
                            menuRow(title: "Sources")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Material.ultraThinMaterial.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color.mainGreen.opacity(0))
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.text.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.top, 30)
                    Spacer()
                    Text("App Version 1.0")
                        .font(.customSen(.regular, size: 13, offset: settingsVM.fontSizeOffset))
                        .foregroundStyle(.text)
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func menuRow(title: String) -> some View {
        HStack {
            Text(title)
                .font(.customSen(.regular, size: 14, offset: settingsVM.fontSizeOffset))
                .foregroundStyle(.text)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.mainGreen)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .contentShape(Rectangle())
    }
    
    private var divider: some View {
        Divider()
            .padding(.horizontal, 20)
            .frame(height: 1)
            .background(Color.text.opacity(0.1))
    }
}

#Preview {
    AboutView(onBackTap: {})
}
