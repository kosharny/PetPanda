//
//  Font+extensions.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI

extension Font {
    
    private static var isSmallDevice: Bool {
        return UIScreen.main.bounds.width <= 375
    }
    
    static func customSen(_ weight: SenWeight, size: CGFloat, offset: CGFloat = 0) -> Font {
        let adaptiveSize = isSmallDevice ? (size - 2) : size
        
        return Font.custom("Sen-\(weight.rawValue)", size: adaptiveSize + offset)
    }
    
    enum SenWeight: String {
        case bold = "Bold"
        case regular = "Regular"
        case medium = "Medium"
        case semiBold = "SemiBold"
    }
}
