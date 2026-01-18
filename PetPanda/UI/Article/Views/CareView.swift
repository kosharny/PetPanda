//
//  CareView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct CareView: View {
    @State private var currentStep = 0
    @State private var notesText: String = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 20) {
                
                HeaderView(tilte: "What Do Giant Pandas Eat?", leftBarButton: "chevron.left", rightBarButton: "star.fill")
                
                Text("Steps 1 of 4")
                    .font(.customSen(.semiBold, size: 18))
                    .foregroundStyle(.text)
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { index in
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
                        VStack {
                            Image("panda_eating_bamboo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                            Text("Main diet")
                                .font(.customSen(.semiBold, size: 14))
                                .foregroundStyle(.text)
                                .padding(.top)
                            Text("""
                                Pandas eat:
                                - Bamboo stalks
                                - Bamboo leaves
                                - Bamboo shoots (their favorite, richest in nutrients)
                                
                                Sometimes pandas may eat:
                                - Small rodents
                                - Birds
                                - Eggs
                                - Insects
                                """)
                                .font(.customSen(.semiBold, size: 13))
                                .foregroundStyle(.text)
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 280)
                        .background(.ultraThinMaterial.opacity(0.1))
                        .cornerRadius(25)
                        .padding(.horizontal)
                        
                        NotesFieldView(notesText: $notesText)
                        
                        HStack {
                            MainButtonTransparentView(title: "Back")
                            MainButtonsFillView(title: "Next")
                            MainButtonTransparentView(title: "Complited")
                        }
                        .padding(.horizontal)
                        Spacer(minLength: 100)
                    }
                }
            }
        }
    }
}

import SwiftUI

struct NotesFieldView: View {
    @Binding var notesText: String
    let characterLimit = 1000
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image("notes")
                    .font(.system(size: 20, weight: .semibold))
                
                Text("Notes")
                    .font(.customSen(.semiBold, size: 14))
                    .foregroundStyle(.text)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
                TextEditor(text: $notesText)
                    .scrollContentBackground(.hidden)
                    .font(.customSen(.regular, size: 12))
                    .foregroundStyle(.text)
                    .onChange(of: notesText) { _, newValue in
                        if newValue.count > characterLimit {
                            notesText = String(newValue.prefix(characterLimit))
                        }
                    }
            
            HStack {
                Spacer()
                Text("\(notesText.count)/\(characterLimit)")
                    .font(.customSen(.regular, size: 13))
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

#Preview {
    CareView()
}
