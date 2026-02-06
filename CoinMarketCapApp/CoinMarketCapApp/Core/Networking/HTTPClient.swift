//
//  HTTPClient.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

protocol HTTPClient {
    func request<T: Decodable>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}
