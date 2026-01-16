//
//  OnboardingView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI

import SwiftUI

struct OnboardingStep: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let image: String
    let buttonText: String
}

let onboardingSteps = [
    OnboardingStep(
        title: "Welcome to PetPanda",
        subtitle: "Learn about the population and conservation",
        image: "onb_1",
        buttonText: "Continue"
    ),
    OnboardingStep(
        title: "Welcome to PetPanda",
        subtitle: "Instructions for care and maintenance",
        image: "onb_2",
        buttonText: "Continue"
    ),
    OnboardingStep(
        title: "Welcome to PetPanda",
        subtitle: "The interactive: quizzes and daily facts",
        image: "onb_3",
        buttonText: "Start"
    )
]

struct OnboardingView: View {
    @State private var currentStep = 0
    let onFinish: () -> Void
      
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                ZStack {
                    Text(onboardingSteps[currentStep].title)
                        .font(.customSen(.bold, size: 19))
                        .foregroundStyle(.text)
                    HStack {
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 15)
                            .foregroundColor(.white.opacity(0.6))
                            .padding()
                            .background(
                                Circle()
                                    .fill(Material.ultraThinMaterial)
                                    .opacity(0.2)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.textButton.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                TabView(selection: $currentStep) {
                    ForEach(0..<onboardingSteps.count, id: \.self) { index in
                        VStack(spacing: 40) {
                            Text(onboardingSteps[index].subtitle)
                                .font(.customSen(.medium, size: 18))
                                .foregroundStyle(.text)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .frame(height: 100)
                            ZStack {
                                Circle()
                                    .fill(.green)
                                    .frame(maxWidth: 250)
                                    .blur(radius: 100)
                                    .opacity(0.8)
                                
                                Image(onboardingSteps[index].image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 250)
                                    .cornerRadius(20)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 30) {
                    Button(action: {
                        if currentStep < onboardingSteps.count - 1 {
                            withAnimation { currentStep += 1 }
                        } else {
                            onFinish()
                        }
                    }) {
                        Text(onboardingSteps[currentStep].buttonText)
                            .font(.customSen(.medium, size: 20))
                            .foregroundStyle(.textButton)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Material.ultraThinMaterial)
                                    .opacity(0.2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.textButton.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 24)
                    
                    
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingSteps.count, id: \.self) { index in
                            Capsule()
                                .fill(currentStep == index ? Color.green : Color.text.opacity(0.3))
                                .frame(width: 16, height: 16)
                                .animation(.spring(), value: currentStep)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
