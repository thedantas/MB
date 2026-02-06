//
//  Endpoint.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

struct Endpoint {
    
    let path: String
    let queryItems: [URLQueryItem]
    
    var urlRequest: URLRequest {
        var components = URLComponents(string: "https://pro-api.coinmarketcap.com")!
        components.path = path
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            fatalError("Invalid URL components")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let apiKey = Bundle.main.infoDictionary?["CMC_API_KEY"] as? String, !apiKey.isEmpty {
            request.addValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        } else {
            #if DEBUG
            if let apiKey = ProcessInfo.processInfo.environment["CMC_API_KEY"], !apiKey.isEmpty {
                request.addValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
            }
            #endif
        }
        
        return request
    }
}
