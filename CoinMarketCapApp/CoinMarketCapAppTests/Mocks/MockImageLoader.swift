//
//  MockImageLoader.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 06/02/26.
//

import UIKit
@testable import CoinMarketCapApp

final class MockImageLoader: ImageLoader {
    
    var loadImageCallCount = 0
    var loadImageURLs: [URL] = []
    var shouldReturnNil = false
    var mockImage: UIImage?
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        loadImageCallCount += 1
        loadImageURLs.append(url)
        
        if shouldReturnNil {
            completion(nil)
        } else {
            completion(mockImage ?? UIImage(systemName: "photo"))
        }
    }
}
