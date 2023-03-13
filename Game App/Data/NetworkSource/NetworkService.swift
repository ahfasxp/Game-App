//
//  NetworkService.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import Foundation

class NetworkService {
  let baseUrl = "https://api.rawg.io/api"
  let page = 1
  let pageSize = 10
    
  func getGames() async throws -> [GameModel] {
    var components = URLComponents(string: "\(baseUrl)/games")!
    components.queryItems = [
      URLQueryItem(name: "key", value: apiKey),
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "page_size", value: String(pageSize))
    ]
        
    let request = URLRequest(url: components.url!)
        
    let (data, response) = try await URLSession.shared.data(for: request)
        
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      fatalError("Error: Can't fetching data.")
    }
        
    let decoder = JSONDecoder()
    let result = try decoder.decode(GameResponses.self, from: data)
        
    return gameMapper(input: result.results!)
  }
    
  func getDetailGame(id: Int) async throws -> GameDetailModel {
    var components = URLComponents(string: "\(baseUrl)/games/\(id)")!
    components.queryItems = [
      URLQueryItem(name: "key", value: apiKey),
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "page_size", value: String(pageSize))
    ]
        
    let request = URLRequest(url: components.url!)
        
    let (data, response) = try await URLSession.shared.data(for: request)
        
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      fatalError("Error: Can't fetching data.")
    }
        
    let decoder = JSONDecoder()
    let result = try decoder.decode(GameDetailResponse.self, from: data)
        
    return gameDetailMapper(input: result)
  }
}

private extension NetworkService {
  func gameMapper(input gameResponse: [GameResponse]) -> [GameModel] {
    return gameResponse.map { result in
      GameModel(id: result.id ?? 0, name: result.name ?? "", released: result.released, rating: result.rating ?? 0.0, backgroundImage: result.backgroundImage)
    }
  }
    
  func gameDetailMapper(input gameDetailResponse: GameDetailResponse) -> GameDetailModel {
    return GameDetailModel(
      id: gameDetailResponse.id,
      slug: gameDetailResponse.slug,
      name: gameDetailResponse.name,
      nameOriginal: gameDetailResponse.nameOriginal,
      description: gameDetailResponse.description,
      metacritic: gameDetailResponse.metacritic,
      metacriticPlatforms: gameDetailResponse.metacriticPlatforms?.map { e in
        MetacriticPlatformModel(
          metascore: e.metascore ?? 0,
          url: e.url ?? "",
          platform: MetacriticPlatformPlatformModel(
            platform: e.platform?.platform ?? 0,
            name: e.platform?.name ?? "",
            slug: e.platform?.slug ?? ""
          )
        )
      } ?? [],
      released: gameDetailResponse.released,
      tba: gameDetailResponse.tba,
      updated: gameDetailResponse.updated,
      backgroundImage: gameDetailResponse.backgroundImage,
      backgroundImageAdditional: gameDetailResponse.backgroundImageAdditional,
      website: gameDetailResponse.website,
      rating: gameDetailResponse.rating,
      ratingTop: gameDetailResponse.ratingTop,
      ratings: gameDetailResponse.ratings?.map { e in
        RatingModel(
          id: e.id ?? 0,
          title: e.title ?? "",
          count: e.count ?? 0,
          percent: e.percent ?? 0.0
        )
      } ?? [],
      reactions: gameDetailResponse.reactions,
      added: gameDetailResponse.added,
      addedByStatus: AddedByStatusModel(
        yet: gameDetailResponse.addedByStatus?.yet ?? 0,
        owned: gameDetailResponse.addedByStatus?.owned ?? 0,
        beaten: gameDetailResponse.addedByStatus?.beaten ?? 0,
        toplay: gameDetailResponse.addedByStatus?.toplay ?? 0,
        dropped: gameDetailResponse.addedByStatus?.dropped ?? 0,
        playing: gameDetailResponse.addedByStatus?.playing ?? 0
      ),
      playtime: gameDetailResponse.playtime,
      screenshotsCount: gameDetailResponse.screenshotsCount,
      moviesCount: gameDetailResponse.moviesCount,
      creatorsCount: gameDetailResponse.creatorsCount,
      achievementsCount: gameDetailResponse.achievementsCount,
      parentAchievementsCount: gameDetailResponse.parentAchievementsCount,
      redditURL: gameDetailResponse.redditURL,
      redditName: gameDetailResponse.redditName,
      redditDescription: gameDetailResponse.redditDescription,
      redditLogo: gameDetailResponse.redditLogo,
      redditCount: gameDetailResponse.redditCount,
      twitchCount: gameDetailResponse.twitchCount,
      youtubeCount: gameDetailResponse.youtubeCount,
      reviewsTextCount: gameDetailResponse.reviewsTextCount,
      ratingsCount: gameDetailResponse.ratingsCount,
      suggestionsCount: gameDetailResponse.suggestionsCount,
      alternativeNames: gameDetailResponse.alternativeNames,
      metacriticURL: gameDetailResponse.metacriticURL,
      parentsCount: gameDetailResponse.parentsCount,
      additionsCount: gameDetailResponse.additionsCount,
      gameSeriesCount: gameDetailResponse.gameSeriesCount,
      userGame: gameDetailResponse.userGame ?? "",
      reviewsCount: gameDetailResponse.reviewsCount,
      saturatedColor: gameDetailResponse.saturatedColor,
      dominantColor: gameDetailResponse.dominantColor,
      parentPlatforms: gameDetailResponse.parentPlatforms?.map { e in
        ParentPlatformModel(
          platform: EsrbRatingModel(
            id: e.platform?.id ?? 0,
            name: e.platform?.name ?? "",
            slug: e.platform?.slug ?? ""
          )
        )
      } ?? [],
      platforms: gameDetailResponse.platforms?.map { e in
        PlatformElementModel(
          platform: PlatformPlatformModel(
            id: e.platform?.id ?? 0,
            name: e.platform?.name ?? "",
            slug: e.platform?.slug ?? "",
            image: e.platform?.image ?? "",
            yearEnd: e.platform?.yearEnd ?? "",
            yearStart: e.platform?.yearStart,
            gamesCount: e.platform?.gamesCount ?? 0,
            imageBackground: e.platform?.imageBackground ?? ""
          ),
          releasedAt: e.releasedAt ?? "",
          requirements: RequirementsModel(
            minimum: e.requirements?.minimum ?? "",
            recommended: e.requirements?.recommended ?? ""
          )
        )
      } ?? [],
      stores: gameDetailResponse.stores?.map { e in
        StoreModel(
          id: e.id ?? 0,
          url: e.url ?? "",
          store: DeveloperModel(
            id: e.store?.id ?? 0,
            name: e.store?.name ?? "",
            slug: e.store?.slug ?? "",
            gamesCount: e.store?.gamesCount ?? 0,
            imageBackground: e.store?.imageBackground ?? "",
            domain: e.store?.domain,
            language: e.store?.language
          )
        )
      } ?? [],
      developers: gameDetailResponse.developers?.map { e in
        DeveloperModel(
          id: e.id ?? 0,
          name: e.name ?? "",
          slug: e.slug ?? "",
          gamesCount: e.gamesCount ?? 0,
          imageBackground: e.imageBackground ?? "",
          domain: e.domain ?? "",
          language: e.language
        )
      } ?? [],
      genres: gameDetailResponse.genres?.map { e in
        DeveloperModel(
          id: e.id ?? 0,
          name: e.name ?? "",
          slug: e.slug ?? "",
          gamesCount: e.gamesCount ?? 0,
          imageBackground: e.imageBackground ?? "",
          domain: e.domain ?? "",
          language: e.language
        )
      } ?? [],
      tags: gameDetailResponse.tags?.map { e in
        DeveloperModel(
          id: e.id ?? 0,
          name: e.name ?? "",
          slug: e.slug ?? "",
          gamesCount: e.gamesCount ?? 0,
          imageBackground: e.imageBackground ?? "",
          domain: e.domain ?? "",
          language: e.language
        )
      } ?? [],
      publishers: gameDetailResponse.publishers?.map { e in
        DeveloperModel(
          id: e.id ?? 0,
          name: e.name ?? "",
          slug: e.slug ?? "",
          gamesCount: e.gamesCount ?? 0,
          imageBackground: e.imageBackground ?? "",
          domain: e.domain ?? "",
          language: e.language
        )
      } ?? [],
      esrbRating: EsrbRatingModel(
        id: gameDetailResponse.esrbRating?.id ?? 0,
        name: gameDetailResponse.esrbRating?.name ?? "",
        slug: gameDetailResponse.esrbRating?.slug ?? ""
      ),
      clip: gameDetailResponse.clip ?? "",
      descriptionRaw: gameDetailResponse.descriptionRaw
    )
  }
  
  private var apiKey: String {
    // 1
    guard let filePath = Bundle.main.path(forResource: "GameApp-Info", ofType: "plist") else {
      fatalError("Couldn't find file 'GameApp-Info.plist'.")
    }
    // 2
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
    }
    return value
  }
}
