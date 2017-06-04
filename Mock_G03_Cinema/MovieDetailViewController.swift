//
//  MovieDetailViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/5/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var voteAverageLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    var movie: Movie?
    var posterImg: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        let srcMain = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
        self.present(srcMain, animated: true)
    }
    
    func setContent() {
        posterImageView.image = posterImg
        titleLabel.text = movie?.title?.uppercased()
        releaseDateLabel.text = "RELEASE DATE: " + (movie?.releaseDate)!
        genresLabel.text = "GENRES: " + (movie?.genres)!
        if let vote = movie?.voteAverage {
            voteAverageLabel.text = "⭐️: \(vote)"
        }
        overviewLabel.text = "OVERVIEW: " + (movie?.overview)!
    }
}
