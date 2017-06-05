//
//  ViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 5/29/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var shownButton: UIButton!
    @IBOutlet var nowShowingButton: UIButton!
    @IBOutlet var comingSoonButton: UIButton!
    
    @IBOutlet var movieTableView: UITableView!
    var movies = [Movie]()
    var moviesClass = [Movie]()
    var posterImage: [Int:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieTableView.dataSource = self
        self.movieTableView.delegate = self
        getMoviesList()
        // getNowShowingMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func accountButtonClick(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let srcUserInfo = self.storyboard?.instantiateViewController(withIdentifier: "userInfo") as! AccountViewController
            self.present(srcUserInfo, animated: true)
        } else {
            // No user is signed in.
            performSegue(withIdentifier: "show login", sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesClass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie cell", for: indexPath)
        let queue = OperationQueue()
        let movie = moviesClass[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.genres
        queue.addOperation { () -> Void in
            let url = movie.posterPath
            if let img = Downloader.downloadImageWithURL(url) {
                // Update in main thread
                OperationQueue.main.addOperation({
                    self.posterImage[self.moviesClass[indexPath.row].id!] = img
                    cell.imageView?.image = img
                })
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show movie detail":
                let movieDetailVC = segue.destination as! MovieDetailViewController
                if let indexPath = self.movieTableView.indexPathForSelectedRow {
                    movieDetailVC.movie = movieAtIndexPath(indexPath: indexPath as NSIndexPath)
                    movieDetailVC.posterImg = imageAtIndexPath(indexPath: indexPath as NSIndexPath)
                }
                break
                
            default:
                break
            }
        }
    }
    
    @IBAction func shownButtonClick(_ sender: Any) {
        nowShowingButton.isSelected = false
        shownButton.isSelected = true
        comingSoonButton.isSelected = false
        getShownMovies()
    }
    
    @IBAction func nowShowingButtonClick(_ sender: Any) {
        nowShowingButton.isSelected = true
        shownButton.isSelected = false
        comingSoonButton.isSelected = false
        getNowShowingMovies()
    }
    
    @IBAction func comingSoonButtonClick(_ sender: Any) {
        nowShowingButton.isSelected = false
        shownButton.isSelected = false
        comingSoonButton.isSelected = true
        getComingSoonMovies()
    }
    
    // MARK: - Helper Method
    
    func movieAtIndexPath(indexPath: NSIndexPath) -> Movie
    {
        return moviesClass[indexPath.row]
    }
    
    func imageAtIndexPath(indexPath: NSIndexPath) -> UIImage
    {
        return posterImage[moviesClass[indexPath.row].id!]!
        
    }
    
    func getDateFromString(releaseDate: String, interval: Double) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.date(from: releaseDate)
        date?.addTimeInterval(interval)
        return date!
    }
    
    func getNowShowingMovies() {
        moviesClass.removeAll()
        let currentDate = Date()
        for movie in movies {
            if (getDateFromString(releaseDate: movie.releaseDate!, interval: 86400) <= currentDate && currentDate <= getDateFromString(releaseDate: movie.releaseDate!, interval: 1814400)) {
                // Movie will be stop showing after release 20 days
                moviesClass.append(movie)
            }
        }
        DispatchQueue.main.async {
            self.movieTableView.reloadData()
        }
    }
    
    func getShownMovies() {
        moviesClass.removeAll()
        let currentDate = Date()
        for movie in movies {
            if (getDateFromString(releaseDate: movie.releaseDate!, interval: 1814400) < currentDate) {
                // Movie will be stop showing after release 20 days
                moviesClass.append(movie)
            }
        }
        movieTableView.reloadData()
    }
    
    func getComingSoonMovies() {
        moviesClass.removeAll()
        let currentDate = Date()
        for movie in movies {
            if (getDateFromString(releaseDate: movie.releaseDate!, interval: 86400) > currentDate) {
                // Release date > Current date
                moviesClass.append(movie)
            }
        }
        movieTableView.reloadData()
    }
    
    func getMoviesList() {
        let databaseRef = Database.database().reference()
        databaseRef.child("movies").observe(.childAdded, with: {snapshot in
            let snapshotValue = snapshot.value as? NSDictionary
            self.movies.append(Movie(json: snapshotValue as! [String : Any]))
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
            self.getNowShowingMovies()
        })
    }
}
