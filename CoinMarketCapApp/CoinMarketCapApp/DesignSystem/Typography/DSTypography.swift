//
//  DSTypography.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

enum DSTypography {
    
    // MARK: - Display
    
    static func displayLarge() -> UIFont {
        .systemFont(ofSize: 32, weight: .bold)
    }
    
    static func displayMedium() -> UIFont {
        .systemFont(ofSize: 28, weight: .bold)
    }
    
    static func displaySmall() -> UIFont {
        .systemFont(ofSize: 24, weight: .bold)
    }
    
    // MARK: - Headline
    
    static func headlineLarge() -> UIFont {
        .systemFont(ofSize: 20, weight: .semibold)
    }
    
    static func headline() -> UIFont {
        .systemFont(ofSize: 18, weight: .semibold)
    }
    
    static func headlineSmall() -> UIFont {
        .systemFont(ofSize: 16, weight: .semibold)
    }
    
    // MARK: - Title
    
    static func title() -> UIFont {
        .systemFont(ofSize: 24, weight: .bold)
    }
    
    static func titleMedium() -> UIFont {
        .systemFont(ofSize: 20, weight: .bold)
    }
    
    static func titleSmall() -> UIFont {
        .systemFont(ofSize: 18, weight: .bold)
    }
    
    // MARK: - Body
    
    static func body() -> UIFont {
        .systemFont(ofSize: 16, weight: .regular)
    }
    
    static func bodyMedium() -> UIFont {
        .systemFont(ofSize: 14, weight: .regular)
    }
    
    static func bodySmall() -> UIFont {
        .systemFont(ofSize: 12, weight: .regular)
    }
    
    // MARK: - Caption
    
    static func caption() -> UIFont {
        .systemFont(ofSize: 12, weight: .regular)
    }
    
    static func captionSmall() -> UIFont {
        .systemFont(ofSize: 10, weight: .regular)
    }
    
    // MARK: - Label
    
    static func label() -> UIFont {
        .systemFont(ofSize: 14, weight: .medium)
    }
    
    static func labelSmall() -> UIFont {
        .systemFont(ofSize: 12, weight: .medium)
    }
}

// MARK: - Dynamic Type Support (Future Enhancement)

extension DSTypography {
    
    /// Returns a font that scales with Dynamic Type
    static func scaledFont(_ font: UIFont, maximumPointSize: CGFloat? = nil) -> UIFont {
        let metrics = UIFontMetrics.default
        if let maxSize = maximumPointSize {
            return metrics.scaledFont(for: font, maximumPointSize: maxSize)
        }
        return metrics.scaledFont(for: font)
    }
}
