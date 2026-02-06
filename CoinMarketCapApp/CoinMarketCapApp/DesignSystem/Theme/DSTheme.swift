//
//  DSTheme.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

enum DSTheme {
    
    // MARK: - Spacing
    
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
    }
    
    // MARK: - Border Width
    
    enum BorderWidth {
        static let thin: CGFloat = 0.5
        static let medium: CGFloat = 1
        static let thick: CGFloat = 2
    }
    
    // MARK: - Shadow
    
    enum Shadow {
        static let small = ShadowStyle(
            color: UIColor.black,
            opacity: 0.05,
            offset: CGSize(width: 0, height: 2),
            radius: 4
        )
        
        static let medium = ShadowStyle(
            color: UIColor.black,
            opacity: 0.08,
            offset: CGSize(width: 0, height: 4),
            radius: 8
        )
        
        static let large = ShadowStyle(
            color: UIColor.black,
            opacity: 0.12,
            offset: CGSize(width: 0, height: 8),
            radius: 16
        )
    }
    
    // MARK: - Size
    
    enum Size {
        // Icon sizes
        static let iconSmall: CGFloat = 24
        static let iconMedium: CGFloat = 40
        static let iconLarge: CGFloat = 64
        
        // Cell heights
        static let cellHeightSmall: CGFloat = 60
        static let cellHeightMedium: CGFloat = 80
        static let cellHeightLarge: CGFloat = 100
        
        // Logo sizes
        static let logoSmall: CGFloat = 32
        static let logoMedium: CGFloat = 48
        static let logoLarge: CGFloat = 80
    }
    
    // MARK: - Animation
    
    enum Animation {
        static let fast: TimeInterval = 0.15
        static let normal: TimeInterval = 0.25
        static let slow: TimeInterval = 0.35
    }
}

// MARK: - Shadow Style

struct ShadowStyle {
    let color: UIColor
    let opacity: Float
    let offset: CGSize
    let radius: CGFloat
    
    func apply(to layer: CALayer) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}
