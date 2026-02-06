//
//  ExchangeDTO.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

struct ExchangeResponseDTO: Decodable {
    let data: [ExchangeDTO]
    let status: StatusDTO
}

struct ExchangeDTO: Decodable {
    let id: Int
    let name: String
    let slug: String
    let logo: String?
    let dateLaunched: String?
    let spotVolumeUsd: Double?
    let lastUpdated: String?
    let quote: QuoteDTO?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case logo
        case dateLaunched = "date_launched"
        case spotVolumeUsd = "spot_volume_usd"
        case lastUpdated = "last_updated"
        case quote
    }
    
    // Support for both /v1/exchange/map and /v1/exchange/listings/latest endpoints
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        slug = try container.decode(String.self, forKey: .slug)
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
        dateLaunched = try container.decodeIfPresent(String.self, forKey: .dateLaunched)
        lastUpdated = try container.decodeIfPresent(String.self, forKey: .lastUpdated)
        quote = try container.decodeIfPresent(QuoteDTO.self, forKey: .quote)
        
        // Extract spot_volume_usd from quote.USD.spot_volume_usd (listings endpoint)
        // or directly from spot_volume_usd (map endpoint)
        if let quote = quote, let usd = quote.usd {
            spotVolumeUsd = usd.spotVolumeUsd
        } else {
            // Try direct field (for /v1/exchange/map endpoint)
            spotVolumeUsd = try container.decodeIfPresent(Double.self, forKey: .spotVolumeUsd)
        }
    }
    
    func toDomain() -> Exchange {
        // Build logo URL if not provided
        // CoinMarketCap logo format: https://s2.coinmarketcap.com/static/img/exchanges/64x64/{id}.png
        let logoURL: String
        if let logo = logo, !logo.isEmpty {
            logoURL = logo.hasPrefix("http") ? logo : "https://s2.coinmarketcap.com\(logo)"
        } else {
            // Fallback: construct URL from exchange ID
            logoURL = "https://s2.coinmarketcap.com/static/img/exchanges/64x64/\(id).png"
        }
        
        // Parse date with multiple format support
        // Try date_launched first, then last_updated as fallback
        let parsedDate: Date
        if let dateString = dateLaunched, !dateString.isEmpty {
            if let date = DateFormatter.parseISO8601(dateString) {
                parsedDate = date
            } else {
                parsedDate = Date.distantPast
            }
        } else if let dateString = lastUpdated, !dateString.isEmpty {
            // Use last_updated as fallback if date_launched is not available
            // Note: last_updated from listings endpoint is when data was last updated, not launch date
            if let date = DateFormatter.parseISO8601(dateString) {
                parsedDate = date
            } else {
                parsedDate = Date.distantPast
            }
        } else {
            // Use distant past to indicate missing data
            parsedDate = Date.distantPast
        }
        
        return Exchange(
            id: id,
            name: name,
            slug: slug,
            logoURL: logoURL,
            spotVolumeUSD: spotVolumeUsd ?? 0.0,
            dateLaunched: parsedDate
        )
    }
}

// MARK: - Quote DTO for listings endpoint
struct QuoteDTO: Decodable {
    let usd: USDQuoteDTO?
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct USDQuoteDTO: Decodable {
    let spotVolumeUsd: Double?
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
        case spotVolumeUsd = "spot_volume_usd"
        case price
    }
}
