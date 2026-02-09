//
//  ExchangeDetailView.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

final class ExchangeDetailView: UIView {
    
    // MARK: - UI Components
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = DSTheme.CornerRadius.medium
        imageView.backgroundColor = DSColor.backgroundSecondary
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.displaySmall()
        label.textColor = DSColor.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    lazy var volumeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.headline()
        label.textColor = DSColor.textSecondary
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.bodyMedium()
        label.textColor = DSColor.textTertiary
        label.textAlignment = .center
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.bodyMedium()
        label.textColor = DSColor.textTertiary
        label.textAlignment = .center
        return label
    }()
    
    lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.label()
        label.textColor = DSColor.info
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var feesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DSTheme.Spacing.sm
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var makerFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.bodyMedium()
        label.textColor = DSColor.textSecondary
        return label
    }()
    
    lazy var takerFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.bodyMedium()
        label.textColor = DSColor.textSecondary
        return label
    }()
    
    lazy var aboutTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.headlineLarge()
        label.textColor = DSColor.textPrimary
        label.text = LocalizedKey.about.localized
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.body()
        label.textColor = DSColor.textPrimary
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var currenciesTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.headlineLarge()
        label.textColor = DSColor.textPrimary
        label.text = LocalizedKey.currencies.localized
        return label
    }()
    
    lazy var currenciesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = DSTheme.Spacing.sm + DSTheme.Spacing.xs
        layout.minimumLineSpacing = DSTheme.Spacing.sm + DSTheme.Spacing.xs
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CurrencyCollectionViewCell.self, forCellWithReuseIdentifier: CurrencyCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = DSColor.error
        label.font = DSTypography.body()
        label.isHidden = true
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
        backgroundColor = DSColor.backgroundPrimary
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(volumeLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(websiteLabel)
        contentView.addSubview(feesStackView)
        feesStackView.addArrangedSubview(makerFeeLabel)
        feesStackView.addArrangedSubview(takerFeeLabel)
        contentView.addSubview(aboutTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(currenciesTitleLabel)
        contentView.addSubview(currenciesCollectionView)
        
        addSubview(loadingIndicator)
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DSTheme.Spacing.md),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: DSTheme.Size.logoLarge),
            logoImageView.heightAnchor.constraint(equalToConstant: DSTheme.Size.logoLarge),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: DSTheme.Spacing.md),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            volumeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: DSTheme.Spacing.sm),
            volumeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            volumeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            dateLabel.topAnchor.constraint(equalTo: volumeLabel.bottomAnchor, constant: DSTheme.Spacing.xs),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            idLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: DSTheme.Spacing.xs),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            websiteLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: DSTheme.Spacing.md),
            websiteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            websiteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            feesStackView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: DSTheme.Spacing.md),
            feesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            feesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            aboutTitleLabel.topAnchor.constraint(equalTo: feesStackView.bottomAnchor, constant: DSTheme.Spacing.xl),
            aboutTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            aboutTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            descriptionLabel.topAnchor.constraint(equalTo: aboutTitleLabel.bottomAnchor, constant: DSTheme.Spacing.sm + DSTheme.Spacing.xs),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            currenciesTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: DSTheme.Spacing.xl),
            currenciesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            currenciesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            currenciesCollectionView.topAnchor.constraint(equalTo: currenciesTitleLabel.bottomAnchor, constant: DSTheme.Spacing.md),
            currenciesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            currenciesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            currenciesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DSTheme.Spacing.md),
            currenciesCollectionView.heightAnchor.constraint(equalToConstant: DSTheme.Size.cellHeightLarge * 2),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTheme.Spacing.md),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTheme.Spacing.md)
        ])
    }
    
    // MARK: - Public Methods
    
    func showLoading() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        errorLabel.isHidden = true
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        scrollView.isHidden = false
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        scrollView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func hideError() {
        errorLabel.isHidden = true
        scrollView.isHidden = false
    }
    
    func showEmptyCurrenciesMessage() {
        currenciesTitleLabel.text = LocalizedKey.currenciesNotAvailable.localized
        currenciesTitleLabel.textColor = DSColor.textSecondary
    }
}

// MARK: - Currency Collection View Cell

final class CurrencyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CurrencyCollectionViewCell"
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = DSTheme.CornerRadius.small
        imageView.backgroundColor = DSColor.backgroundSecondary
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.bodyMedium()
        label.textColor = DSColor.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.labelSmall()
        label.textColor = DSColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupCell() {
        contentView.backgroundColor = DSColor.backgroundSecondary
        contentView.layer.cornerRadius = DSTheme.CornerRadius.medium
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DSTheme.Spacing.sm),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: DSTheme.Size.iconMedium),
            logoImageView.heightAnchor.constraint(equalToConstant: DSTheme.Size.iconMedium),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: DSTheme.Spacing.sm),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.xs),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.xs),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: DSTheme.Spacing.xs),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.xs),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.xs),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DSTheme.Spacing.sm)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: ExchangeDetailModels.CurrencyViewModel) {
        nameLabel.text = viewModel.name
        
        if let priceUSD = viewModel.priceUSD {
            priceLabel.text = String(format: LocalizedKey.priceFormat.localized, priceUSD)
            priceLabel.isHidden = false
        } else {
            priceLabel.text = LocalizedKey.na.localized
            priceLabel.isHidden = false
        }
        
        logoImageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
        logoImageView.tintColor = DSColor.textTertiary
        
        if !viewModel.logoURL.isEmpty, let url = URL(string: viewModel.logoURL) {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                #if DEBUG
                print("Error loading currency image: \(error.localizedDescription)")
                #endif
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data, !data.isEmpty,
                  let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.logoImageView.image = image
                self.logoImageView.tintColor = nil
            }
        }.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }
}
