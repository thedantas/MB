//
//  ExchangeDetailPresenterTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class ExchangeDetailPresenterTests: XCTestCase {
    
    var sut: ExchangeDetailPresenter!
    var viewSpy: ExchangeDetailDisplayLogicSpy!
    
    override func setUp() {
        super.setUp()
        viewSpy = ExchangeDetailDisplayLogicSpy()
        sut = ExchangeDetailPresenter()
        sut.view = viewSpy
    }
    
    override func tearDown() {
        sut = nil
        viewSpy = nil
        super.tearDown()
    }
    
    func testPresentDetail_WithSuccess_CallsDisplayWithViewModel() {
        // Given
        let exchangeDetail = ExchangeDetail(
            id: 123,
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
        let response = ExchangeDetailModels.LoadDetail.Response(result: .success(exchangeDetail))
        let expectation = expectation(description: "Display called")
        
        // When
        sut.present(response)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewSpy.displayDetailCallCount, 1)
            XCTAssertNotNil(self.viewSpy.lastDetailViewModel)
            XCTAssertNotNil(self.viewSpy.lastDetailViewModel?.exchange)
            XCTAssertEqual(self.viewSpy.lastDetailViewModel?.exchange?.id, 123)
            XCTAssertEqual(self.viewSpy.lastDetailViewModel?.exchange?.name, "Test Exchange")
            XCTAssertEqual(self.viewSpy.lastDetailViewModel?.exchange?.makerFee, 0.1)
            XCTAssertEqual(self.viewSpy.lastDetailViewModel?.exchange?.takerFee, 0.2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresentDetail_WithError_CallsDisplayWithErrorViewModel() {
        // Given
        let error = APIError.network(NSError(domain: "TestError", code: 1))
        let response = ExchangeDetailModels.LoadDetail.Response(result: .failure(error))
        let expectation = expectation(description: "Display called")
        
        // When
        sut.present(response)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewSpy.displayDetailCallCount, 1)
            XCTAssertNotNil(self.viewSpy.lastDetailViewModel)
            XCTAssertNil(self.viewSpy.lastDetailViewModel?.exchange)
            XCTAssertNotNil(self.viewSpy.lastDetailViewModel?.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresentCurrencies_WithSuccess_CallsDisplayWithViewModel() {
        // Given
        let currencies = [
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
        let response = ExchangeDetailModels.LoadCurrencies.Response(result: .success(currencies))
        let expectation = expectation(description: "Display called")
        
        // When
        sut.present(response)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewSpy.displayCurrenciesCallCount, 1)
            XCTAssertNotNil(self.viewSpy.lastCurrenciesViewModel)
            XCTAssertEqual(self.viewSpy.lastCurrenciesViewModel?.currencies.count, 1)
            XCTAssertEqual(self.viewSpy.lastCurrenciesViewModel?.currencies.first?.id, 1)
            XCTAssertEqual(self.viewSpy.lastCurrenciesViewModel?.currencies.first?.name, "Bitcoin")
            XCTAssertEqual(self.viewSpy.lastCurrenciesViewModel?.currencies.first?.priceUSD, 50000.0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresentCurrencies_WithError_CallsDisplayWithErrorViewModel() {
        // Given
        let error = APIError.network(NSError(domain: "TestError", code: 1))
        let response = ExchangeDetailModels.LoadCurrencies.Response(result: .failure(error))
        let expectation = expectation(description: "Display called")
        
        // When
        sut.present(response)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewSpy.displayCurrenciesCallCount, 1)
            XCTAssertNotNil(self.viewSpy.lastCurrenciesViewModel)
            XCTAssertEqual(self.viewSpy.lastCurrenciesViewModel?.currencies.count, 0)
            XCTAssertNotNil(self.viewSpy.lastCurrenciesViewModel?.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresentDetail_FormatsVolumeCorrectly() {
        // Given
        let exchangeDetail = ExchangeDetail(
            id: 1,
            name: "Test",
            slug: "test",
            logoURL: "",
            spotVolumeUSD: 1_500_000_000.0,
            dateLaunched: Date(),
            description: "",
            websiteURL: nil,
            makerFee: nil,
            takerFee: nil
        )
        let response = ExchangeDetailModels.LoadDetail.Response(result: .success(exchangeDetail))
        let expectation = expectation(description: "Display called")
        
        // When
        sut.present(response)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let viewModel = self.viewSpy.lastDetailViewModel,
                  let exchange = viewModel.exchange else {
                XCTFail("ViewModel should not be nil")
                return
            }
            
            XCTAssertEqual(exchange.volumeFormatted, "$1.50B")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
