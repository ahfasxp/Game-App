//
//  DetailViewController.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import UIKit

class DetailViewController: UIViewController {
  var game: GameModel?

  private lazy var gameProvider: GameProvider = .init()
  private var gameDetail: GameDetailModel?
  private var isFavorite: Bool = false

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
  @IBOutlet var favoriteView: UIView!
  @IBOutlet var favoriteImage: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let result = game {
      showLoading(value: true)
      gameProvider.getGame(result.id) { _ in
        DispatchQueue.main.async {
          self.isFavorite = true
        }
      }
      Task {
        await getDetailGame(id: result.id)
        reloadView()
        showLoading(value: false)
      }
    }
  }

  private func showLoading(value: Bool) {
    gameImage.isHidden = value
    gameName.isHidden = value
    gameRatingCount.isHidden = value
    gameRating.isHidden = value
    gameRatingTop.isHidden = value
    aboutView.isHidden = value
    detailView.isHidden = value
    favoriteView.isHidden = value

    loadingIndicator.isHidden = !value
    (value) ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
  }

  private func reloadView() {
    if let result = gameDetail {
      gameImage.image = game?.image
      gameImage.layer.cornerRadius = 8
      favoriteView.layer.cornerRadius = favoriteView.frame.height / 2

      gameName.text = result.name
      gameRatingCount.text = "\(String(result.ratingsCount!)) Rating"
      gameRating.text = "⭐ \(String(result.rating!))"
      gameRatingTop.text = "🔝 \(String(result.ratingTop!))"
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

      if isFavorite {
        favoriteImage.image = UIImage(systemName: "heart.fill")
      }

      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
      favoriteImage.isUserInteractionEnabled = true
      favoriteImage.addGestureRecognizer(tapGestureRecognizer)
    }
  }

  @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    if tapGestureRecognizer.view is UIImageView {
      if isFavorite {
        if let result = game {
          gameProvider.deleteGame(result.id) {
            DispatchQueue.main.async {
              self.favoriteImage.image = UIImage(systemName: "heart")
              Toast.showToast(message: "Delete to favorite", font: .systemFont(ofSize: 12.0), view: self.view)
            }
          }
        }
      } else {
        if let result = game {
          gameProvider.createGame(result.id, result.name, result.released, result.rating, result.backgroundImage) {
            DispatchQueue.main.async {
              self.favoriteImage.image = UIImage(systemName: "heart.fill")
              Toast.showToast(message: "Add to favorite", font: .systemFont(ofSize: 12.0), view: self.view)
            }
          }
        }
      }

      isFavorite = !isFavorite
    }
  }

  private func getDetailGame(id: Int) async {
    let networkService = NetworkService()
    do {
      gameDetail = try await networkService.getDetailGame(id: id)
    } catch {
      fatalError("Error: Connection Failed.")
    }
  }
}
