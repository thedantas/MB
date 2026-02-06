//
//  AppUITests.swift
//  CoinMarketCapAppUITests
//
//  Created by André Costa Dantas on 04/02/26.
//

import XCTest

final class AppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testAppLaunches() throws {
        XCTAssertTrue(app.navigationBars.element.exists)
    }
    
    func testExchangesListDisplays() throws {
        let navigationBar = app.navigationBars["Exchanges"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5))
    }
}
