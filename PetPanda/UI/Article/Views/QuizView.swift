//
//  QuizView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct QuizView: View {
    @State private var currentStep = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 20) {
                
                HeaderView(tilte: "How to Help Protect Pandas?", leftBarButton: "chevron.left", rightBarButton: "star.fill")
                
                Text("Question 1 of 10")
                    .font(.customSen(.semiBold, size: 18))
                    .foregroundStyle(.text)
                HStack(spacing: 8) {
                    ForEach(0..<10, id: \.self) { index in
                        Capsule()
                            .fill(currentStep == index ? Color.green : Color.text.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .frame(height: 10)
                            .animation(.spring(), value: currentStep)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Text("What is the biggest threat to wild pandas?")
                            .font(.customSen(.semiBold, size: 25))
                            .foregroundStyle(.text)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 280)
                            .background(.ultraThinMaterial.opacity(0.1))
                            .cornerRadius(25)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            QuestionButtonView(question: "A) Lack of predators")
                            QuestionButtonView(question: "B) Habitat loss and bamboo decline")
                            QuestionButtonView(question: "C) Too much tourism")
                            QuestionButtonView(question: "D) Excessive meat consumption")
                            
                        }
                        .padding(.horizontal)
                        
                        HStack(alignment: .top) {
                            Image("clue")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 15)
                            
                            Text("Wild pandas rely on bamboo for almost all their food. When forests are cut down or fragmented, bamboo shrinks and pandas lose both food and safe habitat — making this the biggest threat to their survival.")
                                .font(.customSen(.regular, size: 13))
                                .foregroundStyle(.text)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Material.ultraThinMaterial.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.mainGreen.opacity(0))
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.text.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        HStack {
                            MainButtonTransparentView(title: "Back")
                            MainButtonTransparentView(title: "Next")
                            MainButtonsFillView(title: "Complited")
                        }
                        .padding(.horizontal)
                        Spacer(minLength: 100)
                    }
                }
            }
        }
    }
}

#Preview {
    QuizView()
}
