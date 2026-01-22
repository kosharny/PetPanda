//
//  SettingsView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var vm: SettingsViewModel
    @StateObject var iapManager = PurchaseManager.shared
    
    @State private var showAlert = false
    @State private var alertType: PurchaseAlertType = .confirmExport
    
    enum PurchaseAlertType {
        case confirmExport, confirmTheme, success, failure, restoreSuccess
    }
    
    let onBackTap: () -> Void
    let onAboutTap: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(
                    tilte: "Settings",
                    leftBarButton: "chevron.left",
                    rightBarButton: nil,
                    onRightTap: {
                    },
                    onLeftTap: {
                        onBackTap()
                    })
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("Themes")
                            .font(.customSen(.regular, size: 15, offset: vm.fontSizeOffset))
                            .foregroundStyle(.text)
                            .padding()
                        HStack(spacing: 16) {
                            themeButton(for: .classic, imageName: "checkTheme")
                            
                            themeButton(for: .bambooNight, imageName: iapManager.isThemeUnlocked ? "checkTheme" : "payLock")
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Text("Preferences")
                            .font(.customSen(.regular, size: 15, offset: vm.fontSizeOffset))
                            .foregroundStyle(.text)
                            .padding()
                        
                        VStack {
                            Toggle("Notifications “Fact of the Day”", isOn: $vm.notificationsEnabled)
                                .toggleStyle(GlassToggleStyle())
                                .padding(.horizontal, 20)
                            
                            Divider()
                                .padding()
                                .frame(height: 1)
                                .background(.text.opacity(0.5))
                            
                            HStack {
                                Text("Font size")
                                    .font(.customSen(.semiBold, size: 16, offset: vm.fontSizeOffset))
                                    .foregroundStyle(.text)
                                Spacer()
                                Text("S")
                                    .font(.customSen(.regular, size: 13, offset: vm.fontSizeOffset))
                                    .foregroundStyle(.text)
                                FontSizeSlider(selection: $vm.fontSizeSelection)
                                Text("L")
                                    .font(.customSen(.regular, size: 13, offset: vm.fontSizeOffset))
                                    .foregroundStyle(.text)
                            }
                            .padding(.top)
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
                        
                        dataSection
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            
            if showAlert {
                alertOverlay
            }
        }
    }
    
    @ViewBuilder
        private func themeButton(for theme: AppTheme, imageName: String) -> some View {
            let isSelected = vm.selectedTheme == theme
            let isLocked = theme == .bambooNight && !iapManager.isThemeUnlocked
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Material.ultraThinMaterial.opacity(0.2))
                        .frame(minWidth: 120, minHeight: 150)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(LinearGradient(colors: theme.colors, startPoint: .bottomLeading, endPoint: .topTrailing))
                        .padding(8)
                    
                    if isLocked {
                        Image("payLock").resizable().scaledToFit().frame(maxWidth: 50)
                    } else if isSelected {
                        Image("checkTheme").resizable().scaledToFit().frame(maxWidth: 50)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isSelected ? Color.mainGreen : Color.text.opacity(0.3), lineWidth: isSelected ? 3 : 1)
                )
                
                Text(theme.rawValue)
                    .font(.customSen(.regular, size: 15, offset: vm.fontSizeOffset))
                    .foregroundStyle(isSelected ? .mainGreen : .mainGreen.opacity(0.5))
            }
            .onTapGesture {
                if isLocked {
                    alertType = .confirmTheme
                    showAlert = true
                } else {
                    withAnimation { vm.setTheme(theme) }
                }
            }
        }

        private var dataSection: some View {
            VStack(spacing: 16) {
                Button(action: {
                    if !iapManager.isExportUnlocked {
                        alertType = .confirmExport
                        showAlert = true
                    }
                }) {
                    HStack {
                        Text("Export Data (PDF)").font(.customSen(.regular, size: 13, offset: vm.fontSizeOffset)).foregroundStyle(.text)
                        Spacer()
                        if !iapManager.isExportUnlocked {
                            Image("payLock").resizable().frame(width: 30, height: 30)
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider().padding(.horizontal).background(.text.opacity(0.5))
                
                Button(action: {
                    Task {
                        let success = await iapManager.restore()
                        alertType = success ? .restoreSuccess : .failure
                        showAlert = true
                    }
                }) {
                    HStack {
                        Text("Restore Purchases").font(.customSen(.regular, size: 13, offset: vm.fontSizeOffset)).foregroundStyle(.text)
                        Spacer()
                        Image(systemName: "chevron.right").font(.title3.bold()).foregroundStyle(.mainGreen)
                    }
                }
                .padding(.horizontal)
                
                Divider().padding(.horizontal).background(.text.opacity(0.5))
                
                Button(action: onAboutTap) {
                    HStack {
                        Text("About App").font(.customSen(.regular, size: 13, offset: vm.fontSizeOffset)).foregroundStyle(.text)
                        Spacer()
                        Image(systemName: "chevron.right").font(.title3.bold()).foregroundStyle(.mainGreen)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 28).fill(Material.ultraThinMaterial.opacity(0.2)))
            .padding(.horizontal)
        }
}

extension SettingsView {
    var alertOverlay: some View {
        Group {
            switch alertType {
            case .confirmExport:
                CustomPurchaseAlert(
                    title: "Unlock data export",
                    message: "Want to save, share or work with your notes outside the app? Activate data export.",
                    primaryButtonTitle: "Buy $1.99",
                    secondaryButtonTitle: "Cancel",
                    action: { buy(iapManager.exportID) },
                    cancelAction: { showAlert = false }
                )
            case .confirmTheme:
                CustomPurchaseAlert(
                    title: "Unlock Premium theme",
                    message: "Would you like to purchase this theme and activate it now?",
                    primaryButtonTitle: "Buy $1.99",
                    secondaryButtonTitle: "Cancel",
                    action: { buy(iapManager.themeID) },
                    cancelAction: { showAlert = false }
                )
            case .success:
                CustomPurchaseAlert(
                    title: "Success",
                    message: "Purchase completed successfully!",
                    primaryButtonTitle: "Great",
                    secondaryButtonTitle: "Close",
                    action: { showAlert = false },
                    cancelAction: { showAlert = false }
                )
            case .failure:
                CustomPurchaseAlert(
                    title: "Purchase Failed",
                    message: "Something went wrong.",
                    primaryButtonTitle: "Try Again",
                    secondaryButtonTitle: "Cancel",
                    action: { showAlert = false }, 
                    cancelAction: { showAlert = false }
                )
            case .restoreSuccess:
                CustomPurchaseAlert(
                    title: "Restored",
                    message: "Your purchases have been successfully restored.",
                    primaryButtonTitle: "OK",
                    secondaryButtonTitle: "Close",
                    action: { showAlert = false },
                    cancelAction: { showAlert = false }
                )
            }
        }
    }
    
    private func buy(_ id: String) {
        Task {
            let success = await iapManager.purchase(id)
            alertType = success ? .success : .failure
            showAlert = true
        }
    }
}


struct FontSizeSlider: View {
    @Binding var selection: Int
    let steps = 3
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let knobSize: CGFloat = 14
            let currentProgress = CGFloat(selection) / CGFloat(steps - 1)
            let knobOffset = currentProgress * (width - knobSize)
            
            ZStack(alignment: .leading) {
                // Дорожка
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 8)
                
                // Прогресс
                Capsule()
                    .fill(Color.mainGreen)
                    .frame(width: knobOffset + knobSize, height: 8)
                
                // Ползунок
                Capsule()
                    .fill(Color.mainGreen)
                    .frame(width: knobSize, height: 26)
                    .offset(x: knobOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                // 1. Находим "сырое" значение от 0 до 1
                                let rawValue = gesture.location.x / width
                                // 2. Округляем до ближайшего целого шага (0, 1 или 2)
                                let step = Int(round(rawValue * CGFloat(steps - 1)))
                                // 3. Ограничиваем диапазон
                                let validatedStep = max(0, min(step, steps - 1))
                                
                                if selection != validatedStep {
                                    selection = validatedStep
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred() // Виброотклик при переключении
                                }
                            }
                    )
            }
        }
        .frame(width: 140, height: 26)
    }
}
