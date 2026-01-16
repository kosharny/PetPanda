//
//  Font+extensions.swift
//  PetPanda
//
//  Created by Maksim Kosharny on 16.01.2026.
//

import SwiftUI

extension Font {
    
    static func customSen(_ weight: SenWeight, size: CGFloat) -> Font {
        return Font.custom("Sen-\(weight.rawValue)", size: size)
    }
    
    enum SenWeight: String {
        case bold = "Bold"
        case regular = "Regular"
        case medium = "Medium"
        case semiBold = "SemiBold"
    }
}
