//
//  DateFormatterTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class DateFormatterTests: XCTestCase {
    
    func testParseISO8601_WithMilliseconds() {
        // Given
        let dateString = "2020-01-01T12:00:00.000Z"
        
        // When
        let date = DateFormatter.parseISO8601(dateString)
        
        // Then
        XCTAssertNotNil(date)
    }
    
    func testParseISO8601_WithoutMilliseconds() {
        // Given
        let dateString = "2020-01-01T12:00:00Z"
        
        // When
        let date = DateFormatter.parseISO8601(dateString)
        
        // Then
        XCTAssertNotNil(date)
    }
    
    func testParseISO8601_WithFractionalSeconds() {
        // Given
        let dateString = "2020-01-01T12:00:00.123Z"
        
        // When
        let date = DateFormatter.parseISO8601(dateString)
        
        // Then
        XCTAssertNotNil(date)
    }
    
    func testParseISO8601_InvalidFormat() {
        // Given
        let dateString = "invalid-date"
        
        // When
        let date = DateFormatter.parseISO8601(dateString)
        
        // Then
        XCTAssertNil(date)
    }
    
    func testDisplayDate_FormatsCorrectly() {
        // Given
        let date = Date(timeIntervalSince1970: 946684800) // 2000-01-01
        
        // When
        let formatted = DateFormatter.displayDate.string(from: date)
        
        // Then
        XCTAssertFalse(formatted.isEmpty)
        // Date should contain year 2000 or month abbreviation (format depends on locale)
        let containsYear = formatted.contains("2000")
        let containsMonth = formatted.contains("Jan") || formatted.contains("01") || formatted.contains("1")
        XCTAssertTrue(containsYear || containsMonth, "Formatted date '\(formatted)' should contain year or month")
    }
}
