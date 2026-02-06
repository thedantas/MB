//
//  ExchangeDetailInteractor.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

protocol ExchangeDetailBusinessLogic {
    func loadDetail(request: ExchangeDetailModels.LoadDetail.Request)
    func loadCurrencies(request: ExchangeDetailModels.LoadCurrencies.Request)
}

final class ExchangeDetailInteractor: ExchangeDetailBusinessLogic {
    
    private let exchangeId: Int
    private let fetchDetailUseCase: FetchExchangeDetailUseCase
    private let fetchCurrenciesUseCase: FetchCurrenciesUseCase
    private let presenter: ExchangeDetailPresenting
    
    init(
        exchangeId: Int,
        fetchDetailUseCase: FetchExchangeDetailUseCase,
        fetchCurrenciesUseCase: FetchCurrenciesUseCase,
        presenter: ExchangeDetailPresenting
    ) {
        self.exchangeId = exchangeId
        self.fetchDetailUseCase = fetchDetailUseCase
        self.fetchCurrenciesUseCase = fetchCurrenciesUseCase
        self.presenter = presenter
    }
    
    func loadDetail(request: ExchangeDetailModels.LoadDetail.Request) {
        fetchDetailUseCase.execute(exchangeId: exchangeId) { [weak self] result in
            let response = ExchangeDetailModels.LoadDetail.Response(result: result)
            self?.presenter.present(response)
        }
    }
    
    func loadCurrencies(request: ExchangeDetailModels.LoadCurrencies.Request) {
        fetchCurrenciesUseCase.execute(exchangeId: exchangeId) { [weak self] result in
            let response = ExchangeDetailModels.LoadCurrencies.Response(result: result)
            self?.presenter.present(response)
        }
    }
}
