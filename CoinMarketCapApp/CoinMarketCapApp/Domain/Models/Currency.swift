//
//  Currency.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

struct Currency {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let logoURL: String
    let dateAdded: Date
    let priceUSD: Double?
}

struct ExchangeDetail {
    let id: Int
    let name: String
    let slug: String
    let logoURL: String
    let spotVolumeUSD: Double
    let dateLaunched: Date
    let description: String
    let websiteURL: String?
    let makerFee: Double?
    let takerFee: Double?
}
