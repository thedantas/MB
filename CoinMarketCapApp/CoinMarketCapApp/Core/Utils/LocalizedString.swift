//
//  LocalizedString.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 09/02/26.
//

import Foundation

extension String {
    
    /// Returns a localized string using the key
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns a localized string with format arguments
    func localized(with arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }
    
    /// Returns a localized string with format arguments (variadic)
    func localized(with arguments: [CVarArg]) -> String {
        return String(format: localized, arguments: arguments)
    }
}

// MARK: - Localized Keys

enum LocalizedKey {
    
    // MARK: - Common
    static let error = "common.error"
    static let retry = "common.retry"
    static let cancel = "common.cancel"
    static let loading = "common.loading"
    static let na = "common.na"
    
    // MARK: - Navigation
    static let exchanges = "navigation.exchanges"
    
    // MARK: - Exchange Detail
    static let volume = "exchange_detail.volume"
    static let launched = "exchange_detail.launched"
    static let id = "exchange_detail.id"
    static let website = "exchange_detail.website"
    static let makerFee = "exchange_detail.maker_fee"
    static let takerFee = "exchange_detail.taker_fee"
    static let about = "exchange_detail.about"
    static let currencies = "exchange_detail.currencies"
    static let currenciesNotAvailable = "exchange_detail.currencies_not_available"
    static let noDescription = "exchange_detail.no_description"
    static let priceFormat = "exchange_detail.price_format"
    
    // MARK: - Errors
    static let failedToLoadData = "error.failed_to_load_data"
    static let failedToLoadExchanges = "error.failed_to_load_exchanges"
    static let networkError = "error.network"
    static let decodingError = "error.decoding"
    static let noData = "error.no_data"
    static let invalidResponse = "error.invalid_response"
    static let httpError = "error.http"
    static let apiError = "error.api"
    static let unknownApiError = "error.unknown_api"
    
    // MARK: - Empty States
    static let noExchanges = "empty_state.no_exchanges"
    static let searchMessage = "empty_state.search_message"
}
