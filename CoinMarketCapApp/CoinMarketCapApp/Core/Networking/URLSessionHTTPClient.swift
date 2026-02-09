//
//  URLSessionHTTPClient.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 04/02/26.
//

import Foundation

private func decodeAPIErrorResponse(from data: Data) -> APIErrorResponse? {
    let decoder = JSONDecoder()
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
            
            if let errorResponse = decodeAPIErrorResponse(from: data),
               errorResponse.status.errorCode != 0 {
                let errorMessage = errorResponse.status.errorMessage ?? LocalizedKey.unknownApiError.localized
                completion(.failure(.apiError(code: errorResponse.status.errorCode, message: errorMessage)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
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
