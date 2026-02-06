//
//  ExchangesListInteractor.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

protocol ExchangesListBusinessLogic {
    func loadExchanges(request: ExchangesList.LoadExchanges.Request)
}

final class ExchangesListInteractor: ExchangesListBusinessLogic {
    
    private let useCase: FetchExchangesUseCase
    private let presenter: ExchangesListPresenting
    
    init(useCase: FetchExchangesUseCase, presenter: ExchangesListPresenting) {
        self.useCase = useCase
        self.presenter = presenter
    }
    
    func loadExchanges(request: ExchangesList.LoadExchanges.Request) {
        useCase.execute { [weak self] result in
            let response = ExchangesList.LoadExchanges.Response(result: result)
            self?.presenter.present(response)
        }
    }
}
