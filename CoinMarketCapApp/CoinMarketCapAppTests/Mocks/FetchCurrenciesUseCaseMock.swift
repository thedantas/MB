//
//  FetchCurrenciesUseCaseMock.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import Foundation
@testable import CoinMarketCapApp

final class FetchCurrenciesUseCaseMock: FetchCurrenciesUseCase {
    
    var executeCallCount = 0
    var executeExchangeId: Int?
    var shouldReturnError = false
    var mockCurrencies: [Currency] = []
    var mockError: Error?
    
    func execute(exchangeId: Int, completion: @escaping (Result<[Currency], Error>) -> Void) {
        executeCallCount += 1
        executeExchangeId = exchangeId
        
        // Call completion asynchronously to simulate real behavior
        // Use a small delay to ensure the interactor has time to set up the closure
        // Note: We capture self strongly here because the mock lives for the duration of the test
        let shouldReturnError = self.shouldReturnError
        let mockError = self.mockError
        let mockCurrencies = self.mockCurrencies
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if shouldReturnError {
                completion(.failure(mockError ?? NSError(domain: "TestError", code: 1)))
            } else {
                completion(.success(mockCurrencies))
            }
        }
    }
}
