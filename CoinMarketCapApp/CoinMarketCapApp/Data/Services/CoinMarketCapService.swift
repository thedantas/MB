//
//  CoinMarketCapService.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

protocol CoinMarketCapService {
    func fetchExchanges(
        completion: @escaping (Result<[Exchange], Error>) -> Void
    )
    
    func fetchExchangeDetail(
        exchangeId: Int,
        completion: @escaping (Result<ExchangeDetail, Error>) -> Void
    )
    
    func fetchCurrencies(
        exchangeId: Int,
        completion: @escaping (Result<[Currency], Error>) -> Void
    )
}

final class CoinMarketCapServiceImpl: CoinMarketCapService {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetchExchanges(
        completion: @escaping (Result<[Exchange], Error>) -> Void
    ) {
        let endpoint = Endpoint(
            path: "/v1/exchange/listings/latest",
            queryItems: [
                URLQueryItem(name: "sort", value: "volume_24h"),
                URLQueryItem(name: "limit", value: "100")
            ]
        )
        
        client.request(endpoint: endpoint) { (result: Result<ExchangeResponseDTO, APIError>) in
            switch result {
            case .success(let response):
                let exchanges = response.data.map { $0.toDomain() }
                completion(.success(exchanges))
            case .failure(let error):
                if case .apiError(let code, _) = error, code == 1006 {
                    self.fetchExchangesFallback(completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchExchangesFallback(
        completion: @escaping (Result<[Exchange], Error>) -> Void
    ) {
        let endpoint = Endpoint(
            path: "/v1/exchange/map",
            queryItems: [
                URLQueryItem(name: "listing_status", value: "active"),
                URLQueryItem(name: "sort", value: "id")
            ]
        )
        
        client.request(endpoint: endpoint) { (result: Result<ExchangeResponseDTO, APIError>) in
            switch result {
            case .success(let response):
                let exchanges = response.data.map { $0.toDomain() }
                completion(.success(exchanges))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchExchangeDetail(
        exchangeId: Int,
        completion: @escaping (Result<ExchangeDetail, Error>) -> Void
    ) {
        let endpoint = Endpoint(
            path: "/v1/exchange/info",
            queryItems: [
                URLQueryItem(name: "id", value: "\(exchangeId)"),
                URLQueryItem(name: "aux", value: "urls,logo,description,date_launched,notice,status")
            ]
        )
        
        client.request(endpoint: endpoint) { (result: Result<ExchangeDetailResponseDTO, APIError>) in
            switch result {
            case .success(let response):
                if let exchangeDTO = response.data.values.first {
                    completion(.success(exchangeDTO.toDomain()))
                } else {
                    completion(.failure(APIError.noData))
                }
            case .failure(let error):
                if case .apiError(let code, _) = error, code == 1006 {
                    self.fetchBasicExchangeInfo(exchangeId: exchangeId, completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchBasicExchangeInfo(
        exchangeId: Int,
        completion: @escaping (Result<ExchangeDetail, Error>) -> Void
    ) {
        let endpoint = Endpoint(
            path: "/v1/exchange/map",
            queryItems: [
                URLQueryItem(name: "id", value: "\(exchangeId)")
            ]
        )
        
        client.request(endpoint: endpoint) { (result: Result<ExchangeResponseDTO, APIError>) in
            switch result {
            case .success(let response):
                if let exchangeDTO = response.data.first(where: { $0.id == exchangeId }) {
                    let exchange = exchangeDTO.toDomain()
                    let exchangeDetail = ExchangeDetail(
                        id: exchange.id,
                        name: exchange.name,
                        slug: exchange.slug,
                        logoURL: exchange.logoURL,
                        spotVolumeUSD: exchange.spotVolumeUSD,
                        dateLaunched: exchange.dateLaunched,
                        description: "Detailed information is not available with your current API plan. Please upgrade to access full exchange details.",
                        websiteURL: nil,
                        makerFee: nil,
                        takerFee: nil
                    )
                    completion(.success(exchangeDetail))
                } else {
                    completion(.failure(APIError.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCurrencies(
        exchangeId: Int,
        completion: @escaping (Result<[Currency], Error>) -> Void
    ) {
        let endpoint = Endpoint(
            path: "/v1/exchange/market-pairs/latest",
            queryItems: [
                URLQueryItem(name: "id", value: "\(exchangeId)")
            ]
        )
        
        client.request(endpoint: endpoint) { (result: Result<MarketPairsResponseDTO, APIError>) in
            switch result {
            case .success(let response):
                let currencies = response.data.marketPairs.map { marketPair in
                    marketPair.baseCurrency.toDomain(priceUSD: marketPair.quote?.usd?.price)
                }
                completion(.success(currencies))
            case .failure(let error):
                if case .apiError(let code, _) = error, code == 1006 {
                    completion(.success([]))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Supporting DTOs for Exchange Detail

struct ExchangeDetailResponseDTO: Decodable {
    let data: [String: ExchangeDetailDTO]
    let status: StatusDTO
}

struct ExchangeDetailDTO: Decodable {
    let id: Int
    let name: String
    let slug: String
    let logo: String?
    let dateLaunched: String?
    let spotVolumeUsd: Double?
    let description: String?
    let urls: ExchangeURLsDTO?
    let makerFee: Double?
    let takerFee: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case logo
        case dateLaunched = "date_launched"
        case spotVolumeUsd = "spot_volume_usd"
        case description
        case urls
        case makerFee = "maker_fee"
        case takerFee = "taker_fee"
    }
    
    func toDomain() -> ExchangeDetail {
        let logoURL: String
        if let logo = logo, !logo.isEmpty {
            logoURL = logo.hasPrefix("http") ? logo : "https://s2.coinmarketcap.com\(logo)"
        } else {
            logoURL = "https://s2.coinmarketcap.com/static/img/exchanges/64x64/\(id).png"
        }
        
        let parsedDate: Date
        if let dateString = dateLaunched, !dateString.isEmpty {
            parsedDate = DateFormatter.parseISO8601(dateString) ?? Date.distantPast
        } else {
            parsedDate = Date.distantPast
        }
        
        let websiteURL: String? = urls?.website?.first
        
        return ExchangeDetail(
            id: id,
            name: name,
            slug: slug,
            logoURL: logoURL,
            spotVolumeUSD: spotVolumeUsd ?? 0.0,
            dateLaunched: parsedDate,
            description: description ?? "",
            websiteURL: websiteURL,
            makerFee: makerFee,
            takerFee: takerFee
        )
    }
}

struct ExchangeURLsDTO: Decodable {
    let website: [String]?
    
    enum CodingKeys: String, CodingKey {
        case website
    }
}

// MARK: - Supporting DTOs for Market Pairs

struct MarketPairsResponseDTO: Decodable {
    let data: MarketPairsDataDTO
    let status: StatusDTO
}

struct MarketPairsDataDTO: Decodable {
    let marketPairs: [MarketPairDTO]
    
    enum CodingKeys: String, CodingKey {
        case marketPairs = "market_pairs"
    }
}

struct MarketPairDTO: Decodable {
    let baseCurrency: CurrencyDTO
    let quote: QuoteDTO?
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency = "base_currency"
        case quote
    }
}
