//
//  ExchangesListDisplayLogicSpy.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import Foundation
@testable import CoinMarketCapApp

final class ExchangesListDisplayLogicSpy: ExchangesListDisplayLogic {
    
    var displayCallCount = 0
    var lastViewModel: ExchangesList.LoadExchanges.ViewModel?
    
    func display(_ viewModel: ExchangesList.LoadExchanges.ViewModel) {
        displayCallCount += 1
        lastViewModel = viewModel
    }
}
