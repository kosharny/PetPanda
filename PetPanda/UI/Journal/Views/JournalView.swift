//
//  JournalView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//


import SwiftUI

struct JournalView: View {
    @StateObject var vm: JournalViewModel
    
    let onSettingsTap: () -> Void
    let onBackTap: () -> Void
    let onArticleTap: (String, ContentType) -> Void
    
    init(
        repository: JournalRepository,
        onBackTap: @escaping () -> Void,
        onSettingsTap: @escaping () -> Void,
        onArticleTap: @escaping (String, ContentType) -> Void
    ) {
        _vm = StateObject(wrappedValue: JournalViewModel(journalRepo: repository))
        self.onBackTap = onBackTap
        self.onSettingsTap = onSettingsTap
        self.onArticleTap = onArticleTap
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(
                    tilte: "Journal",
                    leftBarButton: "chevron.left",
                    rightBarButton: "gearshape.fill",
                    onRightTap: {
                        onSettingsTap()
                    },
                    onLeftTap: {
                        onBackTap()
                    })
                
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack {
                            filterBtn(title: "All", filter: .all)
                            filterBtn(title: "Articles", filter: .article)
                            filterBtn(title: "Guides", filter: .care)
                            filterBtn(title: "Quizzes", filter: .quiz)
                        }
                        .padding(.vertical)
                        if vm.groupedItems.isEmpty {
                            EmptyView(title: "Here you will find articles read and quizzes completed.", imageName: "journalEmptyImage", isButtonNeeded: false)
                        } else {
                            
                            VStack(spacing: 20) {
                                ForEach(vm.groupedItems, id: \.0) { date, items in
                                    VStack(alignment: .leading, spacing: 15) {
                                        HStack {
                                            Spacer()
                                            dateHeader(date)
                                            Spacer()
                                        }
                                        
                                        ForEach(items) { item in
                                            ArticleCard(
                                                category: item.category,
                                                title: item.title,
                                                tag: item.tag,
                                                type: item.category,
                                                isFavorite: false,
                                                progress: 0.0,
                                                onTap: {
                                                    onArticleTap(item.id, item.type)
                                                }
                                            )
                                        }
                                    }
                                }
                                
                                ZStack {
                                    MainButtonsFillView(title: "Export Data (PDF)", onReady: {
                                        if let pdfURL = vm.exportJournalToPDF() {
                                            let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
                                            
                                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                               let rootVC = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                                                rootVC.present(activityVC, animated: true)
                                            } else {
                                                print("Failed to find rootViewController to present share sheet")
                                            }
                                        }

                                    })
                                    HStack {
                                        Spacer()
                                        Image("lock")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: 20)
                                    }
                                    .padding(.horizontal, 40)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            vm.load()
        }
    }
    
    private func filterBtn(
        title: String,
        filter: FavoritesFilter
    ) -> some View {
        CotegoryButton(
            title: title,
            isSelected: vm.isSelected(filter),
            onTap: { vm.select(filter) }
        )
    }
    
    private func dateHeader(_ date: Date) -> some View {
        HStack(spacing: 8) {
            Image("calendar")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)

            Text(vm.formattedDate(date))
                .font(.customSen(.semiBold, size: 16))
                .foregroundStyle(.text)
        }
    }
}

