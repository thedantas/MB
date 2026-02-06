//
//  DSColor.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

enum DSColor {
    
    // MARK: - Brand Colors
    
    static var primaryBrand: UIColor {
        UIColor(named: "primaryBrand") ?? UIColor(hex: "#F15A22")
    }
    
    // MARK: - Background Colors
    
    static var backgroundPrimary: UIColor {
        UIColor(named: "backgroundPrimary") ?? UIColor.systemBackground
    }
    
    static var backgroundSecondary: UIColor {
        UIColor(named: "backgroundSecondary") ?? UIColor.secondarySystemBackground
    }
    
    static var surface: UIColor {
        UIColor(named: "surface") ?? UIColor.tertiarySystemBackground
    }
    
    // MARK: - Text Colors
    
    static var textPrimary: UIColor {
        UIColor(named: "textPrimary") ?? UIColor.label
    }
    
    static var textSecondary: UIColor {
        UIColor(named: "textSecondary") ?? UIColor.secondaryLabel
    }
    
    static var textTertiary: UIColor {
        UIColor(named: "textTertiary") ?? UIColor.tertiaryLabel
    }
    
    // MARK: - Semantic Colors
    
    static var success: UIColor {
        UIColor(named: "success") ?? UIColor(hex: "#2ECC71")
    }
    
    static var error: UIColor {
        UIColor(named: "error") ?? UIColor(hex: "#E74C3C")
    }
    
    static var warning: UIColor {
        UIColor(named: "warning") ?? UIColor(hex: "#F39C12")
    }
    
    static var info: UIColor {
        UIColor(named: "info") ?? UIColor(hex: "#3498DB")
    }
    
    // MARK: - Border Colors
    
    static var border: UIColor {
        UIColor(named: "border") ?? UIColor.separator
    }
}

// MARK: - UIColor Extension for Hex

extension UIColor {
    convenience init(hex: String) {
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
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
