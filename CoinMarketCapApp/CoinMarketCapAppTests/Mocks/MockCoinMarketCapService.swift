//
//  MockCoinMarketCapService.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import Foundation
@testable import CoinMarketCapApp

final class MockCoinMarketCapService: CoinMarketCapService {
    
    var fetchExchangesCallCount = 0
    var fetchExchangeDetailCallCount = 0
    var fetchCurrenciesCallCount = 0
    
    var shouldReturnError = false
    var mockError: Error?
    
    var mockExchanges: [Exchange] = []
    var mockExchangeDetail: ExchangeDetail?
    var mockCurrencies: [Currency] = []
    
    func fetchExchanges(completion: @escaping (Result<[Exchange], Error>) -> Void) {
        fetchExchangesCallCount += 1
        
        if shouldReturnError {
            completion(.failure(mockError ?? NSError(domain: "TestError", code: 1)))
        } else {
            completion(.success(mockExchanges))
        }
    }
    
    func fetchExchangeDetail(exchangeId: Int, completion: @escaping (Result<ExchangeDetail, Error>) -> Void) {
        fetchExchangeDetailCallCount += 1
        
        if shouldReturnError {
            completion(.failure(mockError ?? NSError(domain: "TestError", code: 1)))
        } else if let detail = mockExchangeDetail {
            completion(.success(detail))
        } else {
            completion(.failure(NSError(domain: "TestError", code: 404)))
        }
    }
    
    func fetchCurrencies(exchangeId: Int, completion: @escaping (Result<[Currency], Error>) -> Void) {
        fetchCurrenciesCallCount += 1
        
        if shouldReturnError {
            completion(.failure(mockError ?? NSError(domain: "TestError", code: 1)))
        } else {
            completion(.success(mockCurrencies))
        }
    }
}
