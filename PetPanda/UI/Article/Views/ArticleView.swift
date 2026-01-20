//
//  ArticleView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct ArticleView: View {
    
    @StateObject private var vm: ArticleViewModel
    
    let onBackTap: () -> Void
    let onReady: () -> Void
    
    init(
        articleId: String,
        repository: ArticlesRepository,
        importer: ContentImporting,
        favorites: FavoritesRepository,
        onBackTap: @escaping () -> Void,
        onReady: @escaping () -> Void
    ) {
        _vm = StateObject(
            wrappedValue: ArticleViewModel(
                articleId: articleId,
                repository: repository,
                importer: importer,
                favorites: favorites
            )
        )
        self.onBackTap = onBackTap
        self.onReady = onReady
    }
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(
                    tilte: "Article",
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
                } else if let article = vm.article {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            ZStack(alignment: .bottomLeading) {
                                Image(article.coverImage)
                                    .resizable()
                                    .scaledToFit()
                                
                                LinearGradient(
                                    colors: [
                                        Color.black.opacity(0.65),
                                        Color.black.opacity(0.2),
                                        Color.clear
                                    ],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                                
                                Text(article.title)
                                    .font(.customSen(.semiBold, size: 15))
                                    .foregroundStyle(.text)
                                    .padding()
                                
                            }
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                if !vm.firstSentenceOfContent.isEmpty {
                                    Text(vm.firstSentenceOfContent)
                                        .font(.customSen(.regular, size: 13))
                                        .foregroundStyle(.text)
                                }
                                HStack(spacing: 16) {
                                    ForEach(article.tags, id: \.self) {
                                        TagView(title: $0)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial.opacity(0.1))
                            .cornerRadius(25)
                            .padding(.horizontal)
                            
                            HStack {
                                CotegoryButton(title: article.categoryId, isSelected: false, onTap: {})
                                CotegoryButton(title: "\(article.readTime) min", isSelected: false, onTap: {})
                                CotegoryButton(title: vm.lastUpdatedText, isSelected: false, onTap: {})
                            }
                            .padding(.horizontal)
                            
                            ForEach(vm.contentBlocks.indices, id: \.self) { index in
                                ContentBlockView(block: vm.contentBlocks[index])
                            }
                            
                            HStack {
                                MainButtonTransparentView(title: "Share", onTap: {})
                                MainButtonsFillView(title: "Mark as read", onReady: {
                                    vm.markAsRead()
                                    onBackTap()
                                })
                            }
                            .padding(.horizontal)
                        }
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            Task {
                await vm.load()
            }
        }
    }
}

struct ContentBlockView: View {

    let block: ContentBlockDTO

    var body: some View {
        switch block.type {

        case .text:
            if case .text(let text) = block.value {
                ArticleTextView(
                    title: block.title ?? "",
                    description: text
                )
            }

        case .list, .fact:
            if case .list(let items) = block.value {
                ArticleTextView(
                    title: block.title ?? "",
                    description: items
                        .map { "• \($0)" }
                        .joined(separator: "\n")
                )
            }

        case .qa:
            if case .qa(let items) = block.value {
                ArticleTextView(
                    title: "Q&A",
                    description: items
                        .map {
                            "Q: \($0.question)\nA: \($0.answer)"
                        }
                        .joined(separator: "\n\n")
                )
            }
        case .image:
            Text("Image")
        }
    }
}



struct ArticleTextView: View {
    let title: String
    let description: String
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !title.isEmpty {
                Text(title)
                    .font(.customSen(.semiBold, size: 14))
                    .foregroundStyle(.text)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Text(description)
                .font(.customSen(.regular, size: 13))
                .foregroundStyle(.text)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial.opacity(0.1))
        .cornerRadius(25)
        .padding(.horizontal)
    }
}
