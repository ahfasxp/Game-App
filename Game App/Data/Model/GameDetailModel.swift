//
//  GameDetailModel.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gameDetailModel = try? JSONDecoder().decode(GameDetailModel.self, from: jsonData)

// MARK: - GameDetailModel

class GameDetailModel {
  let id: Int?
  let slug, name, nameOriginal, description: String?
  let metacritic: Int?
  let metacriticPlatforms: [MetacriticPlatformModel]
  let released: String?
  let tba: Bool?
  let updated: String?
  let backgroundImage, backgroundImageAdditional: String?
  let website: String?
  let rating: Double?
  let ratingTop: Int?
  let ratings: [RatingModel]
  let reactions: [String: Int]?
  let added: Int?
  let addedByStatus: AddedByStatusModel
  let playtime, screenshotsCount, moviesCount, creatorsCount: Int?
  let achievementsCount, parentAchievementsCount: Int?
  let redditURL: String?
  let redditName, redditDescription, redditLogo: String?
  let redditCount, twitchCount, youtubeCount, reviewsTextCount: Int?
  let ratingsCount, suggestionsCount: Int?
  let alternativeNames: [String]?
  let metacriticURL: String?
  let parentsCount, additionsCount, gameSeriesCount: Int?
  let userGame: Any
  let reviewsCount: Int?
  let saturatedColor, dominantColor: String?
  let parentPlatforms: [ParentPlatformModel]
  let platforms: [PlatformElementModel]
  let stores: [StoreModel]
  let developers, genres, tags, publishers: [DeveloperModel]
  let esrbRating: EsrbRatingModel
  let clip: Any
  let descriptionRaw: String?

  init(
    id: Int?,
    slug: String?,
    name: String?,
    nameOriginal: String?,
    description: String?,
    metacritic: Int?,
    metacriticPlatforms: [MetacriticPlatformModel],
    released: String?,
    tba: Bool?,
    updated: String?,
    backgroundImage: String?,
    backgroundImageAdditional: String?,
    website: String?,
    rating: Double?,
    ratingTop: Int?,
    ratings: [RatingModel],
    reactions: [String: Int]?,
    added: Int?,
    addedByStatus: AddedByStatusModel,
    playtime: Int?,
    screenshotsCount: Int?,
    moviesCount: Int?,
    creatorsCount: Int?,
    achievementsCount: Int?,
    parentAchievementsCount: Int?,
    redditURL: String?,
    redditName: String?,
    redditDescription: String?,
    redditLogo: String?,
    redditCount: Int?,
    twitchCount: Int?,
    youtubeCount: Int?,
    reviewsTextCount: Int?,
    ratingsCount: Int?,
    suggestionsCount: Int?,
    alternativeNames: [String]?,
    metacriticURL: String?,
    parentsCount: Int?,
    additionsCount: Int?,
    gameSeriesCount: Int?,
    userGame: Any,
    reviewsCount: Int?,
    saturatedColor: String?,
    dominantColor: String?,
    parentPlatforms: [ParentPlatformModel],
    platforms: [PlatformElementModel],
    stores: [StoreModel],
    developers: [DeveloperModel],
    genres: [DeveloperModel],
    tags: [DeveloperModel],
    publishers: [DeveloperModel],
    esrbRating: EsrbRatingModel,
    clip: Any,
    descriptionRaw: String?
  ) {
    self.id = id
    self.slug = slug
    self.name = name
    self.nameOriginal = nameOriginal
    self.description = description
    self.metacritic = metacritic
    self.metacriticPlatforms = metacriticPlatforms
    self.released = released
    self.tba = tba
    self.updated = updated
    self.backgroundImage = backgroundImage
    self.backgroundImageAdditional = backgroundImageAdditional
    self.website = website
    self.rating = rating
    self.ratingTop = ratingTop
    self.ratings = ratings
    self.reactions = reactions
    self.added = added
    self.addedByStatus = addedByStatus
    self.playtime = playtime
    self.screenshotsCount = screenshotsCount
    self.moviesCount = moviesCount
    self.creatorsCount = creatorsCount
    self.achievementsCount = achievementsCount
    self.parentAchievementsCount = parentAchievementsCount
    self.redditURL = redditURL
    self.redditName = redditName
    self.redditDescription = redditDescription
    self.redditLogo = redditLogo
    self.redditCount = redditCount
    self.twitchCount = twitchCount
    self.youtubeCount = youtubeCount
    self.reviewsTextCount = reviewsTextCount
    self.ratingsCount = ratingsCount
    self.suggestionsCount = suggestionsCount
    self.alternativeNames = alternativeNames
    self.metacriticURL = metacriticURL
    self.parentsCount = parentsCount
    self.additionsCount = additionsCount
    self.gameSeriesCount = gameSeriesCount
    self.userGame = userGame
    self.reviewsCount = reviewsCount
    self.saturatedColor = saturatedColor
    self.dominantColor = dominantColor
    self.parentPlatforms = parentPlatforms
    self.platforms = platforms
    self.stores = stores
    self.developers = developers
    self.genres = genres
    self.tags = tags
    self.publishers = publishers
    self.esrbRating = esrbRating
    self.clip = clip
    self.descriptionRaw = descriptionRaw
  }
}

// MARK: - AddedByStatus

class AddedByStatusModel {
  let yet, owned, beaten, toplay: Int
  let dropped, playing: Int

  init(yet: Int, owned: Int, beaten: Int, toplay: Int, dropped: Int, playing: Int) {
    self.yet = yet
    self.owned = owned
    self.beaten = beaten
    self.toplay = toplay
    self.dropped = dropped
    self.playing = playing
  }
}

// MARK: - Developer

class DeveloperModel {
  let id: Int
  let name, slug: String
  let gamesCount: Int
  let imageBackground: String
  let domain: String?
  let language: Language?

  init(id: Int, name: String, slug: String, gamesCount: Int, imageBackground: String, domain: String?, language: Language?) {
    self.id = id
    self.name = name
    self.slug = slug
    self.gamesCount = gamesCount
    self.imageBackground = imageBackground
    self.domain = domain
    self.language = language
  }
}

enum LanguageModel {
  case eng
}

// MARK: - EsrbRating

class EsrbRatingModel {
  let id: Int
  let name, slug: String

  init(id: Int, name: String, slug: String) {
    self.id = id
    self.name = name
    self.slug = slug
  }
}

// MARK: - MetacriticPlatform

class MetacriticPlatformModel {
  let metascore: Int
  let url: String
  let platform: MetacriticPlatformPlatformModel

  init(metascore: Int, url: String, platform: MetacriticPlatformPlatformModel) {
    self.metascore = metascore
    self.url = url
    self.platform = platform
  }
}

// MARK: - MetacriticPlatformPlatform

class MetacriticPlatformPlatformModel {
  let platform: Int
  let name, slug: String

  init(platform: Int, name: String, slug: String) {
    self.platform = platform
    self.name = name
    self.slug = slug
  }
}

// MARK: - ParentPlatform

class ParentPlatformModel {
  let platform: EsrbRatingModel

  init(platform: EsrbRatingModel) {
    self.platform = platform
  }
}

// MARK: - PlatformElement

class PlatformElementModel {
  let platform: PlatformPlatformModel
  let releasedAt: String
  let requirements: RequirementsModel

  init(platform: PlatformPlatformModel, releasedAt: String, requirements: RequirementsModel) {
    self.platform = platform
    self.releasedAt = releasedAt
    self.requirements = requirements
  }
}

// MARK: - PlatformPlatform

class PlatformPlatformModel {
  let id: Int
  let name, slug: String
  let image, yearEnd: Any
  let yearStart: Int?
  let gamesCount: Int
  let imageBackground: String

  init(id: Int, name: String, slug: String, image: Any, yearEnd: Any, yearStart: Int?, gamesCount: Int, imageBackground: String) {
    self.id = id
    self.name = name
    self.slug = slug
    self.image = image
    self.yearEnd = yearEnd
    self.yearStart = yearStart
    self.gamesCount = gamesCount
    self.imageBackground = imageBackground
  }
}

// MARK: - Requirements

class RequirementsModel {
  let minimum, recommended: String?

  init(minimum: String?, recommended: String?) {
    self.minimum = minimum
    self.recommended = recommended
  }
}

// MARK: - Rating

class RatingModel {
  let id: Int
  let title: String
  let count: Int
  let percent: Double

  init(id: Int, title: String, count: Int, percent: Double) {
    self.id = id
    self.title = title
    self.count = count
    self.percent = percent
  }
}

// MARK: - Store

class StoreModel {
  let id: Int
  let url: String
  let store: DeveloperModel

  init(id: Int, url: String, store: DeveloperModel) {
    self.id = id
    self.url = url
    self.store = store
  }
}
