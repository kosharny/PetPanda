//
//  EmptyView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 18.01.2026.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Text("Uh-oh, pandas couldn’t deliver this page :(")
                    .font(.customSen(.medium, size: 18))
                    .foregroundStyle(.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Image("emptyImage")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 350)
                
                MainButtonsView(title: "Retry")
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    EmptyView()
}
