//
//  ExchangeDetailCoordinator.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

final class ExchangeDetailCoordinator {
    
    private let navigationController: UINavigationController
    private let exchangeId: Int
    private let container: AppContainer
    
    init(
        navigationController: UINavigationController,
        exchangeId: Int,
        container: AppContainer = AppContainer()
    ) {
        self.navigationController = navigationController
        self.exchangeId = exchangeId
        self.container = container
    }
    
    func start() {
        let presenter = ExchangeDetailPresenter()
        let interactor = ExchangeDetailInteractor(
            exchangeId: exchangeId,
            fetchDetailUseCase: container.fetchExchangeDetailUseCase,
            fetchCurrenciesUseCase: container.fetchCurrenciesUseCase,
            presenter: presenter
        )
        let viewController = ExchangeDetailViewController(interactor: interactor)
        presenter.view = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}
