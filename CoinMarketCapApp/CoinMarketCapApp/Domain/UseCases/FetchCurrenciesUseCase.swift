//
//  FetchCurrenciesUseCase.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

protocol FetchCurrenciesUseCase {
    func execute(exchangeId: Int, completion: @escaping (Result<[Currency], Error>) -> Void)
}

final class FetchCurrenciesUseCaseImpl: FetchCurrenciesUseCase {
    
    private let service: CoinMarketCapService
    
    init(service: CoinMarketCapService) {
        self.service = service
    }
    
    func execute(exchangeId: Int, completion: @escaping (Result<[Currency], Error>) -> Void) {
        service.fetchCurrencies(exchangeId: exchangeId, completion: completion)
    }
}
