//
//  GameTableViewCell.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet var gameName: UILabel!
    @IBOutlet var gameDate: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var gameRating: UILabel!
    @IBOutlet var gameImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        gameImage.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
