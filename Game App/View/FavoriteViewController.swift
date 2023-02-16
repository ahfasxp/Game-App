//
//  FavoriteViewController.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 15/02/23.
//

import UIKit

class FavoriteViewController: UIViewController {
    private lazy var gameProvider: GameProvider = .init()
    private var games: [GameModel] = []

    @IBOutlet var favoriteTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadGame()
    }

    private func setupTableView() {
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self

        favoriteTableView.register(
            UINib(nibName: "GameTableViewCell", bundle: nil),
            forCellReuseIdentifier: "gameTableViewCell"
        )

        favoriteTableView.register(
            UINib(nibName: "EmptyTableViewCell", bundle: nil),
            forCellReuseIdentifier: "emptyTableViewCell"
        )
    }

    private func loadGame() {
        gameProvider.getAllGame { result in
            DispatchQueue.main.async {
                self.games = result
                self.favoriteTableView.reloadData()
            }
        }
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count == 0 ? 1 : games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if games.count == 0 {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "emptyTableViewCell",
                for: indexPath
            ) as? EmptyTableViewCell {
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "gameTableViewCell",
                for: indexPath
            ) as? GameTableViewCell {
                let game = games[indexPath.row]

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM, yyyy"

                cell.gameImage.image = game.image
                cell.gameName.text = game.name
                cell.gameDate.text = dateFormatter.string(from: game.released)
                cell.gameRating.text = String(game.rating)

                if game.state == .new {
                    cell.loadingIndicator.isHidden = false
                    cell.loadingIndicator.startAnimating()
                    startDownload(game: game, indexPath: indexPath)
                } else {
                    cell.loadingIndicator.stopAnimating()
                    cell.loadingIndicator.isHidden = true
                }

                // Cell selected color
                let bgColorView = UIView()
                bgColorView.backgroundColor = UIColor.white
                cell.selectedBackgroundView = bgColorView

                return cell
            } else {
                return UITableViewCell()
            }
        }
    }

    fileprivate func startDownload(game: GameModel, indexPath: IndexPath) {
        let imageDownloader = ImageDownloader()
        if game.state == .new {
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(url: game.backgroundImage)
                    game.state = .downloaded
                    game.image = image
                    self.favoriteTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        }
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let game = games[indexPath.row]
        performSegue(withIdentifier: "favoriteToDetail", sender: game)
    }

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "favoriteToDetail" {
            if let detaiViewController = segue.destination as? DetailViewController {
                detaiViewController.game = sender as? GameModel
            }
        }
    }
}
