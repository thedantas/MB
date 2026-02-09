//
//  ExchangesListErrorHandlerTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 09/02/26.
//

import XCTest
import UIKit
@testable import CoinMarketCapApp

@MainActor
final class ExchangesListErrorHandlerTests: XCTestCase {
    
    var viewController: MockViewController!
    
    override func setUp() {
        super.setUp()
        viewController = MockViewController()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testShowError_WithAPIError_ShowsAlertWithCorrectMessage() {
        // Given
        let error = APIError.network(NSError(domain: "TestError", code: -1009))
        let expectation = expectation(description: "Alert presented")
        
        // When
        viewController.showError(error) {}
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewController.presentCallCount > 0)
            let alertController = self.viewController.lastPresentedViewController as? UIAlertController
            XCTAssertNotNil(alertController)
            XCTAssertEqual(alertController?.title, "Error")
            XCTAssertEqual(alertController?.preferredStyle, .actionSheet)
            XCTAssertEqual(alertController?.actions.count, 2)
            XCTAssertEqual(alertController?.actions.first?.title, "Retry")
            XCTAssertEqual(alertController?.actions.last?.title, "Cancel")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testShowError_WithGenericError_ShowsAlertWithErrorMessage() {
        // Given
        let error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error message"])
        let expectation = expectation(description: "Alert presented")
        
        // When
        viewController.showError(error) {}
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let alertController = self.viewController.lastPresentedViewController as? UIAlertController
            XCTAssertNotNil(alertController)
            XCTAssertTrue(alertController?.message?.contains("Test error message") ?? false)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testShowError_ConfiguresPopoverForiPad() {
        // Given
        let error = APIError.noData
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        // When
        viewController.showError(error) {}
        
        // Then
        let expectation = expectation(description: "Popover configured")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let alertController = self.viewController.lastPresentedViewController as? UIAlertController
            let popover = alertController?.popoverPresentationController
            XCTAssertNotNil(popover)
            XCTAssertNotNil(popover?.sourceView)
            XCTAssertEqual(popover?.permittedArrowDirections, [])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock ViewController

@MainActor
final class MockViewController: UIViewController, ExchangesListErrorHandling {
    
    var presentCallCount = 0
    var lastPresentedViewController: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCallCount += 1
        lastPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
