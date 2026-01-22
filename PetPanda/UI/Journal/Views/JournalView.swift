//
//  JournalView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//


import SwiftUI

struct JournalView: View {
    @StateObject var vm: JournalViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel
    @StateObject var iapManager = PurchaseManager.shared
    
    @State private var showAlert = false
    @State private var alertType: PurchaseAlertType = .confirmExport
    
    enum PurchaseAlertType {
        case confirmExport, success, failure
    }
    
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
                                        if iapManager.isExportUnlocked {
                                            exportAction()
                                        } else {
                                            alertType = .confirmExport
                                            showAlert = true
                                        }
                                    })
                                    .opacity(iapManager.isExportUnlocked ? 1.0 : 0.9)
                                    if !iapManager.isExportUnlocked {
                                        HStack {
                                            Spacer()
                                            Image("payLock")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: 24)
                                        }
                                        .padding(.horizontal, 40)
                                        .allowsHitTesting(false)
                                        
                                        .padding(.horizontal, 40)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    Spacer(minLength: 100)
                }
            }
            if showAlert {
                alertOverlay
            }
        }
        .onAppear {
            vm.load()
        }
    }
    
    private func exportAction() {
        if let pdfURL = vm.exportJournalToPDF() {
            let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                rootVC.present(activityVC, animated: true)
            }
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
                .font(.customSen(.semiBold, size: 16, offset: settingsVM.fontSizeOffset))
                .foregroundStyle(.text)
        }
    }
}

extension JournalView {
    var alertOverlay: some View {
        Group {
            switch alertType {
            case .confirmExport:
                CustomPurchaseAlert(
                    title: "Unlock data export",
                    message: "Want to save, share or work with your notes outside the app? Activate data export.",
                    primaryButtonTitle: "Buy $1.99",
                    secondaryButtonTitle: "Cancel",
                    action: {
                        Task {
                            let success = await iapManager.purchase(iapManager.exportID)
                            alertType = success ? .success : .failure
                        }
                    },
                    cancelAction: { showAlert = false }
                )
                
            case .success:
                CustomPurchaseAlert(
                    title: "Success",
                    message: "Data export is now unlocked!",
                    primaryButtonTitle: "Cool",
                    secondaryButtonTitle: "Close",
                    action: { showAlert = false },
                    cancelAction: { showAlert = false }
                )
                
            case .failure:
                CustomPurchaseAlert(
                    title: "Purchase Failed",
                    message: "Something went wrong. Please try again.",
                    primaryButtonTitle: "Try Again",
                    secondaryButtonTitle: "Cancel",
                    action: {
                        // Повторная попытка покупки
                        alertType = .confirmExport
                    },
                    cancelAction: { showAlert = false }
                )
            }
        }
    }
}
