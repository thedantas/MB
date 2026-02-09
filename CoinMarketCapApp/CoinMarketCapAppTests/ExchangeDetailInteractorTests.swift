//
//  ExchangeDetailInteractorTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 04/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class ExchangeDetailInteractorTests: XCTestCase {
    
    // Keep strong reference to SUT during async tests
    private var sut: ExchangeDetailInteractor?
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadDetail_CallsUseCase() {
        // Given
        let detailUseCaseMock = FetchExchangeDetailUseCaseMock()
        let currenciesUseCaseMock = FetchCurrenciesUseCaseMock()
        let presenterSpy = ExchangeDetailPresenterSpy()
        sut = ExchangeDetailInteractor(
            exchangeId: 1,
            fetchDetailUseCase: detailUseCaseMock,
            fetchCurrenciesUseCase: currenciesUseCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangeDetailModels.LoadDetail.Request()
        sut?.loadDetail(request: request)
        
        // Then
        XCTAssertEqual(detailUseCaseMock.executeCallCount, 1)
        XCTAssertEqual(detailUseCaseMock.executeExchangeId, 1)
    }
    
    func testLoadDetail_CallsPresenterWithSuccess() {
        // Given
        let detailUseCaseMock = FetchExchangeDetailUseCaseMock()
        let mockDetail = ExchangeDetail(
            id: 1,
            name: "Test Exchange",
            slug: "test",
            logoURL: "",
            spotVolumeUSD: 0,
            dateLaunched: Date(),
            description: "",
            websiteURL: nil,
            makerFee: nil,
            takerFee: nil
        )
        detailUseCaseMock.mockExchangeDetail = mockDetail
        
        let currenciesUseCaseMock = FetchCurrenciesUseCaseMock()
        let expectation = expectation(description: "Presenter called")
        let presenterSpy = ExchangeDetailPresenterSpy()
        presenterSpy.onDetailPresented = {
            expectation.fulfill()
        }
        
        sut = ExchangeDetailInteractor(
            exchangeId: 1,
            fetchDetailUseCase: detailUseCaseMock,
            fetchCurrenciesUseCase: currenciesUseCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangeDetailModels.LoadDetail.Request()
        sut?.loadDetail(request: request)
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(presenterSpy.didPresentDetail, "Presenter should have been called")
        XCTAssertNotNil(presenterSpy.lastDetailResponse, "Response should not be nil")
        if case .success(let detail) = presenterSpy.lastDetailResponse?.result {
            XCTAssertEqual(detail.id, 1)
            XCTAssertEqual(detail.name, "Test Exchange")
        } else {
            XCTFail("Expected success response, got: \(String(describing: presenterSpy.lastDetailResponse?.result))")
        }
    }
    
    func testLoadDetail_CallsPresenterWithError() {
        // Given
        let detailUseCaseMock = FetchExchangeDetailUseCaseMock()
        detailUseCaseMock.shouldReturnError = true
        detailUseCaseMock.mockError = NSError(domain: "TestError", code: 1)
        
        let currenciesUseCaseMock = FetchCurrenciesUseCaseMock()
        let expectation = expectation(description: "Presenter called")
        let presenterSpy = ExchangeDetailPresenterSpy()
        presenterSpy.onDetailPresented = {
            expectation.fulfill()
        }
        
        sut = ExchangeDetailInteractor(
            exchangeId: 1,
            fetchDetailUseCase: detailUseCaseMock,
            fetchCurrenciesUseCase: currenciesUseCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangeDetailModels.LoadDetail.Request()
        sut?.loadDetail(request: request)
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(presenterSpy.didPresentDetail)
        XCTAssertNotNil(presenterSpy.lastDetailResponse)
        if case .failure(let error) = presenterSpy.lastDetailResponse?.result {
            XCTAssertNotNil(error)
        } else {
            XCTFail("Expected error response")
        }
    }
    
    func testLoadCurrencies_CallsUseCase() {
        // Given
        let detailUseCaseMock = FetchExchangeDetailUseCaseMock()
        let currenciesUseCaseMock = FetchCurrenciesUseCaseMock()
        let presenterSpy = ExchangeDetailPresenterSpy()
        sut = ExchangeDetailInteractor(
            exchangeId: 1,
            fetchDetailUseCase: detailUseCaseMock,
            fetchCurrenciesUseCase: currenciesUseCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangeDetailModels.LoadCurrencies.Request()
        sut?.loadCurrencies(request: request)
        
        // Then
        XCTAssertEqual(currenciesUseCaseMock.executeCallCount, 1)
        XCTAssertEqual(currenciesUseCaseMock.executeExchangeId, 1)
    }
    
    func testLoadCurrencies_CallsPresenterWithSuccess() {
        // Given
        let detailUseCaseMock = FetchExchangeDetailUseCaseMock()
        let currenciesUseCaseMock = FetchCurrenciesUseCaseMock()
        currenciesUseCaseMock.mockCurrencies = [
            Currency(id: 1, name: "Bitcoin", symbol: "BTC", slug: "bitcoin", logoURL: "", dateAdded: Date(), priceUSD: 50000.0)
        ]
        
        let expectation = expectation(description: "Presenter called")
        let presenterSpy = ExchangeDetailPresenterSpy()
        presenterSpy.onCurrenciesPresented = {
            expectation.fulfill()
        }
        
        sut = ExchangeDetailInteractor(
            exchangeId: 1,
            fetchDetailUseCase: detailUseCaseMock,
            fetchCurrenciesUseCase: currenciesUseCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangeDetailModels.LoadCurrencies.Request()
        sut?.loadCurrencies(request: request)
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(presenterSpy.didPresentCurrencies, "Presenter should have been called")
        XCTAssertNotNil(presenterSpy.lastCurrenciesResponse, "Response should not be nil")
        if case .success(let currencies) = presenterSpy.lastCurrenciesResponse?.result {
            XCTAssertEqual(currencies.count, 1)
            XCTAssertEqual(currencies.first?.name, "Bitcoin")
        } else {
            XCTFail("Expected success response, got: \(String(describing: presenterSpy.lastCurrenciesResponse?.result))")
        }
    }
    
    func testLoadCurrencies_CallsPresenterWithError() {
        // Given
        let detailUseCaseMock = FetchExchangeDetailUseCaseMock()
        let currenciesUseCaseMock = FetchCurrenciesUseCaseMock()
        currenciesUseCaseMock.shouldReturnError = true
        currenciesUseCaseMock.mockError = NSError(domain: "TestError", code: 1)
        
        let expectation = expectation(description: "Presenter called")
        let presenterSpy = ExchangeDetailPresenterSpy()
        presenterSpy.onCurrenciesPresented = {
            expectation.fulfill()
        }
        
        sut = ExchangeDetailInteractor(
            exchangeId: 1,
            fetchDetailUseCase: detailUseCaseMock,
            fetchCurrenciesUseCase: currenciesUseCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangeDetailModels.LoadCurrencies.Request()
        sut?.loadCurrencies(request: request)
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(presenterSpy.didPresentCurrencies)
        XCTAssertNotNil(presenterSpy.lastCurrenciesResponse)
        if case .failure(let error) = presenterSpy.lastCurrenciesResponse?.result {
            XCTAssertNotNil(error)
        } else {
            XCTFail("Expected error response")
        }
    }
}

// MARK: - Presenter Spy

final class ExchangeDetailPresenterSpy: ExchangeDetailPresenting {
    
    var didPresentDetail = false
    var didPresentCurrencies = false
    var lastDetailResponse: ExchangeDetailModels.LoadDetail.Response?
    var lastCurrenciesResponse: ExchangeDetailModels.LoadCurrencies.Response?
    
    // Callbacks for async testing
    var onDetailPresented: (() -> Void)?
    var onCurrenciesPresented: (() -> Void)?
    
    func present(_ response: ExchangeDetailModels.LoadDetail.Response) {
        didPresentDetail = true
        lastDetailResponse = response
        onDetailPresented?()
    }
    
    func present(_ response: ExchangeDetailModels.LoadCurrencies.Response) {
        didPresentCurrencies = true
        lastCurrenciesResponse = response
        onCurrenciesPresented?()
    }
}
