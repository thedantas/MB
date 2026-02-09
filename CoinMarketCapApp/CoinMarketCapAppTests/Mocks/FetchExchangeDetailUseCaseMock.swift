//
//  FetchExchangeDetailUseCaseMock.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import Foundation
@testable import CoinMarketCapApp

final class FetchExchangeDetailUseCaseMock: FetchExchangeDetailUseCase {
    
    var executeCallCount = 0
    var executeExchangeId: Int?
    var shouldReturnError = false
    var mockExchangeDetail: ExchangeDetail?
    var mockError: Error?
    
    func execute(exchangeId: Int, completion: @escaping (Result<ExchangeDetail, Error>) -> Void) {
        executeCallCount += 1
        executeExchangeId = exchangeId
        
        // Call completion asynchronously to simulate real behavior
        // Use a small delay to ensure the interactor has time to set up the closure
        // Note: We capture values instead of self to avoid retain cycles
        let shouldReturnError = self.shouldReturnError
        let mockError = self.mockError
        let mockExchangeDetail = self.mockExchangeDetail
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if shouldReturnError {
                completion(.failure(mockError ?? NSError(domain: "TestError", code: 1)))
            } else if let detail = mockExchangeDetail {
                completion(.success(detail))
            } else {
                completion(.failure(NSError(domain: "TestError", code: 404)))
            }
        }
    }
}
