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
    var responses: [Any] = []
    var errors: [APIError] = []
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        requestCallCount += 1
        requestEndpoint = endpoint
        
        let index = requestCallCount - 1
        
        // If using sequential errors, check errors first (for fallback scenarios)
        if !errors.isEmpty {
            if index < errors.count {
                completion(.failure(errors[index]))
                return
            }
        }
        
        // If using sequential responses
        if !responses.isEmpty {
            if index < responses.count, let response = responses[index] as? T {
                completion(.success(response))
                return
            }
        }
        
        // Default behavior
        if shouldReturnError {
            completion(.failure(mockError))
        } else if let mockData = mockData as? T {
            completion(.success(mockData))
        } else {
            completion(.failure(.noData))
        }
    }
}
