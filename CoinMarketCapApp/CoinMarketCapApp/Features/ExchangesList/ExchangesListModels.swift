//
//  ExchangesListModels.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

enum ExchangesList {
    
    enum LoadExchanges {
        struct Request {}
        
        struct Response {
            let result: Result<[Exchange], Error>
        }
        
        struct ViewModel {
            let exchanges: [ExchangeViewModel]
            let errorMessage: String?
            let error: Error?
            let isLoading: Bool
        }
    }
    
    struct ExchangeViewModel {
        let id: Int
        let name: String
        let logoURL: String
        let volumeFormatted: String
        let dateLaunchedFormatted: String
    }
}
