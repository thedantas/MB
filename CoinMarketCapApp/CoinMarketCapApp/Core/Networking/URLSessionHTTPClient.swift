//
//  URLSessionHTTPClient.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

// Helper function to decode APIErrorResponse in nonisolated context
// Note: This warning is expected in Swift 6 strict concurrency mode
// The decode happens in a background thread context (URLSession callback),
// which is safe for DTOs that don't have MainActor requirements
private func decodeAPIErrorResponse(from data: Data) -> APIErrorResponse? {
    // Decode in current context (background thread from URLSession)
    // APIErrorResponse is a simple DTO without MainActor requirements
    let decoder = JSONDecoder()
    // Suppress Swift 6 concurrency warning - this is safe as we're in a background context
    return try? decoder.decode(APIErrorResponse.self, from: data)
}

final class URLSessionHTTPClient: HTTPClient {
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: endpoint.urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.network(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Check for API error response first (even if HTTP status is 200)
            if let errorResponse = decodeAPIErrorResponse(from: data),
               errorResponse.status.errorCode != 0 {
                let errorMessage = errorResponse.status.errorMessage ?? LocalizedKey.unknownApiError.localized
                completion(.failure(.apiError(code: errorResponse.status.errorCode, message: errorMessage)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                // Try to decode error message from response
                if let errorResponse = decodeAPIErrorResponse(from: data) {
                    let errorMessage = errorResponse.status.errorMessage ?? "HTTP \(httpResponse.statusCode)"
                    completion(.failure(.apiError(code: errorResponse.status.errorCode, message: errorMessage)))
                } else {
                    completion(.failure(.httpError(statusCode: httpResponse.statusCode)))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                #if DEBUG
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Decoding error. Response: \(jsonString)")
                }
                print("Decoding error: \(error)")
                #endif
                completion(.failure(.decoding(error)))
            }
        }
        task.resume()
    }
}
