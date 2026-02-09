//
//  CoinMarketCapServiceTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class CoinMarketCapServiceTests: XCTestCase {
    
    var sut: CoinMarketCapServiceImpl!
    var mockClient: MockHTTPClient!
    
    override func setUp() {
        super.setUp()
        mockClient = MockHTTPClient()
        sut = CoinMarketCapServiceImpl(client: mockClient)
    }
    
    override func tearDown() {
        sut = nil
        mockClient = nil
        super.tearDown()
    }
    
    func testFetchExchanges_CallsClientWithCorrectEndpoint() {
        // Given
        let expectation = expectation(description: "Completion called")
        
        // When
        sut.fetchExchanges { _ in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockClient.requestCallCount, 1)
        XCTAssertNotNil(mockClient.requestEndpoint)
        XCTAssertTrue(mockClient.requestEndpoint?.path.contains("listings/latest") ?? false)
    }
    
    func testFetchExchanges_WithSuccess_ReturnsExchanges() {
        // Given
        let jsonString = """
        {
            "data": [
                {
                    "id": 1,
                    "name": "Test Exchange",
                    "slug": "test-exchange",
                    "date_launched": "2020-01-01T00:00:00.000Z",
                    "spot_volume_usd": 1000000.0
                }
            ],
            "status": {
                "timestamp": "2020-01-01T00:00:00.000Z",
                "error_code": 0,
                "error_message": null
            }
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        // Create decoder in nonisolated context to avoid MainActor warnings
        let decoder = JSONDecoder()
        let mockResponse = try! decoder.decode(ExchangeResponseDTO.self, from: jsonData)
        mockClient.mockData = mockResponse
        let expectation = expectation(description: "Completion called")
        var result: Result<[Exchange], Error>?
        
        // When
        sut.fetchExchanges { res in
            result = res
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        if case .success(let exchanges) = result {
            XCTAssertEqual(exchanges.count, 1)
            XCTAssertEqual(exchanges.first?.id, 1)
        } else {
            XCTFail("Expected success")
        }
    }
    
    func testFetchExchanges_WithError1006_FallsBackToMapEndpoint() {
        // Given
        // Mock fallback response
        let fallbackJsonString = """
        {
            "data": [
                {
                    "id": 1,
                    "name": "Test Exchange",
                    "slug": "test-exchange"
                }
            ],
            "status": {
                "timestamp": "2020-01-01T00:00:00.000Z",
                "error_code": 0,
                "error_message": null
            }
        }
        """
        let fallbackJsonData = fallbackJsonString.data(using: .utf8)!
        // Create decoder in nonisolated context to avoid MainActor warnings
        let decoder = JSONDecoder()
        let fallbackResponse = try! decoder.decode(ExchangeResponseDTO.self, from: fallbackJsonData)
        
        // Configure mock to return error 1006 first, then success on fallback
        // Important: errors array is checked first in MockHTTPClient, so this will return error on first call
        mockClient.errors = [APIError.apiError(code: 1006, message: "Subscription plan doesn't support this endpoint")]
        mockClient.responses = [fallbackResponse]
        
        let expectation = expectation(description: "Completion called")
        
        // When
        sut.fetchExchanges { result in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 3.0)
        // Verify that fallback was attempted (should have 2 calls: first fails, fallback succeeds)
        XCTAssertGreaterThanOrEqual(mockClient.requestCallCount, 2, "Expected at least 2 calls (initial + fallback)")
    }
    
    func testFetchExchangeDetail_CallsClientWithCorrectEndpoint() {
        // Given
        let exchangeId = 123
        let expectation = expectation(description: "Completion called")
        
        // When
        sut.fetchExchangeDetail(exchangeId: exchangeId) { _ in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockClient.requestCallCount, 1)
        XCTAssertNotNil(mockClient.requestEndpoint)
        XCTAssertTrue(mockClient.requestEndpoint?.path.contains("exchange/info") ?? false)
    }
    
    func testFetchCurrencies_CallsClientWithCorrectEndpoint() {
        // Given
        let exchangeId = 123
        let expectation = expectation(description: "Completion called")
        
        // When
        sut.fetchCurrencies(exchangeId: exchangeId) { _ in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockClient.requestCallCount, 1)
        XCTAssertNotNil(mockClient.requestEndpoint)
        XCTAssertTrue(mockClient.requestEndpoint?.path.contains("market-pairs") ?? false)
    }
}
