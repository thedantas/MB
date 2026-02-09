//
//  APIError.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

enum APIError: Error, Equatable {
    case network(Error)
    case decoding(Error)
    case noData
    case invalidResponse
    case httpError(statusCode: Int)
    case apiError(code: Int, message: String)
    
    var localizedDescription: String {
        switch self {
        case .network(let error):
            return LocalizedKey.networkError.localized(with: error.localizedDescription)
        case .decoding(let error):
            return LocalizedKey.decodingError.localized(with: error.localizedDescription)
        case .noData:
            return LocalizedKey.noData.localized
        case .invalidResponse:
            return LocalizedKey.invalidResponse.localized
        case .httpError(let statusCode):
            return LocalizedKey.httpError.localized(with: statusCode)
        case .apiError(let code, let message):
            return String(format: LocalizedKey.apiError.localized, code, message)
        }
    }
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData), (.invalidResponse, .invalidResponse):
            return true
        case (.httpError(let lhsCode), .httpError(let rhsCode)):
            return lhsCode == rhsCode
        case (.apiError(let lhsCode, let lhsMsg), .apiError(let rhsCode, let rhsMsg)):
            return lhsCode == rhsCode && lhsMsg == rhsMsg
        case (.network, .network), (.decoding, .decoding):
            return true
        default:
            return false
        }
    }
}
