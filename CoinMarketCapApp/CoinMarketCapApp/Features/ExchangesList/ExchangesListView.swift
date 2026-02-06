//
//  ExchangesListView.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

final class ExchangesListView: UIView {
    
    // MARK: - UI Components
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExchangeTableViewCell.self, forCellReuseIdentifier: ExchangeTableViewCell.identifier)
        tableView.register(ShimmerTableViewCell.self, forCellReuseIdentifier: ShimmerTableViewCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = DSTheme.Size.cellHeightMedium
        // Enable automatic large title collapsing on scroll
        tableView.contentInsetAdjustmentBehavior = .always
        return tableView
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
    
    lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
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
        addSubview(tableView)
        addSubview(loadingIndicator)
        addSubview(errorLabel)
        addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTheme.Spacing.md),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTheme.Spacing.md),

            emptyStateView.topAnchor.constraint(equalTo: topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    func showLoading() {
        loadingIndicator.startAnimating()
        tableView.isHidden = true
        errorLabel.isHidden = true
        emptyStateView.isHidden = true
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        tableView.isHidden = false
    }
    
    func showShimmerLoading() {
        tableView.isHidden = false
        errorLabel.isHidden = true
        emptyStateView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func hideShimmerLoading() {
        // Shimmer cells will be replaced by real cells
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        tableView.isHidden = true
        emptyStateView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func hideError() {
        errorLabel.isHidden = true
        tableView.isHidden = false
    }
    
    func showEmptyState() {
        emptyStateView.isHidden = false
        tableView.isHidden = true
        errorLabel.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func hideEmptyState() {
        emptyStateView.isHidden = true
        tableView.isHidden = false
    }
}

// MARK: - Exchange Table View Cell

final class ExchangeTableViewCell: UITableViewCell {
    
    static let identifier = "ExchangeTableViewCell"
    
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
        label.font = DSTypography.headlineSmall()
        label.textColor = DSColor.textPrimary
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.label()
        label.textColor = DSColor.textSecondary
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSTypography.bodySmall()
        label.textColor = DSColor.textTertiary
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupCell() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(volumeLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTheme.Spacing.md),
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: DSTheme.Size.logoSmall),
            logoImageView.heightAnchor.constraint(equalToConstant: DSTheme.Size.logoSmall),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DSTheme.Spacing.sm + DSTheme.Spacing.xs),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: DSTheme.Spacing.sm + DSTheme.Spacing.xs),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTheme.Spacing.md),
            
            volumeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: DSTheme.Spacing.xs),
            volumeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            volumeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: volumeLabel.bottomAnchor, constant: DSTheme.Spacing.xs),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(DSTheme.Spacing.sm + DSTheme.Spacing.xs))
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: ExchangesList.ExchangeViewModel) {
        nameLabel.text = viewModel.name
        volumeLabel.text = "Volume: \(viewModel.volumeFormatted)"
        dateLabel.text = "Launched: \(viewModel.dateLaunchedFormatted)"
        
        // Reset image
        logoImageView.image = UIImage(systemName: "building.2.fill")
        logoImageView.tintColor = DSColor.textTertiary
        
        // Try to load image if URL is valid
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
                print("Error loading image from \(url.absoluteString): \(error.localizedDescription)")
                #endif
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                #if DEBUG
                print("Invalid response for image URL: \(url.absoluteString)")
                #endif
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                #if DEBUG
                print("HTTP \(httpResponse.statusCode) for image URL: \(url.absoluteString)")
                #endif
                return
            }
            
            guard let data = data, !data.isEmpty else {
                #if DEBUG
                print("Empty data for image URL: \(url.absoluteString)")
                #endif
                return
            }
            
            guard let image = UIImage(data: data) else {
                #if DEBUG
                print("Failed to create image from data for URL: \(url.absoluteString)")
                #endif
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
        volumeLabel.text = nil
        dateLabel.text = nil
    }
}
