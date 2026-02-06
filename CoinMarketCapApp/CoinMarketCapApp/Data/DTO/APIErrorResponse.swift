//
//  APIErrorResponse.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

struct APIErrorResponse: Decodable {
    let status: StatusDTO
}

struct StatusDTO: Decodable {
    let timestamp: String
    let errorCode: Int
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}
