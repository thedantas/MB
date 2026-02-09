//
//  MarkdownFormatterTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class MarkdownFormatterTests: XCTestCase {
    
    func testAttributedString_RemovesHeaders() {
        // Given
        let markdown = "## Header\n\nContent"
        
        // When
        let attributed = MarkdownFormatter.attributedString(from: markdown)
        
        // Then
        XCTAssertFalse(attributed.string.contains("##"))
        XCTAssertTrue(attributed.string.contains("Header"))
    }
    
    func testAttributedString_RemovesBoldMarkers() {
        // Given
        let markdown = "This is **bold** text"
        
        // When
        let attributed = MarkdownFormatter.attributedString(from: markdown)
        
        // Then
        XCTAssertFalse(attributed.string.contains("**"))
        XCTAssertTrue(attributed.string.contains("bold"))
    }
    
    func testAttributedString_RemovesItalicMarkers() {
        // Given
        let markdown = "This is *italic* text"
        
        // When
        let attributed = MarkdownFormatter.attributedString(from: markdown)
        
        // Then
        XCTAssertFalse(attributed.string.contains("*"))
        XCTAssertTrue(attributed.string.contains("italic"))
    }
    
    func testAttributedString_RemovesLinks() {
        // Given
        let markdown = "Check [this link](https://example.com)"
        
        // When
        let attributed = MarkdownFormatter.attributedString(from: markdown)
        
        // Then
        XCTAssertFalse(attributed.string.contains("["))
        XCTAssertFalse(attributed.string.contains("]"))
        XCTAssertTrue(attributed.string.contains("this link"))
    }
    
    func testAttributedString_HandlesMultipleParagraphs() {
        // Given
        let markdown = "First paragraph\n\nSecond paragraph"
        
        // When
        let attributed = MarkdownFormatter.attributedString(from: markdown)
        
        // Then
        XCTAssertTrue(attributed.string.contains("First paragraph"))
        XCTAssertTrue(attributed.string.contains("Second paragraph"))
    }
    
    func testAttributedString_HandlesEmptyString() {
        // Given
        let markdown = ""
        
        // When
        let attributed = MarkdownFormatter.attributedString(from: markdown)
        
        // Then
        XCTAssertTrue(attributed.string.isEmpty)
    }
    
    func testAttributedString_CleansMultipleSpaces() {
        // Given
        let markdown = "Text    with    multiple    spaces"
        
        // When
        let attributed = MarkdownFormatter.attributedString(from: markdown)
        
        // Then
        XCTAssertFalse(attributed.string.contains("    "))
    }
}
