//
//  Color+Extension.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 05/06/26.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red:     Double(r) / 255,
            green:   Double(g) / 255,
            blue:    Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // Brand Colors
    static let brandDark       = Color(hex: "060659")
    static let brandBlue       = Color(hex: "0053FF")
    static let brandCyan       = Color(hex: "00C6FF")
    static let brandBlack      = Color(hex: "000000")
    static let brandWhite      = Color(hex: "FFFFFF")
    static let white70 = Color.white.opacity(0.7)
}
