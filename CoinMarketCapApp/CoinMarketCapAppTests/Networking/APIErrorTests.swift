//
//  APIErrorTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class APIErrorTests: XCTestCase {
    
    func testLocalizedDescription_NetworkError() {
        // Given
        let error = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network failed"])
        let apiError = APIError.network(error)
        
        // When
        let description = apiError.localizedDescription
        
        // Then
        XCTAssertTrue(description.contains("Network error"))
        XCTAssertTrue(description.contains("Network failed"))
    }
    
    func testLocalizedDescription_DecodingError() {
        // Given
        let error = NSError(domain: "TestDomain", code: 1)
        let apiError = APIError.decoding(error)
        
        // When
        let description = apiError.localizedDescription
        
        // Then
        XCTAssertTrue(description.contains("Failed to parse response"))
    }
    
    func testLocalizedDescription_NoData() {
        // Given
        let apiError = APIError.noData
        
        // When
        let description = apiError.localizedDescription
        
        // Then
        XCTAssertEqual(description, "No data received from server")
    }
    
    func testLocalizedDescription_InvalidResponse() {
        // Given
        let apiError = APIError.invalidResponse
        
        // When
        let description = apiError.localizedDescription
        
        // Then
        XCTAssertEqual(description, "Invalid response from server")
    }
    
    func testLocalizedDescription_HttpError() {
        // Given
        let apiError = APIError.httpError(statusCode: 404)
        
        // When
        let description = apiError.localizedDescription
        
        // Then
        XCTAssertEqual(description, "HTTP error: 404")
    }
    
    func testLocalizedDescription_ApiError() {
        // Given
        let apiError = APIError.apiError(code: 1006, message: "Subscription plan doesn't support this endpoint")
        
        // When
        let description = apiError.localizedDescription
        
        // Then
        XCTAssertTrue(description.contains("API error"))
        XCTAssertTrue(description.contains("1006"))
        XCTAssertTrue(description.contains("Subscription plan"))
    }
    
    func testEquality_NoData() {
        // Given
        let error1 = APIError.noData
        let error2 = APIError.noData
        
        // Then
        XCTAssertEqual(error1, error2)
    }
    
    func testEquality_HttpError() {
        // Given
        let error1 = APIError.httpError(statusCode: 404)
        let error2 = APIError.httpError(statusCode: 404)
        let error3 = APIError.httpError(statusCode: 500)
        
        // Then
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
    
    func testEquality_ApiError() {
        // Given
        let error1 = APIError.apiError(code: 1006, message: "Error")
        let error2 = APIError.apiError(code: 1006, message: "Error")
        let error3 = APIError.apiError(code: 1007, message: "Error")
        
        // Then
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
}
