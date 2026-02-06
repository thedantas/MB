//
//  ShimmerTableViewCell.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

final class ShimmerTableViewCell: UITableViewCell {
    
    static let identifier = "ShimmerTableViewCell"
    
    // MARK: - UI Components
    
    private let shimmerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DSColor.backgroundSecondary
        view.layer.cornerRadius = DSTheme.CornerRadius.small
        return view
    }()
    
    private let logoShimmer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DSColor.backgroundSecondary
        view.layer.cornerRadius = DSTheme.CornerRadius.small
        return view
    }()
    
    private let nameShimmer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DSColor.backgroundSecondary
        view.layer.cornerRadius = DSTheme.Spacing.xs
        return view
    }()
    
    private let volumeShimmer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DSColor.backgroundSecondary
        view.layer.cornerRadius = DSTheme.Spacing.xs
        return view
    }()
    
    private let dateShimmer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DSColor.backgroundSecondary
        view.layer.cornerRadius = DSTheme.Spacing.xs
        return view
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        startShimmer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupCell() {
        contentView.addSubview(logoShimmer)
        contentView.addSubview(nameShimmer)
        contentView.addSubview(volumeShimmer)
        contentView.addSubview(dateShimmer)
        
        NSLayoutConstraint.activate([
            logoShimmer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            logoShimmer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoShimmer.widthAnchor.constraint(equalToConstant: DSTheme.Size.logoSmall),
            logoShimmer.heightAnchor.constraint(equalToConstant: DSTheme.Size.logoSmall),
            
            nameShimmer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DSTheme.Spacing.sm + DSTheme.Spacing.xs),
            nameShimmer.leadingAnchor.constraint(equalTo: logoShimmer.trailingAnchor, constant: DSTheme.Spacing.sm + DSTheme.Spacing.xs),
            nameShimmer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            nameShimmer.heightAnchor.constraint(equalToConstant: DSTheme.Spacing.md),
            
            volumeShimmer.topAnchor.constraint(equalTo: nameShimmer.bottomAnchor, constant: DSTheme.Spacing.sm),
            volumeShimmer.leadingAnchor.constraint(equalTo: nameShimmer.leadingAnchor),
            volumeShimmer.widthAnchor.constraint(equalToConstant: 120),
            volumeShimmer.heightAnchor.constraint(equalToConstant: DSTheme.Spacing.sm + DSTheme.Spacing.xs),
            
            dateShimmer.topAnchor.constraint(equalTo: volumeShimmer.bottomAnchor, constant: DSTheme.Spacing.sm),
            dateShimmer.leadingAnchor.constraint(equalTo: nameShimmer.leadingAnchor),
            dateShimmer.widthAnchor.constraint(equalToConstant: 100),
            dateShimmer.heightAnchor.constraint(equalToConstant: DSTheme.Spacing.sm),
            dateShimmer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(DSTheme.Spacing.sm + DSTheme.Spacing.xs))
        ])
    }
    
    // MARK: - Shimmer Animation
    
    private func startShimmer() {
        let shimmerViews = [logoShimmer, nameShimmer, volumeShimmer, dateShimmer]
        
        shimmerViews.forEach { view in
            view.backgroundColor = DSColor.backgroundSecondary
            animateShimmer(view: view)
        }
    }
    
    private func animateShimmer(view: UIView) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = DSColor.backgroundSecondary.cgColor
        animation.toValue = DSColor.surface.cgColor
        animation.duration = DSTheme.Animation.normal
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        view.layer.add(animation, forKey: "shimmer")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
