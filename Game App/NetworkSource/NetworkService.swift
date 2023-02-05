//
//  NetworkService.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import Foundation
class NetworkService{
    let baseUrl = "https://api.rawg.io/api"
    let apiKey = "190c86d2a9d94ef7af22cae8308d1d0b"
    let page = 1
    let pageSize = 10
    
    func getGames() async throws -> [Game]{
        var components = URLComponents(string: "\(baseUrl)/games")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "page_size", value: String(pageSize))
        ]
        
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            fatalError("Error: Can't fetching data.")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponses.self, from: data)
        
        return gameMapper(input: result.results!)
    }
}

extension NetworkService{
    fileprivate func gameMapper(input gameResponse: [GameResponse]) -> [Game]{
        return gameResponse.map{ result in
            return Game(name: result.name ?? "", released:result.released, rating: result.rating ?? 0.0, backgroundImage: result.backgroundImage)
        }
    }
}
