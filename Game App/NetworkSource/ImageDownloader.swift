//
//  ImageDownloader.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import Foundation
import UIKit

class ImageDownloader {
    
    func downloadImage(url: URL) async throws -> UIImage {
        async let imageData: Data = try Data(contentsOf: url)
        return UIImage(data: try await imageData)!
    }
}
