//
//  DSButton.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

enum DSButtonStyle {
    case primary
    case secondary
    case outline
    case text
}

final class DSButton: UIButton {
    
    // MARK: - Properties
    
    var style: DSButtonStyle = .primary {
        didSet {
            updateStyle()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    convenience init(style: DSButtonStyle, title: String? = nil) {
        self.init(frame: .zero)
        self.style = style
        setTitle(title, for: .normal)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        titleLabel?.font = DSTypography.headlineSmall()
        layer.cornerRadius = DSTheme.CornerRadius.small
        
        // Use UIButton.Configuration for iOS 15+
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(
                top: DSTheme.Spacing.sm,
                leading: DSTheme.Spacing.lg,
                bottom: DSTheme.Spacing.sm,
                trailing: DSTheme.Spacing.lg
            )
            configuration = config
        } else {
            contentEdgeInsets = UIEdgeInsets(
                top: DSTheme.Spacing.sm,
                left: DSTheme.Spacing.lg,
                bottom: DSTheme.Spacing.sm,
                right: DSTheme.Spacing.lg
            )
        }
        
        updateStyle()
    }
    
    private func updateStyle() {
        switch style {
        case .primary:
            backgroundColor = DSColor.primaryBrand
            setTitleColor(.white, for: .normal)
            setTitleColor(.white.withAlphaComponent(0.6), for: .disabled)
            layer.borderWidth = 0
            
        case .secondary:
            backgroundColor = DSColor.surface
            setTitleColor(DSColor.textPrimary, for: .normal)
            setTitleColor(DSColor.textSecondary, for: .disabled)
            layer.borderWidth = 0
            
        case .outline:
            backgroundColor = .clear
            setTitleColor(DSColor.primaryBrand, for: .normal)
            setTitleColor(DSColor.primaryBrand.withAlphaComponent(0.6), for: .disabled)
            layer.borderWidth = DSTheme.BorderWidth.medium
            layer.borderColor = DSColor.primaryBrand.cgColor
            
        case .text:
            backgroundColor = .clear
            setTitleColor(DSColor.primaryBrand, for: .normal)
            setTitleColor(DSColor.primaryBrand.withAlphaComponent(0.6), for: .disabled)
            layer.borderWidth = 0
        }
    }
    
    // MARK: - Overrides
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.6
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: DSTheme.Animation.fast) {
                self.alpha = self.isHighlighted ? 0.8 : 1.0
            }
        }
    }
}
