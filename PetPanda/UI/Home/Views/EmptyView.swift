//
//  EmptyView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct EmptyView: View {
    let title: String
    let imageName: String
    let isButtonNeeded: Bool
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Text(title)
                    .font(.customSen(.medium, size: 18))
                    .foregroundStyle(.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 350)
                if isButtonNeeded {
                    MainButtonsView(title: "Retry")
                        .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    EmptyView(title: "Uh-oh, pandas couldn’t deliver this page :(", imageName: "emptyImage", isButtonNeeded: false)
}
