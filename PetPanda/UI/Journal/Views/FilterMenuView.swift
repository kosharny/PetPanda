//
//  FilterMenuView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct FilterMenuView: View {
    @ObservedObject var vm: SearchViewModel
    let onApply: () -> Void
    
    let categories = ["Habitat", "Diet", "Behavior", "Fun Facts", "Health"]
    let progressOptions = ["< 20%", "20 - 70%", "70 - 100%"]
    
    var body: some View {
        ZStack {
            Color.endBg.edgesIgnoringSafeArea(.all) // Фон для поповера
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Type Filter
                    FilterGroup(title: "Type:") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                            ForEach(SearchType.allCases) { type in
                                CotegoryButton(
                                    title: type.rawValue,
                                    isSelected: vm.selectedType == type,
                                    onTap: {
                                        vm.selectedType = (vm.selectedType == type) ? nil : type
                                    }
                                )
                            }
                        }
                    }
                    
                    // Category Filter
                    FilterGroup(title: "Categories:") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                            ForEach(categories, id: \.self) { cat in
                                CotegoryButton(
                                    title: cat,
                                    isSelected: vm.selectedCategory == cat,
                                    onTap: {
                                        vm.selectedCategory = (vm.selectedCategory == cat) ? nil : cat
                                    }
                                )
                            }
                        }
                    }
                    
                    // Reading Time Filter
                    FilterGroup(title: "Reading Time:") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                            ForEach(ReadingTimeType.allCases) { time in
                                CotegoryButton(
                                    title: time.rawValue,
                                    isSelected: vm.selectedTime == time,
                                    onTap: {
                                        vm.selectedTime = (vm.selectedTime == time) ? nil : time
                                    }
                                )
                            }
                        }
                    }
                    
                    // Progress Filter
                    FilterGroup(title: "By progress:") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                            ForEach(progressOptions, id: \.self) { option in
                                CotegoryButton(
                                    title: option,
                                    isSelected: vm.selectedProgress == option,
                                    onTap: {
                                        vm.selectedProgress = (vm.selectedProgress == option) ? nil : option
                                    }
                                )
                            }
                        }
                    }
                    
                    // Unread Only
                    HStack {
                        Toggle("Unread only (0%)", isOn: $vm.unreadOnly)
                            .toggleStyle(GlassToggleStyle())
                            .padding(.horizontal, 4)
                    }
                    
                    Divider().background(Color.text.opacity(0.2))
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        MainButtonTransparentView(title: "Reset") {
                            withAnimation {
                                vm.resetFilters()
                            }
                        }
                        
                        MainButtonsFillView(title: "Apply") {
                            onApply()
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
        }
    }
}

struct FilterGroup<Content: View>: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.customSen(.semiBold, size: 16, offset: settingsVM.fontSizeOffset))
                .foregroundStyle(.text)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GlassToggleStyle: ToggleStyle {
    @EnvironmentObject var settingsVM: SettingsViewModel
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.customSen(.semiBold, size: 16, offset: settingsVM.fontSizeOffset))
                .foregroundColor(.text)
            
            Spacer()
            
            ZStack {
                Capsule()
                    .fill(Color.text.opacity(0.05))
                    .frame(width: 84, height: 34)
                    .overlay(
                        Capsule()
                            .stroke(Color.text.opacity(0.1), lineWidth: 1.5)
                    )
                
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(Color.mainGreen.opacity(configuration.isOn ? 1 : 0.1))
                    )
                    .frame(width: 54, height: 28)
                    .offset(x: configuration.isOn ? 12 : -12)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
