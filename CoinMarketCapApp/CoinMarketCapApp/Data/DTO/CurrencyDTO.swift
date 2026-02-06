//
//  CurrencyDTO.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

struct CurrencyResponseDTO: Decodable {
    let data: [CurrencyDTO]
    let status: StatusDTO
}

struct CurrencyDTO: Decodable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let logo: String?
    let dateAdded: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case slug
        case logo
        case dateAdded = "date_added"
    }
    
    func toDomain(priceUSD: Double? = nil) -> Currency {
        // Build logo URL if not provided
        // CoinMarketCap logo format: https://s2.coinmarketcap.com/static/img/coins/64x64/{id}.png
        let logoURL: String
        if let logo = logo, !logo.isEmpty {
            logoURL = logo.hasPrefix("http") ? logo : "https://s2.coinmarketcap.com\(logo)"
        } else {
            // Fallback: construct URL from currency ID
            logoURL = "https://s2.coinmarketcap.com/static/img/coins/64x64/\(id).png"
        }
        
        // Parse date with multiple format support
        let parsedDate: Date
        if let dateString = dateAdded, !dateString.isEmpty {
            parsedDate = DateFormatter.parseISO8601(dateString) ?? Date()
        } else {
            parsedDate = Date()
        }
        
        return Currency(
            id: id,
            name: name,
            symbol: symbol,
            slug: slug,
            logoURL: logoURL,
            dateAdded: parsedDate,
            priceUSD: priceUSD
        )
    }
}
