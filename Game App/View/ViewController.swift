//
//  ViewController.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var gameTableView: UITableView!
    
    private var games: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        
        gameTableView.register(
            UINib(nibName: "GameTableViewCell", bundle: nil),
            forCellReuseIdentifier: "gameTableViewCell"
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await getGames()
        }
    }
    
    func getGames() async {
        let networkService = NetworkService()
        do {
            games = try await networkService.getGames()
            gameTableView.reloadData()
        } catch {
            fatalError("Error: Connection Failed.")
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    fileprivate func startDownload(game: Game, indexPath: IndexPath) {
        let imageDownloader = ImageDownloader()
        if game.state == .new {
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(url: game.backgroundImage)
                    game.state = .downloaded
                    game.image = image
                    self.gameTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let game = games[indexPath.row]
        performSegue(withIdentifier: "moveToDetail", sender: game)
    }

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "moveToDetail" {
            if let detaiViewController = segue.destination as? DetailViewController {
                detaiViewController.game = sender as? Game
            }
        }
    }
}
