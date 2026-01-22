//
//  QuizResultAlertView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 22.01.2026.
//

import SwiftUI

struct QuizResultAlertView: View {
    let score: Int
    let total: Int
    let onSeeArticles: () -> Void
    let onRepeat: () -> Void
    let onOk: () -> Void
    
    private let alertBackground = Color.startBg
    
    var body: some View {
        ZStack {
            Color.endBg.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                }
            
            VStack(spacing: 20) {
                Text("Quiz completed!")
                    .font(.customSen(.bold, size: 20))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Text("Score: \(score)/\(total)")
                    .font(.customSen(.bold, size: 18))
                    .foregroundColor(.white)
                
                Text("Your progress has been saved to your journal.")
                    .font(.customSen(.regular, size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    MainButtonTransparentView(title: "See articles on this topic", onTap: onSeeArticles)
                    MainButtonTransparentView(title: "Repeat", onTap: onRepeat)
                    MainButtonsFillView(title: "OK", onReady: onOk)
                }
                .padding(.horizontal, 10)
            }
            .padding(30)
            .background(alertBackground)
            .cornerRadius(24)
            .padding(.horizontal, 40)
        }
    }
}
