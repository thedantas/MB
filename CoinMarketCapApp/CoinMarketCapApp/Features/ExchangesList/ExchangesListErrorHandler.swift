//
//  ExchangesListErrorHandler.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import UIKit

protocol ExchangesListErrorHandling: AnyObject {
    func showError(_ error: Error, retryAction: @escaping () -> Void)
}

extension ExchangesListErrorHandling where Self: UIViewController {
    
    func showError(_ error: Error, retryAction: @escaping () -> Void) {
        let errorMessage = getErrorMessage(from: error)
        
        let alertController = UIAlertController(
            title: "Error",
            message: errorMessage,
            preferredStyle: .actionSheet
        )
        
        // Retry action
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            retryAction()
        }
        alertController.addAction(retryAction)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        // For iPad support
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alertController, animated: true)
    }
    
    private func getErrorMessage(from error: Error) -> String {
        if let apiError = error as? APIError {
            return apiError.localizedDescription
        }
        return error.localizedDescription
    }
}
