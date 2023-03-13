//
//  GameModel.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import UIKit

enum DownloadState {
  case new, downloaded, failed
}

class GameModel {
  let id: Int
  let name: String
  let released: Date
  let rating: Double
  let backgroundImage: URL
    
  var image: UIImage?
  var state: DownloadState = .new
    
  init(id: Int, name: String, released: Date, rating: Double, backgroundImage: URL) {
    self.id = id
    self.name = name
    self.released = released
    self.rating = rating
    self.backgroundImage = backgroundImage
  }
}

struct GameResponses: Codable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [GameResponse]?
}

struct GameResponse: Codable {
  let id: Int?
  let name: String?
  let released: Date
  let rating: Double?
  let backgroundImage: URL
    
  enum CodingKeys: String, CodingKey {
    case id, name, released, rating
    case backgroundImage = "background_image"
  }
    
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
        
    // Menentukan alamat gambar
    let path = try container.decode(String.self, forKey: .backgroundImage)
    backgroundImage = URL(string: path)!
        
    // Menentukan tanggal rilis dan di convert String ke Data
    let dateString = try container.decode(String.self, forKey: .released)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    released = dateFormatter.date(from: dateString)!
        
    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    rating = try container.decode(Double.self, forKey: .rating)
  }
}
