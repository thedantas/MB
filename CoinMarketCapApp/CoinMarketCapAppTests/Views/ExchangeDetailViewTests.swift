//
//  ExchangeDetailViewTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 09/02/26.
//

import XCTest
import UIKit
@testable import CoinMarketCapApp

final class ExchangeDetailViewTests: XCTestCase {
    
    var sut: ExchangeDetailView!
    
    override func setUp() {
        super.setUp()
        sut = ExchangeDetailView(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialization_CreatesAllComponents() {
        // Then
        XCTAssertNotNil(sut.scrollView)
        XCTAssertNotNil(sut.contentView)
        XCTAssertNotNil(sut.logoImageView)
        XCTAssertNotNil(sut.nameLabel)
        XCTAssertNotNil(sut.volumeLabel)
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertNotNil(sut.idLabel)
        XCTAssertNotNil(sut.websiteLabel)
        XCTAssertNotNil(sut.feesStackView)
        XCTAssertNotNil(sut.makerFeeLabel)
        XCTAssertNotNil(sut.takerFeeLabel)
        XCTAssertNotNil(sut.aboutTitleLabel)
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertNotNil(sut.currenciesTitleLabel)
        XCTAssertNotNil(sut.currenciesCollectionView)
        XCTAssertNotNil(sut.loadingIndicator)
        XCTAssertNotNil(sut.errorLabel)
    }
    
    func testShowLoading_ShowsIndicatorAndHidesContent() {
        // When
        sut.showLoading()
        
        // Then
        XCTAssertTrue(sut.loadingIndicator.isAnimating)
        XCTAssertTrue(sut.scrollView.isHidden)
        XCTAssertTrue(sut.errorLabel.isHidden)
    }
    
    func testHideLoading_HidesIndicatorAndShowsContent() {
        // Given
        sut.showLoading()
        
        // When
        sut.hideLoading()
        
        // Then
        XCTAssertFalse(sut.loadingIndicator.isAnimating)
        XCTAssertFalse(sut.scrollView.isHidden)
    }
    
    func testShowError_ShowsErrorAndHidesContent() {
        // Given
        let errorMessage = "Test error message"
        
        // When
        sut.showError(errorMessage)
        
        // Then
        XCTAssertEqual(sut.errorLabel.text, errorMessage)
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertTrue(sut.scrollView.isHidden)
        XCTAssertFalse(sut.loadingIndicator.isAnimating)
    }
    
    func testHideError_HidesErrorAndShowsContent() {
        // Given
        sut.showError("Test error")
        
        // When
        sut.hideError()
        
        // Then
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertFalse(sut.scrollView.isHidden)
    }
    
    func testShowEmptyCurrenciesMessage_UpdatesTitle() {
        // When
        sut.showEmptyCurrenciesMessage()
        
        // Then
        XCTAssertEqual(sut.currenciesTitleLabel.text, "Currencies (Not available in basic plan)")
        XCTAssertEqual(sut.currenciesTitleLabel.textColor, DSColor.textSecondary)
    }
}

// MARK: - CurrencyCollectionViewCell Tests

final class CurrencyCollectionViewCellTests: XCTestCase {
    
    var sut: CurrencyCollectionViewCell!
    
    override func setUp() {
        super.setUp()
        sut = CurrencyCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testConfigure_WithPriceUSD_ConfiguresCell() {
        // Given
        let viewModel = ExchangeDetailModels.CurrencyViewModel(
            id: 1,
            name: "Bitcoin",
            symbol: "BTC",
            logoURL: "https://example.com/btc.png",
            priceUSD: 50000.0
        )
        
        // When
        sut.configure(with: viewModel)
        
        // Then
        // Cell is configured (we can't access private properties, but we can verify it doesn't crash)
        XCTAssertNotNil(sut)
    }
    
    func testConfigure_WithoutPriceUSD_ConfiguresCell() {
        // Given
        let viewModel = ExchangeDetailModels.CurrencyViewModel(
            id: 1,
            name: "Bitcoin",
            symbol: "BTC",
            logoURL: "https://example.com/btc.png",
            priceUSD: nil
        )
        
        // When
        sut.configure(with: viewModel)
        
        // Then
        // Cell is configured
        XCTAssertNotNil(sut)
    }
    
    func testPrepareForReuse_DoesNotCrash() {
        // Given
        let viewModel = ExchangeDetailModels.CurrencyViewModel(
            id: 1,
            name: "Bitcoin",
            symbol: "BTC",
            logoURL: "https://example.com/btc.png",
            priceUSD: 50000.0
        )
        sut.configure(with: viewModel)
        
        // When
        sut.prepareForReuse()
        
        // Then
        // Should not crash
        XCTAssertNotNil(sut)
    }
}
