//
//  ViewController.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import UIKit

class ViewController: UIViewController {
    private let refreshControl = UIRefreshControl()
    private var games: [GameModel] = []
    
    @IBOutlet var gameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        Task {
            await getGames()
        }
    }
    
    private func setupTableView() {
        gameTableView.dataSource = self
        gameTableView.delegate = self
        
        gameTableView.register(
            UINib(nibName: "GameTableViewCell", bundle: nil),
            forCellReuseIdentifier: "gameTableViewCell"
        )
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            gameTableView.refreshControl = refreshControl
        } else {
            gameTableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshGameData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Game Data ...")
    }
    
    @objc private func refreshGameData(_ sender: Any) {
        Task {
            await getGames()
            refreshControl.endRefreshing()
        }
    }
    
    private func getGames() async {
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
            
            // Cell selected color
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = bgColorView
            
            return cell
        } else {
            return UITableViewCell()
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
                detaiViewController.game = sender as? GameModel
            }
        }
    }
}
