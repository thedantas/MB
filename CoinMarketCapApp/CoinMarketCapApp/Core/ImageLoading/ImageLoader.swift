//
//  ImageLoader.swift
//  CoinMarketCapApp
//
//  Created by André Costa Dantas on 06/02/26.
//

import UIKit

protocol ImageLoader {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class URLSessionImageLoader: ImageLoader {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 10
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                #if DEBUG
                print("Error loading image from \(url.absoluteString): \(error.localizedDescription)")
                #endif
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data, !data.isEmpty,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
