//
//  DSCardView.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

final class DSCardView: UIView {
    
    // MARK: - Properties
    
    var cornerRadius: CGFloat = DSTheme.CornerRadius.medium {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var shadowEnabled: Bool = true {
        didSet {
            updateShadow()
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
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = DSColor.surface
        layer.cornerRadius = cornerRadius
        updateShadow()
    }
    
    private func updateShadow() {
        if shadowEnabled {
            DSTheme.Shadow.medium.apply(to: layer)
        } else {
            layer.shadowColor = nil
            layer.shadowOpacity = 0
            layer.shadowOffset = .zero
            layer.shadowRadius = 0
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update shadow path for better performance
        if shadowEnabled {
            layer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: cornerRadius
            ).cgPath
        }
    }
}
