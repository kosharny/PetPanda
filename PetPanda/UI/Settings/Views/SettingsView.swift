//
//  SettingsView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var unreadOnly = false
    @State private var selection: Int = 1
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HeaderView(tilte: "Settings", leftBarButton: "chevron.left", rightBarButton: nil)
                
                Text("Themes")
                    .font(.customSen(.regular, size: 15))
                    .foregroundStyle(.text)
                    .padding()
                HStack(spacing: 16) {
                    VStack {
                        Image("checkTheme")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 50)
                            .padding()
                            .frame(minWidth: 120, minHeight: 150, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Material.ultraThinMaterial.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.endBg.opacity(0))
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.text.opacity(0.3), lineWidth: 1)
                            )
                        Text("Classic")
                            .font(.customSen(.regular, size: 15))
                            .foregroundStyle(.mainGreen)
                    }
                    VStack {
                        Image("payLock")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 50)
                            .padding()
                            .frame(minWidth: 120, minHeight: 150, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Material.ultraThinMaterial.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(
                                                LinearGradient(colors: [.startBg, .endBg], startPoint: .bottomLeading, endPoint: .topTrailing)
                                            )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.text.opacity(0.3), lineWidth: 1)
                            )
                        Text("Bamboo Night")
                            .font(.customSen(.regular, size: 15))
                            .foregroundStyle(.mainGreen.opacity(0.2))
                    }
                }
                .padding(.horizontal)
                
                Text("Preferences")
                    .font(.customSen(.regular, size: 15))
                    .foregroundStyle(.text)
                    .padding()
                
                VStack {
                    Toggle("Notifications “Fact of the Day”", isOn: $unreadOnly)
                        .toggleStyle(GlassToggleStyle())
                        .padding(.horizontal, 20)
                    
                    Divider()
                        .padding()
                        .frame(height: 1)
                        .background(.text.opacity(0.5))
                    
                    HStack {
                        Text("Font size")
                            .font(.customSen(.semiBold, size: 16))
                            .foregroundStyle(.text)
                        Spacer()
                        Text("S")
                            .font(.customSen(.regular, size: 13))
                            .foregroundStyle(.text)
                        FontSizeSlider(selection: $selection)
                        Text("L")
                            .font(.customSen(.regular, size: 13))
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
                
                Text("Data")
                    .font(.customSen(.regular, size: 15))
                    .foregroundStyle(.text)
                    .padding()
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Export Data (PDF)")
                            .font(.customSen(.regular, size: 13))
                            .foregroundStyle(.text)
                        Spacer()
                        Image("payLock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal)
                    Divider()
                        .padding()
                        .frame(height: 1)
                        .background(.text.opacity(0.5))
                    
                    HStack {
                        Text("Restore Purchases")
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
                        Text("About App")
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
                
                Spacer(minLength: 100)
            }
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

#Preview {
    SettingsView()
}
