//
//  AppCoordinator.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private let container = AppContainer()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let coordinator = ExchangesListCoordinator(
            navigationController: navigationController,
            container: container
        )
        coordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
