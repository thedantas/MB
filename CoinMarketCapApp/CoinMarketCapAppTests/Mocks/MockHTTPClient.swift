//
//  MockHTTPClient.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation
@testable import CoinMarketCapApp

final class MockHTTPClient: HTTPClient {
    
    var requestCallCount = 0
    var requestEndpoint: Endpoint?
    var shouldReturnError = false
    var mockError: APIError = .noData
    var mockData: Any?
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        requestCallCount += 1
        requestEndpoint = endpoint
        
        if shouldReturnError {
            completion(.failure(mockError))
        } else if let mockData = mockData as? T {
            completion(.success(mockData))
        } else {
            completion(.failure(.noData))
        }
    }
}
