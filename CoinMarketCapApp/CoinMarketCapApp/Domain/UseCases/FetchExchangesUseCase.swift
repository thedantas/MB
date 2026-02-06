//
//  FetchExchangesUseCase.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

protocol FetchExchangesUseCase {
    func execute(completion: @escaping (Result<[Exchange], Error>) -> Void)
}

final class FetchExchangesUseCaseImpl: FetchExchangesUseCase {
    
    private let service: CoinMarketCapService
    
    init(service: CoinMarketCapService) {
        self.service = service
    }
    
    func execute(completion: @escaping (Result<[Exchange], Error>) -> Void) {
        service.fetchExchanges(completion: completion)
    }
}
