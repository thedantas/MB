//
//  FetchExchangesUseCaseTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class FetchExchangesUseCaseTests: XCTestCase {
    
    var sut: FetchExchangesUseCaseImpl!
    var mockService: MockCoinMarketCapService!
    
    override func setUp() {
        super.setUp()
        mockService = MockCoinMarketCapService()
        sut = FetchExchangesUseCaseImpl(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testExecute_CallsServiceFetchExchanges() {
        // Given
        let expectation = expectation(description: "Completion called")
        
        // When
        sut.execute { _ in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockService.fetchExchangesCallCount, 1)
    }
    
    func testExecute_ReturnsSuccessWithExchanges() {
        // Given
        let mockExchanges = [
            Exchange(
                id: 1,
                name: "Test Exchange",
                slug: "test-exchange",
                logoURL: "https://example.com/logo.png",
                spotVolumeUSD: 1000000.0,
                dateLaunched: Date()
            )
        ]
        mockService.mockExchanges = mockExchanges
        let expectation = expectation(description: "Completion called")
        var result: Result<[Exchange], Error>?
        
        // When
        sut.execute { res in
            result = res
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(result)
        if case .success(let exchanges) = result {
            XCTAssertEqual(exchanges.count, 1)
            XCTAssertEqual(exchanges.first?.id, 1)
            XCTAssertEqual(exchanges.first?.name, "Test Exchange")
        } else {
            XCTFail("Expected success")
        }
    }
    
    func testExecute_ReturnsErrorWhenServiceFails() {
        // Given
        mockService.shouldReturnError = true
        mockService.mockError = NSError(domain: "TestError", code: 1)
        let expectation = expectation(description: "Completion called")
        var result: Result<[Exchange], Error>?
        
        // When
        sut.execute { res in
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
