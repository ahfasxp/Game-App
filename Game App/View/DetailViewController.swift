//
//  DetailViewController.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 05/02/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var gameImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        gameImage.image = UIImage(named: "Ahfas")
        gameImage.layer.cornerRadius = 8
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
