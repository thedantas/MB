//
//  CurrencyDTOTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 09/02/26.
//

import XCTest
@testable import CoinMarketCapApp

final class CurrencyDTOTests: XCTestCase {
    
    func testDecode_WithValidJSON_DecodesCorrectly() throws {
        // Given
        let jsonString = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "slug": "bitcoin",
            "logo": "https://example.com/logo.png",
            "date_added": "2020-01-01T00:00:00.000Z"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // When
        let dto = try decoder.decode(CurrencyDTO.self, from: jsonData)
        
        // Then
        XCTAssertEqual(dto.id, 1)
        XCTAssertEqual(dto.name, "Bitcoin")
        XCTAssertEqual(dto.symbol, "BTC")
        XCTAssertEqual(dto.slug, "bitcoin")
        XCTAssertEqual(dto.logo, "https://example.com/logo.png")
        XCTAssertEqual(dto.dateAdded, "2020-01-01T00:00:00.000Z")
    }
    
    func testDecode_WithOptionalFields_DecodesCorrectly() throws {
        // Given
        let jsonString = """
        {
            "id": 2,
            "name": "Ethereum",
            "symbol": "ETH",
            "slug": "ethereum"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // When
        let dto = try decoder.decode(CurrencyDTO.self, from: jsonData)
        
        // Then
        XCTAssertEqual(dto.id, 2)
        XCTAssertEqual(dto.name, "Ethereum")
        XCTAssertNil(dto.logo)
        XCTAssertNil(dto.dateAdded)
    }
    
    func testToDomain_WithCompleteData_ReturnsCurrency() throws {
        // Given
        let jsonString = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "slug": "bitcoin",
            "logo": "https://example.com/logo.png",
            "date_added": "2020-01-01T00:00:00.000Z"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let dto = try decoder.decode(CurrencyDTO.self, from: jsonData)
        
        // When
        let currency = dto.toDomain(priceUSD: 50000.0)
        
        // Then
        XCTAssertEqual(currency.id, 1)
        XCTAssertEqual(currency.name, "Bitcoin")
        XCTAssertEqual(currency.symbol, "BTC")
        XCTAssertEqual(currency.slug, "bitcoin")
        XCTAssertEqual(currency.logoURL, "https://example.com/logo.png")
        XCTAssertEqual(currency.priceUSD, 50000.0)
    }
    
    func testToDomain_WithLogoPath_ConstructsFullURL() throws {
        // Given
        let jsonString = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "slug": "bitcoin",
            "logo": "/static/img/coins/64x64/1.png"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let dto = try decoder.decode(CurrencyDTO.self, from: jsonData)
        
        // When
        let currency = dto.toDomain()
        
        // Then
        XCTAssertEqual(currency.logoURL, "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png")
    }
    
    func testToDomain_WithoutLogo_ConstructsFallbackURL() throws {
        // Given
        let jsonString = """
        {
            "id": 123,
            "name": "Ethereum",
            "symbol": "ETH",
            "slug": "ethereum"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let dto = try decoder.decode(CurrencyDTO.self, from: jsonData)
        
        // When
        let currency = dto.toDomain()
        
        // Then
        XCTAssertEqual(currency.logoURL, "https://s2.coinmarketcap.com/static/img/coins/64x64/123.png")
    }
    
    func testToDomain_WithEmptyLogo_ConstructsFallbackURL() throws {
        // Given
        let jsonString = """
        {
            "id": 456,
            "name": "Litecoin",
            "symbol": "LTC",
            "slug": "litecoin",
            "logo": ""
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let dto = try decoder.decode(CurrencyDTO.self, from: jsonData)
        
        // When
        let currency = dto.toDomain()
        
        // Then
        XCTAssertEqual(currency.logoURL, "https://s2.coinmarketcap.com/static/img/coins/64x64/456.png")
    }
    
    func testToDomain_WithDateAdded_ParsesDate() throws {
        // Given
        let jsonString = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "slug": "bitcoin",
            "date_added": "2020-01-01T00:00:00.000Z"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let dto = try decoder.decode(CurrencyDTO.self, from: jsonData)
        
        // When
        let currency = dto.toDomain()
        
        // Then
        XCTAssertNotNil(currency.dateAdded)
        // Date should be parsed correctly (not current date)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: currency.dateAdded)
        let currentYear = calendar.component(.year, from: Date())
        XCTAssertNotEqual(components.year, currentYear, "Date should not be current year")
    }
    
    func testToDomain_WithoutDateAdded_UsesCurrentDate() throws {
        // Given
        let jsonString = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "slug": "bitcoin"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let dto = try decoder.decode(CurrencyDTO.self, from: jsonData)
        
        // When
        let currency = dto.toDomain()
        
        // Then
        XCTAssertNotNil(currency.dateAdded)
        // Should be recent (within last minute)
        let timeDifference = abs(currency.dateAdded.timeIntervalSinceNow)
        XCTAssertLessThan(timeDifference, 60.0)
    }
    
    func testToDomain_WithPriceUSD_UsesProvidedPrice() throws {
        // Given
        let jsonString = """
        {
            "id": 1,
            "name": "Bitcoin",
            "symbol": "BTC",
            "slug": "bitcoin"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let dto = try decoder.decode(CurrencyDTO.self, from: jsonData)
        
        // When
        let currency = dto.toDomain(priceUSD: 75000.0)
        
        // Then
        XCTAssertEqual(currency.priceUSD, 75000.0)
    }
}
