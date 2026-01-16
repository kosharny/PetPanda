//
//  BackgroundView.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.startBg, .endBg], startPoint: .bottom, endPoint: .top)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
