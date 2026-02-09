//
//  FetchExchangeDetailUseCaseTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class FetchExchangeDetailUseCaseTests: XCTestCase {
    
    var sut: FetchExchangeDetailUseCaseImpl!
    var mockService: MockCoinMarketCapService!
    
    override func setUp() {
        super.setUp()
        mockService = MockCoinMarketCapService()
        sut = FetchExchangeDetailUseCaseImpl(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testExecute_CallsServiceFetchExchangeDetail() {
        // Given
        let exchangeId = 123
        let expectation = expectation(description: "Completion called")
        
        // When
        sut.execute(exchangeId: exchangeId) { _ in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockService.fetchExchangeDetailCallCount, 1)
    }
    
    func testExecute_ReturnsSuccessWithExchangeDetail() {
        // Given
        let exchangeId = 123
        let mockDetail = ExchangeDetail(
            id: exchangeId,
            name: "Test Exchange",
            slug: "test-exchange",
            logoURL: "https://example.com/logo.png",
            spotVolumeUSD: 1000000.0,
            dateLaunched: Date(),
            description: "Test description",
            websiteURL: "https://example.com",
            makerFee: 0.1,
            takerFee: 0.2
        )
        mockService.mockExchangeDetail = mockDetail
        let expectation = expectation(description: "Completion called")
        var result: Result<ExchangeDetail, Error>?
        
        // When
        sut.execute(exchangeId: exchangeId) { res in
            result = res
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(result)
        if case .success(let detail) = result {
            XCTAssertEqual(detail.id, exchangeId)
            XCTAssertEqual(detail.name, "Test Exchange")
            XCTAssertEqual(detail.makerFee, 0.1)
            XCTAssertEqual(detail.takerFee, 0.2)
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
        var result: Result<ExchangeDetail, Error>?
        
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
