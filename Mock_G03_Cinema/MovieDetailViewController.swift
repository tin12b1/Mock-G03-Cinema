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
    @IBOutlet var firstShowTimeButton: UIButton!
    @IBOutlet var secondShowTimeButton: UIButton!
    @IBOutlet var thirdShowTimeButton: UIButton!
    
    @IBOutlet var styleImageView: UIImageView!
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func setContent() {
        posterImageView.image = posterImg
        titleLabel.text = movie?.title?.uppercased()
        releaseDateLabel.text = "RELEASE DATE: " + (movie?.releaseDate)!
        genresLabel.text = "GENRES: " + (movie?.genres)!
        if let vote = movie?.voteAverage {
            voteAverageLabel.text = "VOTE AVERAGE: \(vote)⭐️"
        }
        overviewLabel.text = "OVERVIEW: " + (movie?.overview)!
        if (isNowShowingMovie()) {
            firstShowTimeButton.isHidden = true
            secondShowTimeButton.isHidden = true
            thirdShowTimeButton.isHidden = true
        }
        else {
            firstShowTimeButton.isHidden = false
            secondShowTimeButton.isHidden = false
            thirdShowTimeButton.isHidden = false
        }
    }
    
    func isNowShowingMovie() -> Bool {
        let currentDate = Date()
        if (Struct.getDateFromString(releaseDate: (movie?.releaseDate!)!, interval: 86400) <= currentDate && currentDate <= Struct.getDateFromString(releaseDate: (movie?.releaseDate!)!, interval: 1814400)) {
            return false
        }
        return true
    }
    
    @IBAction func firstShowTimeButtonClick(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            // No user is signed in.
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.present(loginVC, animated: true)
        }
    }
    
    @IBAction func secondShowTimeButtonClick(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            // No user is signed in.
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.present(loginVC, animated: true)
        }
    }
    
    @IBAction func thirdShowTimeButtonClick(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            // No user is signed in.
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.present(loginVC, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show seats 1":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = "S1"
                break
            case "show seats 2":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = "S2"
                break
            case "show seats 3":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = "S3"
                break
                
            default:
                break
            }
        }
    }
}
