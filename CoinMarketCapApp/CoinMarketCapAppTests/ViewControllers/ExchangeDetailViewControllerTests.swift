//
//  ExchangeDetailViewControllerTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 09/02/26.
//

import XCTest
import UIKit
@testable import CoinMarketCapApp

@MainActor
final class ExchangeDetailViewControllerTests: XCTestCase {
    
    var sut: ExchangeDetailViewController!
    var mockInteractor: MockExchangeDetailInteractor!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockExchangeDetailInteractor()
        sut = ExchangeDetailViewController(interactor: mockInteractor)
    }
    
    override func tearDown() {
        sut = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testInitialization_CreatesViewController() {
        // Then
        XCTAssertNotNil(sut)
        XCTAssertEqual(mockInteractor.loadDetailCallCount, 0)
        XCTAssertEqual(mockInteractor.loadCurrenciesCallCount, 0)
    }
    
    func testViewDidLoad_CallsLoadData() {
        // Given
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        // When
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        
        // Then
        let expectation = expectation(description: "Load data called")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertGreaterThanOrEqual(self.mockInteractor.loadDetailCallCount, 1, "Should call loadDetail")
            XCTAssertGreaterThanOrEqual(self.mockInteractor.loadCurrenciesCallCount, 1, "Should call loadCurrencies")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testDisplayDetail_WithSuccess_ConfiguresView() {
        // Given
        let exchange = ExchangeDetailModels.ExchangeDetailViewModel(
            id: 1,
            name: "Test Exchange",
            logoURL: "https://example.com/logo.png",
            volumeFormatted: "$1.5B",
            dateLaunchedFormatted: "2020-01-01",
            description: "Test description",
            websiteURL: "https://example.com",
            makerFee: 0.1,
            takerFee: 0.2
        )
        let viewModel = ExchangeDetailModels.LoadDetail.ViewModel(
            exchange: exchange,
            errorMessage: nil,
            error: nil,
            isLoading: false
        )
        
        // When
        sut.display(viewModel)
        
        // Then
        XCTAssertEqual(sut.title, "Test Exchange")
        XCTAssertFalse(sut.testCustomView.nameLabel.isHidden)
        XCTAssertEqual(sut.testCustomView.nameLabel.text, "Test Exchange")
    }
    
    func testDisplayDetail_WithError_ShowsError() {
        // Given
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        window.rootViewController = sut
        window.makeKeyAndVisible()
        sut.loadViewIfNeeded()
        
        let error = APIError.network(NSError(domain: "TestError", code: -1009))
        let viewModel = ExchangeDetailModels.LoadDetail.ViewModel(
            exchange: nil,
            errorMessage: "Network error",
            error: error,
            isLoading: false
        )
        
        // When
        sut.display(viewModel)
        
        // Then
        let expectation = expectation(description: "Error displayed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.sut.testCustomView.errorLabel.isHidden)
            XCTAssertEqual(self.sut.testCustomView.errorLabel.text, "Network error")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testDisplayCurrencies_WithSuccess_UpdatesCollectionView() {
        // Given
        let currencies = [
            ExchangeDetailModels.CurrencyViewModel(
                id: 1,
                name: "Bitcoin",
                symbol: "BTC",
                logoURL: "https://example.com/btc.png",
                priceUSD: 50000.0
            )
        ]
        let viewModel = ExchangeDetailModels.LoadCurrencies.ViewModel(
            currencies: currencies,
            errorMessage: nil,
            error: nil
        )
        
        // When
        sut.display(viewModel)
        
        // Then
        XCTAssertEqual(sut.currenciesCollectionView.numberOfItems(inSection: 0), 1)
    }
    
    func testDisplayCurrencies_WithEmptyArray_ShowsEmptyMessage() {
        // Given
        let viewModel = ExchangeDetailModels.LoadCurrencies.ViewModel(
            currencies: [],
            errorMessage: nil,
            error: nil
        )
        
        // When
        sut.display(viewModel)
        
        // Then
        XCTAssertEqual(sut.currenciesCollectionView.numberOfItems(inSection: 0), 0)
        XCTAssertEqual(sut.testCustomView.currenciesTitleLabel.text, "Currencies (Not available in basic plan)")
    }
    
    func testDisplayCurrencies_WithPlanLimitationError_ShowsEmptyMessage() {
        // Given
        let error = APIError.apiError(code: 1006, message: "Subscription plan doesn't support this endpoint")
        let viewModel = ExchangeDetailModels.LoadCurrencies.ViewModel(
            currencies: [],
            errorMessage: "API error (1006): Subscription plan doesn't support this endpoint",
            error: error
        )
        
        // When
        sut.display(viewModel)
        
        // Then
        XCTAssertEqual(sut.currenciesCollectionView.numberOfItems(inSection: 0), 0)
        XCTAssertEqual(sut.testCustomView.currenciesTitleLabel.text, "Currencies (Not available in basic plan)")
    }
    
    func testCollectionView_NumberOfItems_ReturnsCurrenciesCount() {
        // Given
        let currencies = [
            ExchangeDetailModels.CurrencyViewModel(
                id: 1,
                name: "Bitcoin",
                symbol: "BTC",
                logoURL: "",
                priceUSD: 50000.0
            ),
            ExchangeDetailModels.CurrencyViewModel(
                id: 2,
                name: "Ethereum",
                symbol: "ETH",
                logoURL: "",
                priceUSD: 3000.0
            )
        ]
        let viewModel = ExchangeDetailModels.LoadCurrencies.ViewModel(
            currencies: currencies,
            errorMessage: nil,
            error: nil
        )
        sut.display(viewModel)
        
        // When
        let count = sut.collectionView(sut.currenciesCollectionView, numberOfItemsInSection: 0)
        
        // Then
        XCTAssertEqual(count, 2)
    }
    
    func testCollectionView_SizeForItem_ReturnsCorrectSize() {
        // Given
        sut.testCustomView.currenciesCollectionView.frame = CGRect(x: 0, y: 0, width: 375, height: 500)
        let indexPath = IndexPath(item: 0, section: 0)
        
        // When
        let size = sut.collectionView(
            sut.testCustomView.currenciesCollectionView,
            layout: UICollectionViewFlowLayout(),
            sizeForItemAt: indexPath
        )
        
        // Then
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
        XCTAssertEqual(size.height, DSTheme.Size.cellHeightLarge)
    }
    
    func testConfigureView_WithWebsiteURL_CreatesHyperlink() {
        // Given
        let exchange = ExchangeDetailModels.ExchangeDetailViewModel(
            id: 1,
            name: "Test Exchange",
            logoURL: "",
            volumeFormatted: "$1B",
            dateLaunchedFormatted: "2020-01-01",
            description: "Test",
            websiteURL: "https://example.com",
            makerFee: nil,
            takerFee: nil
        )
        let viewModel = ExchangeDetailModels.LoadDetail.ViewModel(
            exchange: exchange,
            errorMessage: nil,
            error: nil,
            isLoading: false
        )
        
        // When
        sut.display(viewModel)
        
        // Then
        XCTAssertFalse(sut.testCustomView.websiteLabel.isHidden)
        XCTAssertNotNil(sut.testCustomView.websiteLabel.attributedText)
    }
    
    func testConfigureView_WithoutWebsiteURL_HidesWebsiteLabel() {
        // Given
        let exchange = ExchangeDetailModels.ExchangeDetailViewModel(
            id: 1,
            name: "Test Exchange",
            logoURL: "",
            volumeFormatted: "$1B",
            dateLaunchedFormatted: "2020-01-01",
            description: "Test",
            websiteURL: nil,
            makerFee: nil,
            takerFee: nil
        )
        let viewModel = ExchangeDetailModels.LoadDetail.ViewModel(
            exchange: exchange,
            errorMessage: nil,
            error: nil,
            isLoading: false
        )
        
        // When
        sut.display(viewModel)
        
        // Then
        XCTAssertTrue(sut.testCustomView.websiteLabel.isHidden)
    }
    
    func testConfigureView_WithFees_ShowsFeeLabels() {
        // Given
        let exchange = ExchangeDetailModels.ExchangeDetailViewModel(
            id: 1,
            name: "Test Exchange",
            logoURL: "",
            volumeFormatted: "$1B",
            dateLaunchedFormatted: "2020-01-01",
            description: "Test",
            websiteURL: nil,
            makerFee: 0.1,
            takerFee: 0.2
        )
        let viewModel = ExchangeDetailModels.LoadDetail.ViewModel(
            exchange: exchange,
            errorMessage: nil,
            error: nil,
            isLoading: false
        )
        
        // When
        sut.display(viewModel)
        
        // Then
        XCTAssertFalse(sut.testCustomView.makerFeeLabel.isHidden)
        XCTAssertFalse(sut.testCustomView.takerFeeLabel.isHidden)
        XCTAssertTrue(sut.testCustomView.makerFeeLabel.text?.contains("0.10") ?? false)
        XCTAssertTrue(sut.testCustomView.takerFeeLabel.text?.contains("0.20") ?? false)
    }
    
    func testConfigureView_WithEmptyDescription_ShowsNoDescriptionMessage() {
        // Given
        let exchange = ExchangeDetailModels.ExchangeDetailViewModel(
            id: 1,
            name: "Test Exchange",
            logoURL: "",
            volumeFormatted: "$1B",
            dateLaunchedFormatted: "2020-01-01",
            description: "",
            websiteURL: nil,
            makerFee: nil,
            takerFee: nil
        )
        let viewModel = ExchangeDetailModels.LoadDetail.ViewModel(
            exchange: exchange,
            errorMessage: nil,
            error: nil,
            isLoading: false
        )
        
        // When
        sut.display(viewModel)
        
        // Then
        XCTAssertTrue(sut.testCustomView.aboutTitleLabel.isHidden)
        XCTAssertEqual(sut.testCustomView.descriptionLabel.text, "No description available.")
    }
}

// MARK: - Mock Interactor

final class MockExchangeDetailInteractor: ExchangeDetailBusinessLogic {
    
    var loadDetailCallCount = 0
    var loadCurrenciesCallCount = 0
    var lastDetailRequest: ExchangeDetailModels.LoadDetail.Request?
    var lastCurrenciesRequest: ExchangeDetailModels.LoadCurrencies.Request?
    
    func loadDetail(request: ExchangeDetailModels.LoadDetail.Request) {
        loadDetailCallCount += 1
        lastDetailRequest = request
    }
    
    func loadCurrencies(request: ExchangeDetailModels.LoadCurrencies.Request) {
        loadCurrenciesCallCount += 1
        lastCurrenciesRequest = request
    }
}

// MARK: - Test Helpers

extension ExchangeDetailViewController {
    var testCustomView: ExchangeDetailView {
        // Access customView via view property since loadView() sets view = customView
        return view as! ExchangeDetailView
    }
    
    var currenciesCollectionView: UICollectionView {
        testCustomView.currenciesCollectionView
    }
}
