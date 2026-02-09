//
//  EndpointTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class EndpointTests: XCTestCase {
    
    func testUrlRequest_ContainsCorrectBaseURL() {
        // Given
        let endpoint = Endpoint(path: "/v1/test", queryItems: [])
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request.url)
        XCTAssertTrue(request.url?.absoluteString.contains("pro-api.coinmarketcap.com") ?? false)
        XCTAssertTrue(request.url?.absoluteString.contains("/v1/test") ?? false)
    }
    
    func testUrlRequest_IncludesQueryItems() {
        // Given
        let queryItems = [
            URLQueryItem(name: "sort", value: "volume"),
            URLQueryItem(name: "limit", value: "100")
        ]
        let endpoint = Endpoint(path: "/v1/test", queryItems: queryItems)
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request.url)
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        XCTAssertEqual(components?.queryItems?.count, 2)
    }
    
    func testUrlRequest_SetsCorrectHTTPMethod() {
        // Given
        let endpoint = Endpoint(path: "/v1/test", queryItems: [])
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testUrlRequest_IncludesAcceptHeader() {
        // Given
        let endpoint = Endpoint(path: "/v1/test", queryItems: [])
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
    }
}
