//
//  FetchExchangeDetailUseCase.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

protocol FetchExchangeDetailUseCase {
    func execute(exchangeId: Int, completion: @escaping (Result<ExchangeDetail, Error>) -> Void)
}

final class FetchExchangeDetailUseCaseImpl: FetchExchangeDetailUseCase {
    
    private let service: CoinMarketCapService
    
    init(service: CoinMarketCapService) {
        self.service = service
    }
    
    func execute(exchangeId: Int, completion: @escaping (Result<ExchangeDetail, Error>) -> Void) {
        service.fetchExchangeDetail(exchangeId: exchangeId, completion: completion)
    }
}
