//
//  ExchangeDetailDisplayLogicSpy.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import Foundation
@testable import CoinMarketCapApp

final class ExchangeDetailDisplayLogicSpy: ExchangeDetailDisplayLogic {
    
    var displayDetailCallCount = 0
    var displayCurrenciesCallCount = 0
    var lastDetailViewModel: ExchangeDetailModels.LoadDetail.ViewModel?
    var lastCurrenciesViewModel: ExchangeDetailModels.LoadCurrencies.ViewModel?
    
    func display(_ viewModel: ExchangeDetailModels.LoadDetail.ViewModel) {
        displayDetailCallCount += 1
        lastDetailViewModel = viewModel
    }
    
    func display(_ viewModel: ExchangeDetailModels.LoadCurrencies.ViewModel) {
        displayCurrenciesCallCount += 1
        lastCurrenciesViewModel = viewModel
    }
}
