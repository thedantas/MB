//
//  ExchangesListViewController.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

protocol ExchangesListDisplayLogic: AnyObject {
    func display(_ viewModel: ExchangesList.LoadExchanges.ViewModel)
}

final class ExchangesListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let interactor: ExchangesListBusinessLogic
    private let coordinator: ExchangesListCoordinator
    private var allExchanges: [ExchangesList.ExchangeViewModel] = []
    private var filteredExchanges: [ExchangesList.ExchangeViewModel] = []
    private var lastError: Error?
    private var isLoading = false
    
    private var exchanges: [ExchangesList.ExchangeViewModel] {
        return filteredExchanges.isEmpty && !isSearching ? allExchanges : filteredExchanges
    }
    
    private var isSearching: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    // MARK: - Search
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search exchanges..."
        controller.searchBar.delegate = self
        return controller
    }()
    
    // MARK: - UI Components
    
    private lazy var customView: ExchangesListView = {
        let view = ExchangesListView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    // MARK: - Initialization
    
    init(
        interactor: ExchangesListBusinessLogic,
        coordinator: ExchangesListCoordinator
    ) {
        self.interactor = interactor
        self.coordinator = coordinator
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
        loadExchanges()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = LocalizedKey.exchanges.localized

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    // MARK: - Actions
    
    private func loadExchanges() {
        isLoading = true
        customView.showShimmerLoading()
        let request = ExchangesList.LoadExchanges.Request()
        interactor.loadExchanges(request: request)
    }
    
    private func filterExchanges(with searchText: String) {
        if searchText.isEmpty {
            filteredExchanges = []
        } else {
            filteredExchanges = allExchanges.filter { exchange in
                exchange.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        updateUI()
    }
    
    private func updateUI() {
        customView.tableView.reloadData()
        
        if exchanges.isEmpty && !isLoading {
            if isSearching {
                customView.showEmptyState()
            } else {
                customView.hideEmptyState()
            }
        } else {
            customView.hideEmptyState()
        }
    }
}

// MARK: - ExchangesListDisplayLogic

extension ExchangesListViewController: ExchangesListDisplayLogic {
    
    func display(_ viewModel: ExchangesList.LoadExchanges.ViewModel) {
        isLoading = false
        customView.hideShimmerLoading()
        
        if let errorMessage = viewModel.errorMessage {
            if let error = viewModel.error {
                lastError = error
            }
            customView.showError(errorMessage)
            showErrorActionSheet()
        } else {
            customView.hideError()
            lastError = nil
            allExchanges = viewModel.exchanges
            
            if isSearching, let searchText = searchController.searchBar.text {
                filterExchanges(with: searchText)
            } else {
                updateUI()
            }
        }
    }
    
    private func showErrorActionSheet() {
        guard let error = lastError else {
            let alert = UIAlertController(
                title: LocalizedKey.error.localized,
                message: LocalizedKey.failedToLoadExchanges.localized,
                preferredStyle: .actionSheet
            )
            alert.addAction(UIAlertAction(title: LocalizedKey.retry.localized, style: .default) { [weak self] _ in
                self?.loadExchanges()
            })
            alert.addAction(UIAlertAction(title: LocalizedKey.cancel.localized, style: .cancel))
            
            if let popover = alert.popoverPresentationController {
                popover.sourceView = view
                popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            present(alert, animated: true)
            return
        }
        
        showError(error) { [weak self] in
            self?.loadExchanges()
        }
    }
}

// MARK: - ExchangesListErrorHandling

extension ExchangesListViewController: ExchangesListErrorHandling {}

// MARK: - UITableViewDataSource

extension ExchangesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 10
        }
        return exchanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ShimmerTableViewCell.identifier,
                for: indexPath
            ) as! ShimmerTableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ExchangeTableViewCell.identifier,
            for: indexPath
        ) as! ExchangeTableViewCell
        
        cell.configure(with: exchanges[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ExchangesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !isLoading else { return }
        let exchangeViewModel = exchanges[indexPath.row]
        coordinator.navigateToExchangeDetail(exchangeId: exchangeViewModel.id)
    }
}

// MARK: - UISearchResultsUpdating

extension ExchangesListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterExchanges(with: searchText)
    }
}

// MARK: - UISearchBarDelegate

extension ExchangesListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredExchanges = []
        updateUI()
    }
}
