//
//  ExchangesListInteractorTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 04/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class ExchangesListInteractorTests: XCTestCase {
    
    func testLoadExchanges_CallsUseCase() {
        // Given
        let useCaseMock = FetchExchangesUseCaseMock()
        let presenterSpy = ExchangesListPresenterSpy()
        let sut = ExchangesListInteractor(
            useCase: useCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangesList.LoadExchanges.Request()
        sut.loadExchanges(request: request)
        
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
        
        let presenterSpy = ExchangesListPresenterSpy()
        let sut = ExchangesListInteractor(
            useCase: useCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangesList.LoadExchanges.Request()
        sut.loadExchanges(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.didPresent)
        XCTAssertNotNil(presenterSpy.lastResponse)
    }
    
    func testLoadExchanges_CallsPresenterWithError() {
        // Given
        let useCaseMock = FetchExchangesUseCaseMock()
        useCaseMock.shouldReturnError = true
        useCaseMock.mockError = NSError(domain: "TestError", code: 1)
        
        let presenterSpy = ExchangesListPresenterSpy()
        let sut = ExchangesListInteractor(
            useCase: useCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangesList.LoadExchanges.Request()
        sut.loadExchanges(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.didPresent)
        XCTAssertNotNil(presenterSpy.lastResponse)
    }
}

// MARK: - Presenter Spy

final class ExchangesListPresenterSpy: ExchangesListPresenting {
    
    var didPresent = false
    var lastResponse: ExchangesList.LoadExchanges.Response?
    
    func present(_ response: ExchangesList.LoadExchanges.Response) {
        didPresent = true
        lastResponse = response
    }
}
