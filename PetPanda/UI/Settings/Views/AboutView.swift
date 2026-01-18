//
//  AboutView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 20) {
                
                HeaderView(tilte: "About App", leftBarButton: "chevron.left", rightBarButton: nil)
                
                Image("mainLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                
                Text("PetPanda is an offline educational companion app about pandas, offering daily facts, care guides, quizzes, favorites, reading history, and PDF export.")
                    .font(.customSen(.regular, size: 15))
                    .foregroundStyle(.text)
                    .padding()
                
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Privacy Policy")
                            .font(.customSen(.regular, size: 13))
                            .foregroundStyle(.text)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.title3.bold())
                            .foregroundStyle(.mainGreen)
                            .padding(.trailing, 4)
                    }
                    .padding(.horizontal)
                    Divider()
                        .padding()
                        .frame(height: 1)
                        .background(.text.opacity(0.5))
                    
                    HStack {
                        Text("Terms of Use")
                            .font(.customSen(.regular, size: 13))
                            .foregroundStyle(.text)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.title3.bold())
                            .foregroundStyle(.mainGreen)
                            .padding(.trailing, 4)
                    }
                    .padding(.horizontal)
                    Divider()
                        .padding()
                        .frame(height: 1)
                        .background(.text.opacity(0.5))
                    
                    HStack {
                        Text("Sources")
                            .font(.customSen(.regular, size: 13))
                            .foregroundStyle(.text)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.title3.bold())
                            .foregroundStyle(.mainGreen)
                            .padding(.trailing, 4)
                    }
                    .padding(.horizontal)
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
                    .font(.customSen(.regular, size: 13))
                    .foregroundStyle(.text)
                
                Spacer(minLength: 100)
            }
        }
    }
}

#Preview {
    AboutView()
}
