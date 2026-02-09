//
//  ExchangesListPresenterTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class ExchangesListPresenterTests: XCTestCase {
    
    var sut: ExchangesListPresenter!
    var viewSpy: ExchangesListDisplayLogicSpy!
    
    override func setUp() {
        super.setUp()
        viewSpy = ExchangesListDisplayLogicSpy()
        sut = ExchangesListPresenter()
        sut.view = viewSpy
    }
    
    override func tearDown() {
        sut = nil
        viewSpy = nil
        super.tearDown()
    }
    
    func testPresent_WithSuccess_CallsDisplayWithViewModel() {
        // Given
        let exchanges = [
            Exchange(
                id: 1,
                name: "Test Exchange",
                slug: "test-exchange",
                logoURL: "https://example.com/logo.png",
                spotVolumeUSD: 1000000.0,
                dateLaunched: Date()
            )
        ]
        let response = ExchangesList.LoadExchanges.Response(result: .success(exchanges))
        let expectation = expectation(description: "Display called")
        
        // When
        sut.present(response)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewSpy.displayCallCount, 1)
            XCTAssertNotNil(self.viewSpy.lastViewModel)
            XCTAssertNil(self.viewSpy.lastViewModel?.errorMessage)
            XCTAssertEqual(self.viewSpy.lastViewModel?.exchanges.count, 1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresent_WithError_CallsDisplayWithErrorViewModel() {
        // Given
        let error = APIError.network(NSError(domain: "TestError", code: 1))
        let response = ExchangesList.LoadExchanges.Response(result: .failure(error))
        let expectation = expectation(description: "Display called")
        
        // When
        sut.present(response)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewSpy.displayCallCount, 1)
            XCTAssertNotNil(self.viewSpy.lastViewModel)
            XCTAssertNotNil(self.viewSpy.lastViewModel?.errorMessage)
            XCTAssertEqual(self.viewSpy.lastViewModel?.exchanges.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresent_FormatsVolumeCorrectly() {
        // Given
        let exchanges = [
            Exchange(id: 1, name: "Test", slug: "test", logoURL: "", spotVolumeUSD: 1_500_000_000.0, dateLaunched: Date()),
            Exchange(id: 2, name: "Test", slug: "test", logoURL: "", spotVolumeUSD: 2_500_000.0, dateLaunched: Date()),
            Exchange(id: 3, name: "Test", slug: "test", logoURL: "", spotVolumeUSD: 3_500.0, dateLaunched: Date()),
            Exchange(id: 4, name: "Test", slug: "test", logoURL: "", spotVolumeUSD: 0.0, dateLaunched: Date())
        ]
        let response = ExchangesList.LoadExchanges.Response(result: .success(exchanges))
        let expectation = expectation(description: "Display called")
        
        // When
        sut.present(response)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let viewModel = self.viewSpy.lastViewModel else {
                XCTFail("ViewModel should not be nil")
                return
            }
            
            XCTAssertEqual(viewModel.exchanges[0].volumeFormatted, "$1.50B")
            XCTAssertEqual(viewModel.exchanges[1].volumeFormatted, "$2.50M")
            XCTAssertEqual(viewModel.exchanges[2].volumeFormatted, "$3.50K")
            XCTAssertEqual(viewModel.exchanges[3].volumeFormatted, "N/A")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPresent_FormatsDateCorrectly() {
        // Given
        let validDate = Date(timeIntervalSince1970: 946684800) // 2000-01-01
        let distantPast = Date.distantPast
        let futureDate = Date(timeIntervalSinceNow: 86400) // Tomorrow
        
        let exchanges = [
            Exchange(id: 1, name: "Test", slug: "test", logoURL: "", spotVolumeUSD: 0, dateLaunched: validDate),
            Exchange(id: 2, name: "Test", slug: "test", logoURL: "", spotVolumeUSD: 0, dateLaunched: distantPast),
            Exchange(id: 3, name: "Test", slug: "test", logoURL: "", spotVolumeUSD: 0, dateLaunched: futureDate)
        ]
        let response = ExchangesList.LoadExchanges.Response(result: .success(exchanges))
        let expectation = expectation(description: "Display called")
        
        // When
        sut.present(response)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let viewModel = self.viewSpy.lastViewModel else {
                XCTFail("ViewModel should not be nil")
                return
            }
            
            XCTAssertNotEqual(viewModel.exchanges[0].dateLaunchedFormatted, "N/A")
            XCTAssertEqual(viewModel.exchanges[1].dateLaunchedFormatted, "N/A")
            XCTAssertEqual(viewModel.exchanges[2].dateLaunchedFormatted, "N/A")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
