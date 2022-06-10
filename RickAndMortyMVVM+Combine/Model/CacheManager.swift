//
//  CacheManager.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import Foundation
import UIKit

class CacheManager {
    static let shared = CacheManager()
    
    let cacheStorage = URLCache(memoryCapacity: 6*1024*1024, diskCapacity: 40*1024*1024, diskPath: nil)
    
    func getImageFromCache(request: URLRequest) -> UIImage? {
        if let cachedData = self.cacheStorage.cachedResponse(for: request) {
            let image = UIImage(data: cachedData.data)
            return image
        } else {
            return nil
        }
    }
    
    func storeAtCache(data: CachedURLResponse, request: URLRequest) {
        self.cacheStorage.storeCachedResponse(data, for: request)
    }
}
