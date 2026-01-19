//
//  View+extensions.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 19.01.2026.
//

import Foundation
import SwiftUI

extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    func searchKeyboardToolbar(
        isFocused: FocusState<Bool>.Binding,
        onSearch: @escaping () -> Void
    ) -> some View {
        self
            .submitLabel(.search)
            .onSubmit {
                onSearch()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused.wrappedValue = false
                        onSearch()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.mainGreen)
                }
            }
    }
}
