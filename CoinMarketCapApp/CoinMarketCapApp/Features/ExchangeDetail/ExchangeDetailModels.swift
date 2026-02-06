//
//  ExchangeDetailModels.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

enum ExchangeDetailModels {
    
    enum LoadDetail {
        struct Request {}
        
        struct Response {
            let result: Result<ExchangeDetail, Error>
        }
        
        struct ViewModel {
            let exchange: ExchangeDetailViewModel?
            let errorMessage: String?
            let error: Error?
            let isLoading: Bool
        }
    }
    
    enum LoadCurrencies {
        struct Request {}
        
        struct Response {
            let result: Result<[Currency], Error>
        }
        
        struct ViewModel {
            let currencies: [CurrencyViewModel]
            let errorMessage: String?
            let error: Error?
        }
    }
    
    struct ExchangeDetailViewModel {
        let id: Int
        let name: String
        let logoURL: String
        let volumeFormatted: String
        let dateLaunchedFormatted: String
        let description: String
        let websiteURL: String?
        let makerFee: Double?
        let takerFee: Double?
    }
    
    struct CurrencyViewModel {
        let id: Int
        let name: String
        let symbol: String
        let logoURL: String
        let priceUSD: Double?
    }
}
