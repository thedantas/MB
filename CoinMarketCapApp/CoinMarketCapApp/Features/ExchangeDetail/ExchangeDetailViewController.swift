//
//  ExchangeDetailViewController.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

protocol ExchangeDetailDisplayLogic: AnyObject {
    func display(_ viewModel: ExchangeDetailModels.LoadDetail.ViewModel)
    func display(_ viewModel: ExchangeDetailModels.LoadCurrencies.ViewModel)
}

final class ExchangeDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let interactor: ExchangeDetailBusinessLogic
    private var currencies: [ExchangeDetailModels.CurrencyViewModel] = []
    private var lastDetailError: Error?
    private var lastCurrenciesError: Error?
    private var exchange: ExchangeDetailModels.ExchangeDetailViewModel?
    
    // MARK: - UI Components
    
    private lazy var customView: ExchangeDetailView = {
        let view = ExchangeDetailView()
        view.currenciesCollectionView.delegate = self
        view.currenciesCollectionView.dataSource = self
        return view
    }()
    
    // MARK: - Initialization
    
    init(interactor: ExchangeDetailBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Actions
    
    private func loadData() {
        customView.showLoading()
        
        let detailRequest = ExchangeDetailModels.LoadDetail.Request()
        interactor.loadDetail(request: detailRequest)
        
        let currenciesRequest = ExchangeDetailModels.LoadCurrencies.Request()
        interactor.loadCurrencies(request: currenciesRequest)
    }
}

// MARK: - ExchangeDetailDisplayLogic

extension ExchangeDetailViewController: ExchangeDetailDisplayLogic {
    
    func display(_ viewModel: ExchangeDetailModels.LoadDetail.ViewModel) {
        customView.hideLoading()
        
        if let errorMessage = viewModel.errorMessage {
            if let error = viewModel.error {
                lastDetailError = error
            }
            customView.showError(errorMessage)
            showErrorActionSheet(for: .detail)
        } else if let exchange = viewModel.exchange {
            customView.hideError()
            lastDetailError = nil
            configureView(with: exchange)
        }
    }
    
    func display(_ viewModel: ExchangeDetailModels.LoadCurrencies.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            if let error = viewModel.error {
                lastCurrenciesError = error
            }
            // Only show error if it's not a plan limitation (empty currencies is acceptable)
            if viewModel.currencies.isEmpty && (errorMessage.contains("1006") || errorMessage.contains("subscription plan")) {
                // API plan doesn't support this endpoint - show empty state message
                currencies = []
                customView.showEmptyCurrenciesMessage()
                customView.currenciesCollectionView.reloadData()
            } else {
                showErrorActionSheet(for: .currencies)
            }
        } else {
            lastCurrenciesError = nil
            currencies = viewModel.currencies
            if currencies.isEmpty {
                customView.showEmptyCurrenciesMessage()
            }
            customView.currenciesCollectionView.reloadData()
        }
    }
    
    private enum ErrorType {
        case detail
        case currencies
    }
    
    private func showErrorActionSheet(for type: ErrorType) {
        let error = type == .detail ? lastDetailError : lastCurrenciesError
        
        guard let error = error else {
            let alert = UIAlertController(
                title: "Error",
                message: "Failed to load data",
                preferredStyle: .actionSheet
            )
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                self?.loadData()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            if let popover = alert.popoverPresentationController {
                popover.sourceView = view
                popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            present(alert, animated: true)
            return
        }
        
        showError(error) { [weak self] in
            if type == .detail {
                let request = ExchangeDetailModels.LoadDetail.Request()
                self?.interactor.loadDetail(request: request)
            } else {
                let request = ExchangeDetailModels.LoadCurrencies.Request()
                self?.interactor.loadCurrencies(request: request)
            }
        }
    }
    
    private func configureView(with exchange: ExchangeDetailModels.ExchangeDetailViewModel) {
        self.exchange = exchange
        title = exchange.name
        customView.nameLabel.text = exchange.name
        customView.volumeLabel.text = "Volume: \(exchange.volumeFormatted)"
        customView.dateLabel.text = "Launched: \(exchange.dateLaunchedFormatted)"
        customView.idLabel.text = "ID: \(exchange.id)"
        
        // Website URL with hyperlink
        if let websiteURL = exchange.websiteURL, !websiteURL.isEmpty {
            customView.websiteLabel.attributedText = createHyperlink(text: "Website: \(websiteURL)", url: websiteURL)
            customView.websiteLabel.isHidden = false
            
            // Remove previous gesture recognizers
            customView.websiteLabel.gestureRecognizers?.forEach { customView.websiteLabel.removeGestureRecognizer($0) }
            
            // Add tap gesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(websiteTapped(_:)))
            customView.websiteLabel.addGestureRecognizer(tapGesture)
        } else {
            customView.websiteLabel.isHidden = true
        }
        
        // Fees
        if let makerFee = exchange.makerFee {
            customView.makerFeeLabel.text = "Maker Fee: \(String(format: "%.2f", makerFee))%"
            customView.makerFeeLabel.isHidden = false
        } else {
            customView.makerFeeLabel.isHidden = true
        }
        
        if let takerFee = exchange.takerFee {
            customView.takerFeeLabel.text = "Taker Fee: \(String(format: "%.2f", takerFee))%"
            customView.takerFeeLabel.isHidden = false
        } else {
            customView.takerFeeLabel.isHidden = true
        }
        
        // Format description with markdown processing
        if exchange.description.isEmpty {
            customView.aboutTitleLabel.isHidden = true
            customView.descriptionLabel.text = "No description available."
            customView.descriptionLabel.textColor = DSColor.textSecondary
        } else {
            customView.aboutTitleLabel.isHidden = false
            customView.descriptionLabel.attributedText = MarkdownFormatter.attributedString(from: exchange.description)
            customView.descriptionLabel.textColor = DSColor.textPrimary
        }
        
        if let url = URL(string: exchange.logoURL), !exchange.logoURL.isEmpty {
            loadLogoImage(from: url)
        } else {
            customView.logoImageView.image = UIImage(systemName: "building.2.fill")
            customView.logoImageView.tintColor = DSColor.textTertiary
        }
    }
    
    private func createHyperlink(text: String, url: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let urlRange = (text as NSString).range(of: url)
        
        if urlRange.location != NSNotFound {
            attributedString.addAttribute(.link, value: url, range: urlRange)
            attributedString.addAttribute(.foregroundColor, value: DSColor.info, range: urlRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: urlRange)
        }
        
        return attributedString
    }
    
    @objc private func websiteTapped(_ gesture: UITapGestureRecognizer) {
        guard let urlString = exchange?.websiteURL,
              let url = URL(string: urlString) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func loadLogoImage(from url: URL) {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                #if DEBUG
                print("Error loading exchange logo: \(error.localizedDescription)")
                #endif
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data, !data.isEmpty,
                  let image = UIImage(data: data) else {
                #if DEBUG
                print("Failed to load image from: \(url.absoluteString)")
                #endif
                return
            }
            
            DispatchQueue.main.async {
                self.customView.logoImageView.image = image
            }
        }.resume()
    }
}

// MARK: - ExchangesListErrorHandling

extension ExchangeDetailViewController: ExchangesListErrorHandling {}

// MARK: - UICollectionViewDataSource

extension ExchangeDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrencyCollectionViewCell.identifier,
            for: indexPath
        ) as! CurrencyCollectionViewCell
        
        cell.configure(with: currencies[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExchangeDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = DSTheme.Spacing.sm + DSTheme.Spacing.xs
        let totalSpacing = spacing * 3 // left, middle, right
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: DSTheme.Size.cellHeightLarge)
    }
}
