//
//  ExchangeDetailViewSnapshotTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 09/02/26.
//

import XCTest
import UIKit
@testable import CoinMarketCapApp

@MainActor
final class ExchangeDetailViewSnapshotTests: XCTestCase {
    
    var sut: ExchangeDetailView!
    
    override func setUp() {
        super.setUp()
        sut = ExchangeDetailView(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSnapshot_LoadingState() {
        // Given
        sut.showLoading()
        
        // When
        let snapshot = captureSnapshot(of: sut)
        
        // Then
        XCTAssertNotNil(snapshot)
        XCTAssertTrue(sut.loadingIndicator.isAnimating)
        XCTAssertTrue(sut.scrollView.isHidden)
    }
    
    func testSnapshot_ErrorState() {
        // Given
        let errorMessage = "Failed to load exchange details. Please try again."
        sut.showError(errorMessage)
        
        // When
        let snapshot = captureSnapshot(of: sut)
        
        // Then
        XCTAssertNotNil(snapshot)
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.errorLabel.text, errorMessage)
        XCTAssertTrue(sut.scrollView.isHidden)
    }
    
    func testSnapshot_WithCompleteData() {
        // Given
        sut.nameLabel.text = "Binance"
        sut.volumeLabel.text = "Volume: $15.2B"
        sut.dateLabel.text = "Launched: 2017-07-14"
        sut.idLabel.text = "ID: 270"
        sut.websiteLabel.text = "Website: https://www.binance.com"
        sut.websiteLabel.isHidden = false
        sut.makerFeeLabel.text = "Maker Fee: 0.10%"
        sut.makerFeeLabel.isHidden = false
        sut.takerFeeLabel.text = "Taker Fee: 0.10%"
        sut.takerFeeLabel.isHidden = false
        sut.aboutTitleLabel.isHidden = false
        sut.descriptionLabel.text = "Binance is one of the largest cryptocurrency exchanges in the world."
        sut.currenciesTitleLabel.text = "Currencies"
        sut.hideLoading()
        sut.hideError()
        
        // When
        let snapshot = captureSnapshot(of: sut)
        
        // Then
        XCTAssertNotNil(snapshot)
        XCTAssertFalse(sut.scrollView.isHidden)
        XCTAssertTrue(sut.errorLabel.isHidden)
    }
    
    func testSnapshot_WithMinimalData() {
        // Given
        sut.nameLabel.text = "Test Exchange"
        sut.volumeLabel.text = "Volume: N/A"
        sut.dateLabel.text = "Launched: N/A"
        sut.idLabel.text = "ID: 1"
        sut.websiteLabel.isHidden = true
        sut.makerFeeLabel.isHidden = true
        sut.takerFeeLabel.isHidden = true
        sut.aboutTitleLabel.isHidden = true
        sut.descriptionLabel.text = "No description available."
        sut.currenciesTitleLabel.text = "Currencies (Not available in basic plan)"
        sut.hideLoading()
        sut.hideError()
        
        // When
        let snapshot = captureSnapshot(of: sut)
        
        // Then
        XCTAssertNotNil(snapshot)
        XCTAssertFalse(sut.scrollView.isHidden)
    }
    
    func testSnapshot_EmptyCurrenciesState() {
        // Given
        sut.showEmptyCurrenciesMessage()
        
        // When
        let snapshot = captureSnapshot(of: sut)
        
        // Then
        XCTAssertNotNil(snapshot)
        XCTAssertEqual(sut.currenciesTitleLabel.text, "Currencies (Not available in basic plan)")
        XCTAssertEqual(sut.currenciesTitleLabel.textColor, DSColor.textSecondary)
    }
    
    // MARK: - Helper Methods
    
    private func captureSnapshot(of view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
    }
}
