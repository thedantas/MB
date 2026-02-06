//
//  AppContainer.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

final class AppContainer {
    
    // MARK: - Networking
    lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient()
    }()
    
    // MARK: - Services
    lazy var coinMarketCapService: CoinMarketCapService = {
        CoinMarketCapServiceImpl(client: httpClient)
    }()
    
    // MARK: - Use Cases
    lazy var fetchExchangesUseCase: FetchExchangesUseCase = {
        FetchExchangesUseCaseImpl(service: coinMarketCapService)
    }()
    
    lazy var fetchExchangeDetailUseCase: FetchExchangeDetailUseCase = {
        FetchExchangeDetailUseCaseImpl(service: coinMarketCapService)
    }()
    
    lazy var fetchCurrenciesUseCase: FetchCurrenciesUseCase = {
        FetchCurrenciesUseCaseImpl(service: coinMarketCapService)
    }()
}
