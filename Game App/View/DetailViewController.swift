//
//  DetailViewController.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import UIKit

class DetailViewController: UIViewController {
    var game: Game?

    private var gameDetail: GameDetailModel?

    @IBOutlet var detailView: UIStackView!
    @IBOutlet var aboutView: UIStackView!
    @IBOutlet var gameImage: UIImageView!
    @IBOutlet var gameName: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var gameRatingTop: UILabel!
    @IBOutlet var gamePlatform: UILabel!
    @IBOutlet var gameGenre: UILabel!
    @IBOutlet var gameDeveloper: UILabel!
    @IBOutlet var gameReleaseDate: UILabel!
    @IBOutlet var gamePublisher: UILabel!

    @IBOutlet var gameWebsite: UILabel!
    @IBOutlet var gameAbout: UILabel!
    @IBOutlet var gameRating: UILabel!
    @IBOutlet var gameRatingCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        showLoading(value: true)

        if let result = game {
            Task {
                await getDetailGame(id: result.id)
                if let result = gameDetail {
                    gameImage.image = game?.image
                    gameImage.layer.cornerRadius = 8

                    gameName.text = result.name
                    gameRatingCount.text = "\(String(result.ratingsCount!)) Rating"
                    gameRating.text = "#\(String(result.rating!))"
                    gameRatingTop.text = "#\(String(result.ratingTop!))"
                    gameAbout.text = result.descriptionRaw

                    var platforms: [String] = []
                    for item in result.platforms {
                        platforms.append(item.platform.name)
                    }
                    gamePlatform.text = platforms.joined(separator: ", ")

                    let genres: [String] = result.genres.map { i in
                        i.name
                    }
                    gameGenre.text = genres.joined(separator: ", ")

                    gameReleaseDate.text = result.released

                    let developers: [String] = result.developers.map { i in
                        i.name
                    }
                    gameDeveloper.text = developers.joined(separator: ", ")

                    let publishers: [String] = result.publishers.map { i in
                        i.name
                    }
                    gamePublisher.text = publishers.joined(separator: ", ")

                    gameWebsite.text = result.website
                }
                showLoading(value: false)
            }
        }
    }

    func showLoading(value: Bool) {
        gameImage.isHidden = value
        gameName.isHidden = value
        gameRatingCount.isHidden = value
        gameRating.isHidden = value
        gameRatingTop.isHidden = value
        aboutView.isHidden = value
        detailView.isHidden = value

        loadingIndicator.isHidden = !value
        (value) ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }

    func getDetailGame(id: Int) async {
        let networkService = NetworkService()
        do {
            gameDetail = try await networkService.getDetailGame(id: id)
        } catch {
            fatalError("Error: Connection Failed.")
        }
    }
}
