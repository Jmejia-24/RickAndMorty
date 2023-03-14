//
//  ImageCacheManager.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/14/23.
//

import SwiftUI
import Photos

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    private lazy var imageCache = NSCache<NSString, UIImage>()
    private var loadTasks = [PHAsset: PHImageRequestID]()
    
    private let queue = DispatchQueue(label: "ImageDataManagerQueue")
    
    private lazy var imageManager: PHCachingImageManager = {
        let imageManager = PHCachingImageManager()
        imageManager.allowsCachingHighQualityImages = true
        return imageManager
    }()
    
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 90
        configuration.timeoutIntervalForRequest     = 90
        configuration.timeoutIntervalForResource    = 90
        return URLSession(configuration: configuration)
    }()
    
    private init() {}
    
    func download(url: URL?) async throws -> Image {
        guard let url = url else { throw URLError(.badURL) }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return Image(uiImage: cachedImage)
        }
        
        let data = (try await downloadSession.data(from: url)).0
        
        guard let image = UIImage(data: data) else { throw URLError(.badServerResponse) }
        queue.async { [unowned self] in
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
        }
        
        return Image(uiImage: image)
    }
}
