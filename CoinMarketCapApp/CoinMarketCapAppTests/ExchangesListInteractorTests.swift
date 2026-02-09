//
//  ExchangesListInteractorTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 04/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class ExchangesListInteractorTests: XCTestCase {
    
    // Keep strong reference to SUT during async tests
    private var sut: ExchangesListInteractor?
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadExchanges_CallsUseCase() {
        // Given
        let useCaseMock = FetchExchangesUseCaseMock()
        let presenterSpy = ExchangesListPresenterSpy()
        sut = ExchangesListInteractor(
            useCase: useCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangesList.LoadExchanges.Request()
        sut?.loadExchanges(request: request)
        
        // Then
        XCTAssertEqual(useCaseMock.executeCallCount, 1)
    }
    
    func testLoadExchanges_CallsPresenterWithSuccess() {
        // Given
        let useCaseMock = FetchExchangesUseCaseMock()
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
        useCaseMock.mockExchanges = mockExchanges
        
        let expectation = expectation(description: "Presenter called")
        let presenterSpy = ExchangesListPresenterSpy()
        presenterSpy.onPresented = {
            expectation.fulfill()
        }
        
        sut = ExchangesListInteractor(
            useCase: useCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangesList.LoadExchanges.Request()
        sut?.loadExchanges(request: request)
        
        // Then
        // Give a tiny moment for async setup before waiting
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(presenterSpy.didPresent, "Presenter should have been called")
        XCTAssertNotNil(presenterSpy.lastResponse, "Response should not be nil")
        if case .success(let exchanges) = presenterSpy.lastResponse?.result {
            XCTAssertEqual(exchanges.count, 1)
            XCTAssertEqual(exchanges.first?.name, "Test Exchange")
        } else {
            XCTFail("Expected success response, got: \(String(describing: presenterSpy.lastResponse?.result))")
        }
    }
    
    func testLoadExchanges_CallsPresenterWithError() {
        // Given
        let useCaseMock = FetchExchangesUseCaseMock()
        useCaseMock.shouldReturnError = true
        useCaseMock.mockError = NSError(domain: "TestError", code: 1)
        
        let expectation = expectation(description: "Presenter called")
        let presenterSpy = ExchangesListPresenterSpy()
        presenterSpy.onPresented = {
            expectation.fulfill()
        }
        
        sut = ExchangesListInteractor(
            useCase: useCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangesList.LoadExchanges.Request()
        sut?.loadExchanges(request: request)
        
        // Then
        // Give a tiny moment for async setup before waiting
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(presenterSpy.didPresent, "Presenter should have been called")
        XCTAssertNotNil(presenterSpy.lastResponse, "Response should not be nil")
        if case .failure(let error) = presenterSpy.lastResponse?.result {
            XCTAssertNotNil(error)
        } else {
            XCTFail("Expected error response, got: \(String(describing: presenterSpy.lastResponse?.result))")
        }
    }
}

// MARK: - Presenter Spy

final class ExchangesListPresenterSpy: ExchangesListPresenting {
    
    var didPresent = false
    var lastResponse: ExchangesList.LoadExchanges.Response?
    
    // Callback for async testing
    var onPresented: (() -> Void)?
    
    func present(_ response: ExchangesList.LoadExchanges.Response) {
        didPresent = true
        lastResponse = response
        onPresented?()
    }
}
