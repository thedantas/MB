//
//  FetchExchangesUseCaseMock.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation
@testable import CoinMarketCapApp

final class FetchExchangesUseCaseMock: FetchExchangesUseCase {
    
    var executeCallCount = 0
    var shouldReturnError = false
    var mockExchanges: [Exchange] = []
    var mockError: Error?
    
    func execute(completion: @escaping (Result<[Exchange], Error>) -> Void) {
        executeCallCount += 1
        
        if shouldReturnError {
            completion(.failure(mockError ?? NSError(domain: "TestError", code: 1)))
        } else {
            completion(.success(mockExchanges))
        }
    }
}
