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
    // Today
    @IBOutlet var todayLabel: UILabel!
    @IBOutlet var firstShowTimeButton: UIButton!
    @IBOutlet var secondShowTimeButton: UIButton!
    @IBOutlet var thirdShowTimeButton: UIButton!
    @IBOutlet var styleImageView: UIImageView!
    // Tomorrow
    @IBOutlet var tomorrowLabel: UILabel!
    @IBOutlet var tomorrowFirstShowTimeButton: UIButton!
    @IBOutlet var tomorrowSecondShowTimeButton: UIButton!
    @IBOutlet var tomorrowThirdShowTimeButton: UIButton!
    @IBOutlet var tomorrowStyleImageView: UIImageView!
    // The day after tomorrow
    @IBOutlet var dayAfterTomorrowLabel: UILabel!
    @IBOutlet var afterTomorrowFirstButton: UIButton!
    @IBOutlet var afterTomorrowSecondButton: UIButton!
    @IBOutlet var afterTomorrowThirdButton: UIButton!
    @IBOutlet var afterTomorrowStyleImageView: UIImageView!

    var movie: Movie?
    var posterImg: UIImage?
    let currentDate = Date()

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
        releaseDateLabel.text = "📆 " + (movie?.releaseDate)!
        genresLabel.text = "GENRES: " + (movie?.genres)!
        if let vote = movie?.voteAverage {
            voteAverageLabel.text = "⭐️ \(vote)"
        }
        overviewLabel.text = "OVERVIEW: " + (movie?.overview)!
        if (!isNowShowingMovie()) {
            todayLabel.isHidden = true
            firstShowTimeButton.isHidden = true
            secondShowTimeButton.isHidden = true
            thirdShowTimeButton.isHidden = true
            styleImageView.isHidden = true
            
            tomorrowLabel.isHidden = true
            tomorrowFirstShowTimeButton.isHidden = true
            tomorrowSecondShowTimeButton.isHidden = true
            tomorrowThirdShowTimeButton.isHidden = true
            tomorrowStyleImageView.isHidden = true
            
            dayAfterTomorrowLabel.isHidden = true
            afterTomorrowFirstButton.isHidden = true
            afterTomorrowSecondButton.isHidden = true
            afterTomorrowThirdButton.isHidden = true
            afterTomorrowStyleImageView.isHidden = true
        }
        else if (Struct.getDateFromString(releaseDate: (movie?.releaseDate!)!, interval: 1814400) < currentDate.addingTimeInterval(86400)) {
            firstShowTimeButton.setTitle(movie?.showTimes?[0], for: .normal)
            secondShowTimeButton.setTitle(movie?.showTimes?[1], for: .normal)
            thirdShowTimeButton.setTitle(movie?.showTimes?[2], for: .normal)
            
            tomorrowLabel.isHidden = true
            tomorrowFirstShowTimeButton.isHidden = true
            tomorrowSecondShowTimeButton.isHidden = true
            tomorrowThirdShowTimeButton.isHidden = true
            tomorrowStyleImageView.isHidden = true
            
            dayAfterTomorrowLabel.isHidden = true
            afterTomorrowFirstButton.isHidden = true
            afterTomorrowSecondButton.isHidden = true
            afterTomorrowThirdButton.isHidden = true
            afterTomorrowStyleImageView.isHidden = true
        }
        else if (Struct.getDateFromString(releaseDate: (movie?.releaseDate!)!, interval: 1814400) < currentDate.addingTimeInterval(172800)) {
            firstShowTimeButton.setTitle(movie?.showTimes?[0], for: .normal)
            secondShowTimeButton.setTitle(movie?.showTimes?[1], for: .normal)
            thirdShowTimeButton.setTitle(movie?.showTimes?[2], for: .normal)
            tomorrowFirstShowTimeButton.setTitle(movie?.showTimes?[0], for: .normal)
            tomorrowSecondShowTimeButton.setTitle(movie?.showTimes?[1], for: .normal)
            tomorrowThirdShowTimeButton.setTitle(movie?.showTimes?[2], for: .normal)
            
            dayAfterTomorrowLabel.isHidden = true
            afterTomorrowFirstButton.isHidden = true
            afterTomorrowSecondButton.isHidden = true
            afterTomorrowThirdButton.isHidden = true
            afterTomorrowStyleImageView.isHidden = true
        }
        else {
            firstShowTimeButton.setTitle(movie?.showTimes?[0], for: .normal)
            secondShowTimeButton.setTitle(movie?.showTimes?[1], for: .normal)
            thirdShowTimeButton.setTitle(movie?.showTimes?[2], for: .normal)
            tomorrowFirstShowTimeButton.setTitle(movie?.showTimes?[0], for: .normal)
            tomorrowSecondShowTimeButton.setTitle(movie?.showTimes?[1], for: .normal)
            tomorrowThirdShowTimeButton.setTitle(movie?.showTimes?[2], for: .normal)
            afterTomorrowFirstButton.setTitle(movie?.showTimes?[0], for: .normal)
            afterTomorrowSecondButton.setTitle(movie?.showTimes?[1], for: .normal)
            afterTomorrowThirdButton.setTitle(movie?.showTimes?[2], for: .normal)
            let dayOfWeek = getDayOfWeek(Struct.getDate(interval: 172800))
            dayAfterTomorrowLabel.text = dayOfWeek + ", \(Struct.getDate(interval: 172800))"
        }
        if (isNowShowingMovie()) {
            var showTimeString = Struct.getDate(interval: 0) + " " + (movie?.showTimes?[2])!
            if (currentDate.addingTimeInterval(3600) > Struct.getDateTimeFromString(string: showTimeString, interval: 0)) {
                firstShowTimeButton.isEnabled = false
                secondShowTimeButton.isEnabled = false
                thirdShowTimeButton.isEnabled = false
                firstShowTimeButton.isHidden = true
                secondShowTimeButton.isHidden = true
                thirdShowTimeButton.isHidden = true
                todayLabel.isHidden = true
                styleImageView.isHidden = true
            }
            else {
                showTimeString = Struct.getDate(interval: 0) + " " + (movie?.showTimes?[1])!
                if (currentDate.addingTimeInterval(3600) > Struct.getDateTimeFromString(string: showTimeString, interval: 0)) {
                    firstShowTimeButton.isEnabled = false
                    secondShowTimeButton.isEnabled = false
                }
                else {
                    showTimeString = Struct.getDate(interval: 0) + " " + (movie?.showTimes?[0])!
                    if (currentDate.addingTimeInterval(3600) > Struct.getDateTimeFromString(string: showTimeString, interval: 0)) {
                        firstShowTimeButton.isEnabled = false
                    }
                }
            }
        }
    }
    
    func isNowShowingMovie() -> Bool {
        let currentDate = Date()
        if (Struct.getDateFromString(releaseDate: (movie?.releaseDate!)!, interval: 0) <= currentDate && currentDate <= Struct.getDateFromString(releaseDate: (movie?.releaseDate!)!, interval: 1814400)) {
            return true
        }
        return false
    }
    
    // Return day of week
    func getDayOfWeek(_ today:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate!)
        if weekDay == 1 {
            return "SUNDAY"
        } else if weekDay == 2 {
            return "MONDAY"
        } else if weekDay == 3 {
            return "TUESDAY"
        } else if weekDay == 4 {
            return "WEDNESDAY"
        } else if weekDay == 5 {
            return "THUSDAY"
        } else if weekDay == 6 {
            return "FRIDAY"
        } else {
            return "SATURDAY"
        }
    }
    
    @IBAction func playTrailerButtonClick(_ sender: Any) {
        if (!Reachability.isConnectedToNetwork()) {
            let srcNoInternet = self.storyboard?.instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
            self.present(srcNoInternet, animated: true)
        }
        else {
            performSegue(withIdentifier: "show trailer", sender: self)
        }
    }
    
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "today seats 1":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = movie?.showTimes?[0]
                seatsVC.screeningDate = Struct.getDate(interval: 0)
                break
            case "today seats 2":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = movie?.showTimes?[1]
                seatsVC.screeningDate = Struct.getDate(interval: 0)
                break
            case "today seats 3":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = movie?.showTimes?[2]
                seatsVC.screeningDate = Struct.getDate(interval: 0)
                break
            case "tomorrow seats 1":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = movie?.showTimes?[0]
                seatsVC.screeningDate = Struct.getDate(interval: 86400)
                break
            case "tomorrow seats 2":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = movie?.showTimes?[1]
                seatsVC.screeningDate = Struct.getDate(interval: 86400)
                break
            case "tomorrow seats 3":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = movie?.showTimes?[2]
                seatsVC.screeningDate = Struct.getDate(interval: 86400)
                break
            case "after tomorrow seats 1":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = movie?.showTimes?[0]
                seatsVC.screeningDate = Struct.getDate(interval: 172800)
                break
            case "after tomorrow seats 2":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = movie?.showTimes?[1]
                seatsVC.screeningDate = Struct.getDate(interval: 172800)
                break
            case "after tomorrow seats 3":
                let seatsVC = segue.destination as! SeatsViewController
                seatsVC.movie = movie
                seatsVC.showTimeId = movie?.showTimes?[2]
                seatsVC.screeningDate = Struct.getDate(interval: 172800)
                break
            case "show trailer":
                let youtubeVC = segue.destination as! YoutubeViewController
                youtubeVC.videoCode = movie?.videoCode
                break
                
            default:
                break
            }
        }
    }
}

