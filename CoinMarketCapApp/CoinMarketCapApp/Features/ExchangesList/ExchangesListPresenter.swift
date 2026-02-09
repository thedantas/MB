//
//  ExchangesListPresenter.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

protocol ExchangesListPresenting {
    func present(_ response: ExchangesList.LoadExchanges.Response)
}

final class ExchangesListPresenter: ExchangesListPresenting {
    
    weak var view: ExchangesListDisplayLogic?
    
    func present(_ response: ExchangesList.LoadExchanges.Response) {
        let viewModel: ExchangesList.LoadExchanges.ViewModel
        
        switch response.result {
        case .success(let exchanges):
            let exchangeViewModels = exchanges.map { exchange in
                ExchangesList.ExchangeViewModel(
                    id: exchange.id,
                    name: exchange.name,
                    logoURL: exchange.logoURL,
                    volumeFormatted: formatVolume(exchange.spotVolumeUSD),
                    dateLaunchedFormatted: formatDate(exchange.dateLaunched)
                )
            }
            viewModel = ExchangesList.LoadExchanges.ViewModel(
                exchanges: exchangeViewModels,
                errorMessage: nil,
                error: nil,
                isLoading: false
            )
        case .failure(let error):
            let errorMessage: String
            if let apiError = error as? APIError {
                errorMessage = apiError.localizedDescription
            } else {
                errorMessage = error.localizedDescription
            }
            
            viewModel = ExchangesList.LoadExchanges.ViewModel(
                exchanges: [],
                errorMessage: errorMessage,
                error: error,
                isLoading: false
            )
        }
        
        DispatchQueue.main.async {
            self.view?.display(viewModel)
        }
    }
    
    private func formatVolume(_ volume: Double) -> String {
        if volume == 0.0 {
            return "N/A"
        }
        
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
    
    private func formatDate(_ date: Date) -> String {
        if date == Date.distantPast {
            return "N/A"
        }
        
        if date > Date() {
            return "N/A"
        }
        
        return DateFormatter.displayDate.string(from: date)
    }
}
