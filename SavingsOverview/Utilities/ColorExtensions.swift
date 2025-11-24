//
//  ColorExtensions.swift
//  SavingsOverview
//
//  Created on 2025
//

import SwiftUI

extension Color {
    /// Initialize Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Convert Color to hex string
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}

// MARK: - Predefined colors for accounts
extension Color {
    static let accountColors: [Color] = [
        Color(hex: "#FF6B6B"),  // Red
        Color(hex: "#4ECDC4"),  // Teal
        Color(hex: "#95E1D3"),  // Mint
        Color(hex: "#FFD93D"),  // Yellow
        Color(hex: "#6BCF7F"),  // Green
        Color(hex: "#A8E6CF"),  // Light Green
        Color(hex: "#FFAAA5"),  // Pink
        Color(hex: "#FF8B94"),  // Coral
        Color(hex: "#B4A7D6"),  // Purple
        Color(hex: "#8AC6D1")   // Blue
    ]
    
    static func randomAccountColor() -> Color {
        accountColors.randomElement() ?? Color.blue
    }
}
