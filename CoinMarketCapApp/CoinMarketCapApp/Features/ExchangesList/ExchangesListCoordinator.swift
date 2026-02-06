//
//  ExchangesListCoordinator.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

final class ExchangesListCoordinator {
    
    private let navigationController: UINavigationController
    private let container: AppContainer
    
    init(navigationController: UINavigationController, container: AppContainer = AppContainer()) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let presenter = ExchangesListPresenter()
        let interactor = ExchangesListInteractor(
            useCase: container.fetchExchangesUseCase,
            presenter: presenter
        )
        let viewController = ExchangesListViewController(
            interactor: interactor,
            coordinator: self
        )
        presenter.view = viewController
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func navigateToExchangeDetail(exchangeId: Int) {
        let coordinator = ExchangeDetailCoordinator(
            navigationController: navigationController,
            exchangeId: exchangeId,
            container: container
        )
        coordinator.start()
    }
}
