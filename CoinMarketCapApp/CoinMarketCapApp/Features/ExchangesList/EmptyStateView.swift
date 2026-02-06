//
//  EmptyStateView.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

final class EmptyStateView: UIView {
    
    // MARK: - UI Components
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = DSColor.textTertiary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.headlineLarge()
        label.textColor = DSColor.textSecondary
        label.textAlignment = .center
        label.text = "No exchanges found"
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.body()
        label.textColor = DSColor.textTertiary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Try adjusting your search to find what you're looking for."
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            iconImageView.widthAnchor.constraint(equalToConstant: DSTheme.Size.iconLarge),
            iconImageView.heightAnchor.constraint(equalToConstant: DSTheme.Size.iconLarge),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: DSTheme.Spacing.lg),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTheme.Spacing.md),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTheme.Spacing.md),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DSTheme.Spacing.sm),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTheme.Spacing.md),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTheme.Spacing.md)
        ])
    }
}
