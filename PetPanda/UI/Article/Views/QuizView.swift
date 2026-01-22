//
//  QuizView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct QuizView: View {
    @StateObject private var vm: QuizViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    let onBackTap: () -> Void
    let onReady: () -> Void
    
    init(
        quizId: String,
        repository: QuizRepository,
        favorites: FavoritesRepository,
        journalRepo: JournalRepository,
        onBackTap: @escaping () -> Void,
        onReady: @escaping () -> Void
    ) {
        _vm = StateObject(
            wrappedValue: QuizViewModel(
                quizId: quizId,
                repository: repository,
                favorites: favorites,
                journalRepo: journalRepo
            )
        )
        self.onBackTap = onBackTap
        self.onReady = onReady
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 20) {
                
                HeaderView(
                    tilte: "Quiz",
                    leftBarButton: "chevron.left",
                    rightBarButton: vm.isFavorite ? "star.fill" : "star",
                    onRightTap: {
                        vm.toggleFavorite()
                    },
                    onLeftTap: {
                        onBackTap()
                    })
                
                if vm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let quiz = vm.quiz {
                    
                    if !vm.isQuizStarted {
                        // --- 1. OVERVIEW MODE ---
                        renderOverviewMode(quiz: quiz)
                    } else {
                        // --- 2. QUESTION MODE ---
                        renderQuestionMode()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            Task { await vm.load() }
        }
    }
    
    @ViewBuilder
    private func renderOverviewMode(quiz: Quiz) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ZStack(alignment: .bottomLeading) {
                    Image(quiz.coverImage)
                        .resizable()
                        .scaledToFit()
                    
                    LinearGradient(
                        colors: [Color.black.opacity(0.65), Color.black.opacity(0.2), Color.clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    
                    Text(quiz.title)
                        .font(.customSen(.semiBold, size: 15, offset: settingsVM.fontSizeOffset))
                        .foregroundStyle(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    if !vm.firstSentenceOfDescription.isEmpty {
                        Text(vm.firstSentenceOfDescription)
                            .font(.customSen(.regular, size: 13, offset: settingsVM.fontSizeOffset))
                            .foregroundStyle(.text)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack(spacing: 16) {
                        ForEach(quiz.tags, id: \.self) { tag in
                            TagView(title: tag)
                        }
                        Spacer()
                    }

                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial.opacity(0.1))
                .cornerRadius(25)
                .padding(.horizontal)
                
                HStack {
                    CotegoryButton(title: quiz.categoryId, isSelected: false, onTap: {})
                    CotegoryButton(title: "\(quiz.questions.count) Questions", isSelected: false, onTap: {})
                    CotegoryButton(title: "\(quiz.duration) min", isSelected: false, onTap: {})
                }
                .padding(.horizontal)
                
                let allQuestionsText = quiz.questions.enumerated().map { index, question in
                    let answersList = question.answers
                        .map { "• \($0)" }
                        .joined(separator: "\n")
                    
                    return "Q\(index + 1): \(question.text)\n\(answersList)"
                }.joined(separator: "\n\n") 
                
                ArticleTextView(
                    title: "Q/A",
                    description: allQuestionsText
                )
                
                Spacer(minLength: 20)
                
                HStack {
                    MainButtonTransparentView(title: "Share", onTap: {})
                    MainButtonsFillView(title: "Start Quiz", onReady: {
                        withAnimation {
                            vm.startQuiz()
                        }
                    })
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
        }
    }
    
    @ViewBuilder
    private func renderQuestionMode() -> some View {
        VStack(spacing: 20) {
            
            Text(vm.progressTitle)
                .font(.customSen(.semiBold, size: 18, offset: settingsVM.fontSizeOffset))
                .foregroundStyle(.text)
            
            HStack(spacing: 8) {
                ForEach(0..<vm.totalSteps, id: \.self) { index in
                    Capsule()
                        .fill(vm.currentStepIndex == index ? Color.green : Color.text.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .frame(height: 10)
                        .animation(.spring(), value: vm.currentStepIndex)
                }
            }
            .padding(.horizontal)
            
            if let question = vm.currentQuestion {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        Text(question.text)
                            .font(.customSen(.semiBold, size: 20, offset: settingsVM.fontSizeOffset))
                            .foregroundStyle(.text)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(.ultraThinMaterial.opacity(0.1))
                            .cornerRadius(25)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(question.answers.indices, id: \.self) { index in
                                QuizOptionButton(
                                    text: question.answers[index],
                                    state: getOptionState(for: index, correctIndex: question.correctIndex)
                                ) {
                                    vm.selectAnswer(at: index)
                                }
                                .disabled(vm.isAnswered)
                            }
                        }
                        .padding(.horizontal)
                        
                        if vm.isAnswered {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.title3)
                                
                                Text(question.explanation)
                                    .font(.customSen(.regular, size: 13, offset: settingsVM.fontSizeOffset))
                                    .foregroundStyle(.text)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Material.ultraThinMaterial.opacity(0.2))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.text.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                        
                        if vm.isAnswered {
                            HStack {
                                Spacer()
                                MainButtonsFillView(
                                    title: vm.currentStepIndex == vm.totalSteps - 1 ? "Finish" : "Next",
                                    onReady: {
                                        if vm.currentStepIndex == vm.totalSteps - 1 {
                                            vm.completeQuiz()
                                            onReady() 
                                        } else {
                                            withAnimation {
                                                vm.nextStep()
                                            }
                                        }
                                    }
                                )
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
    }
    
    private func getOptionState(for index: Int, correctIndex: Int) -> QuizOptionState {
        guard vm.isAnswered else { return .idle }
        
        if index == correctIndex {
            return .correct
        } else if index == vm.selectedAnswerIndex {
            return .wrong
        } else {
            return .idle
        }
    }
}


enum QuizOptionState {
    case idle
    case correct
    case wrong
}

struct QuizOptionButton: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    let text: String
    let state: QuizOptionState
    let action: () -> Void
    
    var backgroundColor: Color {
        switch state {
        case .idle: return Color.white.opacity(0.05)
        case .correct: return Color.green.opacity(0.8)
        case .wrong: return Color.red.opacity(0.8)
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.customSen(.medium, size: 14, offset: settingsVM.fontSizeOffset))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
                
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                } else if state == .wrong {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

