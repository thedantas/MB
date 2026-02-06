//
//  ExchangeDetailInteractorTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 04/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class ExchangeDetailInteractorTests: XCTestCase {
    
    func testLoadDetail_CallsUseCase() {
        // Given
        let detailUseCaseMock = FetchExchangeDetailUseCaseMock()
        let currenciesUseCaseMock = FetchCurrenciesUseCaseMock()
        let presenterSpy = ExchangeDetailPresenterSpy()
        let sut = ExchangeDetailInteractor(
            exchangeId: 1,
            fetchDetailUseCase: detailUseCaseMock,
            fetchCurrenciesUseCase: currenciesUseCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangeDetailModels.LoadDetail.Request()
        sut.loadDetail(request: request)
        
        // Then
        XCTAssertEqual(detailUseCaseMock.executeCallCount, 1)
        XCTAssertEqual(detailUseCaseMock.lastExchangeId, 1)
    }
    
    func testLoadCurrencies_CallsUseCase() {
        // Given
        let detailUseCaseMock = FetchExchangeDetailUseCaseMock()
        let currenciesUseCaseMock = FetchCurrenciesUseCaseMock()
        let presenterSpy = ExchangeDetailPresenterSpy()
        let sut = ExchangeDetailInteractor(
            exchangeId: 1,
            fetchDetailUseCase: detailUseCaseMock,
            fetchCurrenciesUseCase: currenciesUseCaseMock,
            presenter: presenterSpy
        )
        
        // When
        let request = ExchangeDetailModels.LoadCurrencies.Request()
        sut.loadCurrencies(request: request)
        
        // Then
        XCTAssertEqual(currenciesUseCaseMock.executeCallCount, 1)
        XCTAssertEqual(currenciesUseCaseMock.lastExchangeId, 1)
    }
}

// MARK: - Mocks

final class FetchExchangeDetailUseCaseMock: FetchExchangeDetailUseCase {
    
    var executeCallCount = 0
    var lastExchangeId: Int?
    var shouldReturnError = false
    var mockExchangeDetail: ExchangeDetail?
    var mockError: Error?
    
    func execute(exchangeId: Int, completion: @escaping (Result<ExchangeDetail, Error>) -> Void) {
        executeCallCount += 1
        lastExchangeId = exchangeId
        
        if shouldReturnError {
            completion(.failure(mockError ?? NSError(domain: "TestError", code: 1)))
        } else if let mockExchangeDetail = mockExchangeDetail {
            completion(.success(mockExchangeDetail))
        } else {
            completion(.failure(NSError(domain: "TestError", code: 1)))
        }
    }
}

final class FetchCurrenciesUseCaseMock: FetchCurrenciesUseCase {
    
    var executeCallCount = 0
    var lastExchangeId: Int?
    var shouldReturnError = false
    var mockCurrencies: [Currency] = []
    var mockError: Error?
    
    func execute(exchangeId: Int, completion: @escaping (Result<[Currency], Error>) -> Void) {
        executeCallCount += 1
        lastExchangeId = exchangeId
        
        if shouldReturnError {
            completion(.failure(mockError ?? NSError(domain: "TestError", code: 1)))
        } else {
            completion(.success(mockCurrencies))
        }
    }
}

final class ExchangeDetailPresenterSpy: ExchangeDetailPresenting {
    
    var didPresentDetail = false
    var didPresentCurrencies = false
    var lastDetailResponse: ExchangeDetailModels.LoadDetail.Response?
    var lastCurrenciesResponse: ExchangeDetailModels.LoadCurrencies.Response?
    
    func present(_ response: ExchangeDetailModels.LoadDetail.Response) {
        didPresentDetail = true
        lastDetailResponse = response
    }
    
    func present(_ response: ExchangeDetailModels.LoadCurrencies.Response) {
        didPresentCurrencies = true
        lastCurrenciesResponse = response
    }
}
