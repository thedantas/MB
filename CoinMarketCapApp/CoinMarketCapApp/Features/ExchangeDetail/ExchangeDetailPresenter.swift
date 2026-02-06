//
//  ExchangeDetailPresenter.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

protocol ExchangeDetailPresenting {
    func present(_ response: ExchangeDetailModels.LoadDetail.Response)
    func present(_ response: ExchangeDetailModels.LoadCurrencies.Response)
}

final class ExchangeDetailPresenter: ExchangeDetailPresenting {
    
    weak var view: ExchangeDetailDisplayLogic?
    
    func present(_ response: ExchangeDetailModels.LoadDetail.Response) {
        let viewModel: ExchangeDetailModels.LoadDetail.ViewModel
        
        switch response.result {
        case .success(let exchange):
            viewModel = ExchangeDetailModels.LoadDetail.ViewModel(
                exchange: ExchangeDetailModels.ExchangeDetailViewModel(
                    id: exchange.id,
                    name: exchange.name,
                    logoURL: exchange.logoURL,
                    volumeFormatted: formatVolume(exchange.spotVolumeUSD),
                    dateLaunchedFormatted: DateFormatter.displayDate.string(from: exchange.dateLaunched),
                    description: exchange.description,
                    websiteURL: exchange.websiteURL,
                    makerFee: exchange.makerFee,
                    takerFee: exchange.takerFee
                ),
                errorMessage: nil,
                error: nil,
                isLoading: false
            )
        case .failure(let error):
            viewModel = ExchangeDetailModels.LoadDetail.ViewModel(
                exchange: nil,
                errorMessage: error.localizedDescription,
                error: error,
                isLoading: false
            )
        }
        
        DispatchQueue.main.async {
            self.view?.display(viewModel)
        }
    }
    
    func present(_ response: ExchangeDetailModels.LoadCurrencies.Response) {
        let viewModel: ExchangeDetailModels.LoadCurrencies.ViewModel
        
        switch response.result {
        case .success(let currencies):
            let currencyViewModels = currencies.map { currency in
                ExchangeDetailModels.CurrencyViewModel(
                    id: currency.id,
                    name: currency.name,
                    symbol: currency.symbol,
                    logoURL: currency.logoURL,
                    priceUSD: currency.priceUSD
                )
            }
            viewModel = ExchangeDetailModels.LoadCurrencies.ViewModel(
                currencies: currencyViewModels,
                errorMessage: nil,
                error: nil
            )
        case .failure(let error):
            viewModel = ExchangeDetailModels.LoadCurrencies.ViewModel(
                currencies: [],
                errorMessage: error.localizedDescription,
                error: error
            )
        }
        
        DispatchQueue.main.async {
            self.view?.display(viewModel)
        }
    }
    
    private func formatVolume(_ volume: Double) -> String {
        if volume >= 1_000_000_000 {
            return String(format: "$%.2fB", volume / 1_000_000_000)
        } else if volume >= 1_000_000 {
            return String(format: "$%.2fM", volume / 1_000_000)
        } else if volume >= 1_000 {
            return String(format: "$%.2fK", volume / 1_000)
        } else {
            return String(format: "$%.2f", volume)
        }
    }
}
