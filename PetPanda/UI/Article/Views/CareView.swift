//
//  CareView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct CareView: View {
    @StateObject private var vm: CareViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    let onBackTap: () -> Void
    let onReady: () -> Void
    
    init(
        careId: String,
        repository: CareGuideRepository,
        favorites: FavoritesRepository,
        journalRepo: JournalRepository,
        onBackTap: @escaping () -> Void,
        onReady: @escaping () -> Void
    ) {
        _vm = StateObject(
            wrappedValue: CareViewModel(
                careId: careId,
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
                    tilte: "Guide",
                    leftBarButton: "chevron.left",
                    rightBarButton: vm.isFavorite ? "star.fill" : "star",
                    onRightTap: {
                        vm.toggleFavorite()
                    },
                    onLeftTap: {
                        if vm.isGuideStarted {
                            vm.isGuideStarted = false
                        } else {
                            onBackTap()
                        }
                    })
                
                if vm.isLoading {
                    ProgressView().tint(.green)
                } else if let guide = vm.guide {
                    if !vm.isGuideStarted {
                        renderArticleMode(guide: guide)
                    } else {
                        renderStepMode()
                    }
                }
            }
            .navigationBarHidden(true)
            .task { await vm.load() }
        }
    }
    
    @ViewBuilder
        private func renderArticleMode(guide: CareGuide) -> some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Обложка
                    ZStack(alignment: .bottomLeading) {
                        // Используем изображение первого шага как обложку
                        Image(guide.steps.first?.image ?? "")
                            .resizable()
                            .scaledToFit()
                        
                        LinearGradient(
                            colors: [Color.black.opacity(0.65), Color.black.opacity(0.2), Color.clear],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        
                        Text(guide.title)
                            .font(.customSen(.semiBold, size: 15, offset: settingsVM.fontSizeOffset))
                            .foregroundStyle(.text)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        if !vm.firstSentenceOfContent.isEmpty {
                            Text(vm.firstSentenceOfContent)
                                .font(.customSen(.regular, size: 13, offset: settingsVM.fontSizeOffset))
                                .foregroundStyle(.text)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack(spacing: 16) {
                            ForEach(guide.tags, id: \.self) { tag in
                                TagView(title: tag)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial.opacity(0.1))
                    .cornerRadius(25)
                    .padding(.horizontal)
                    
                    HStack {
                        CotegoryButton(title: guide.category, isSelected: false, onTap: {})
                        CotegoryButton(title: "\(guide.duration) min", isSelected: false, onTap: {})
                        CotegoryButton(title: guide.difficulty, isSelected: false, onTap: {})
                    }
                    .padding(.horizontal)
                    
                    ForEach(guide.steps) { step in
                        ArticleTextView(
                            title: step.title,
                            description: step.content.joined(separator: "\n")
                        )
                    }
                    
                    HStack {
                        MainButtonTransparentView(title: "Share", onTap: {})
                        MainButtonsFillView(title: "Start Guide", onReady: {
                            withAnimation {
                                vm.startGuide()
                            }
                        })
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
        }
    @ViewBuilder
    private func renderStepMode() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text(vm.progressTitle)
                    .font(.customSen(.semiBold, size: 18, offset: settingsVM.fontSizeOffset))
                    .foregroundStyle(.text)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 8) {
                    ForEach(0..<vm.totalSteps, id: \.self) { index in
                        Capsule()
                            .fill(vm.currentStepIndex == index ? Color.green : Color.text.opacity(0.3))
                            .frame(height: 10)
                    }
                }
                .padding(.horizontal)
                
                if let step = vm.currentStep {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                if let img = step.image { Image(img).resizable().scaledToFit() }
                                Text(step.title)
                                    .font(.customSen(.semiBold, size: 14, offset: settingsVM.fontSizeOffset))
                                    .foregroundStyle(.text)
                                    .padding(.top)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text(step.content.joined(separator: "\n"))
                                    .font(.customSen(.regular, size: 13, offset: settingsVM.fontSizeOffset))
                                    .foregroundStyle(.text)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.ultraThinMaterial.opacity(0.1))
                            .cornerRadius(25)
                            .padding(.horizontal)
                            
                            NotesFieldView(notesText: $vm.notesText)
                            
                            HStack {
                                if vm.currentStepIndex > 0 {
                                    MainButtonTransparentView(title: "Back") {
                                        withAnimation {
                                            vm.prevStep()
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                MainButtonsFillView(title: vm.currentStepIndex == vm.totalSteps - 1 ? "Complete" : "Next") {
                                    if vm.currentStepIndex == vm.totalSteps - 1 {
                                        vm.completeGuide()
                                        onReady()
                                    } else {
                                        vm.nextStep()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal)
                        }
                }
            }
            
            Spacer(minLength: 100)
        }
    }
}


struct NotesFieldView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    @Binding var notesText: String
    let characterLimit = 1000
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image("notes")
                    .font(.system(size: 20, weight: .semibold))
                
                Text("Notes")
                    .font(.customSen(.semiBold, size: 14, offset: settingsVM.fontSizeOffset))
                    .foregroundStyle(.text)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            TextEditor(text: $notesText)
                .scrollContentBackground(.hidden)
                .font(.customSen(.regular, size: 12, offset: settingsVM.fontSizeOffset))
                .foregroundStyle(.text)
                .onChange(of: notesText) { _, newValue in
                    if newValue.count > characterLimit {
                        notesText = String(newValue.prefix(characterLimit))
                    }
                }
            
            HStack {
                Spacer()
                Text("\(notesText.count)/\(characterLimit)")
                    .font(.customSen(.regular, size: 13, offset: settingsVM.fontSizeOffset))
                    .foregroundStyle(.text)
            }
            .padding(.bottom, 16)
            .padding(.trailing, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(.ultraThinMaterial.opacity(0.1))
        .cornerRadius(25)
        .padding(.horizontal)
    }
}

