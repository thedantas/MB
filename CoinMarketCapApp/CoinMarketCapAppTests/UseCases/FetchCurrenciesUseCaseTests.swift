//
//  FetchCurrenciesUseCaseTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class FetchCurrenciesUseCaseTests: XCTestCase {
    
    var sut: FetchCurrenciesUseCaseImpl!
    var mockService: MockCoinMarketCapService!
    
    override func setUp() {
        super.setUp()
        mockService = MockCoinMarketCapService()
        sut = FetchCurrenciesUseCaseImpl(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testExecute_CallsServiceFetchCurrencies() {
        // Given
        let exchangeId = 123
        let expectation = expectation(description: "Completion called")
        
        // When
        sut.execute(exchangeId: exchangeId) { _ in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockService.fetchCurrenciesCallCount, 1)
    }
    
    func testExecute_ReturnsSuccessWithCurrencies() {
        // Given
        let exchangeId = 123
        let mockCurrencies = [
            Currency(
                id: 1,
                name: "Bitcoin",
                symbol: "BTC",
                slug: "bitcoin",
                logoURL: "https://example.com/btc.png",
                dateAdded: Date(),
                priceUSD: 50000.0
            )
        ]
        mockService.mockCurrencies = mockCurrencies
        let expectation = expectation(description: "Completion called")
        var result: Result<[Currency], Error>?
        
        // When
        sut.execute(exchangeId: exchangeId) { res in
            result = res
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(result)
        if case .success(let currencies) = result {
            XCTAssertEqual(currencies.count, 1)
            XCTAssertEqual(currencies.first?.id, 1)
            XCTAssertEqual(currencies.first?.name, "Bitcoin")
            XCTAssertEqual(currencies.first?.priceUSD, 50000.0)
        } else {
            XCTFail("Expected success")
        }
    }
    
    func testExecute_ReturnsErrorWhenServiceFails() {
        // Given
        let exchangeId = 123
        mockService.shouldReturnError = true
        mockService.mockError = NSError(domain: "TestError", code: 1)
        let expectation = expectation(description: "Completion called")
        var result: Result<[Currency], Error>?
        
        // When
        sut.execute(exchangeId: exchangeId) { res in
            result = res
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(result)
        if case .failure(let error) = result {
            XCTAssertNotNil(error)
        } else {
            XCTFail("Expected failure")
        }
    }
}
