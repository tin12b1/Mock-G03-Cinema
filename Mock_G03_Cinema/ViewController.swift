//
//  ViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 5/29/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating {
    @IBOutlet var shownButton: UIButton!
    @IBOutlet var nowShowingButton: UIButton!
    @IBOutlet var comingSoonButton: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filtereMovies = [Movie]()
    
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
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.movieTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filtereMovies.count
        }
        else {
            return moviesClass.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie cell", for: indexPath)
        let queue = OperationQueue()
        let movie: Movie
        if searchController.isActive && searchController.searchBar.text != "" {
            movie = filtereMovies[indexPath.row]
        }
        else{
            movie = moviesClass[indexPath.row]
        }
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.genres
        queue.addOperation { () -> Void in
            let url = movie.posterPath
            if let img = Downloader.downloadImageWithURL(url) {
                // Update in main thread
                OperationQueue.main.addOperation({
                    if self.searchController.isActive && self.searchController.searchBar.text != ""{
                        self.posterImage[self.filtereMovies[indexPath.row].id!] = img
                    }
                    else{
                        self.posterImage[self.moviesClass[indexPath.row].id!] = img
                    }
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
        searchController.isActive = false
        searchController.searchBar.text = ""
        nowShowingButton.isSelected = false
        shownButton.isSelected = true
        comingSoonButton.isSelected = false
        getShownMovies()
    }
    
    @IBAction func nowShowingButtonClick(_ sender: Any) {
        searchController.isActive = false
        searchController.searchBar.text = ""
        nowShowingButton.isSelected = true
        shownButton.isSelected = false
        comingSoonButton.isSelected = false
        getNowShowingMovies()
    }
    
    @IBAction func comingSoonButtonClick(_ sender: Any) {
        searchController.isActive = false
        searchController.searchBar.text = ""
        nowShowingButton.isSelected = false
        shownButton.isSelected = false
        comingSoonButton.isSelected = true
        getComingSoonMovies()
    }
    
    // MARK: - Helper Method
    
    func movieAtIndexPath(indexPath: NSIndexPath) -> Movie
    {
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return filtereMovies[indexPath.row]
        }
        else
        {
            return moviesClass[indexPath.row]
        }
    }
    
    func imageAtIndexPath(indexPath: NSIndexPath) -> UIImage
    {
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return posterImage[filtereMovies[indexPath.row].id!]!
        }
        else
        {
            return posterImage[moviesClass[indexPath.row].id!]!
        }
        
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
        self.movieTableView.reloadData()
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
    func filterContentForSearchText(seachText:String)
    {
        filtereMovies = moviesClass.filter{ movie in
            return (movie.title?.lowercased().contains(seachText.lowercased()))!
        }
        movieTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(seachText: searchController.searchBar.text!)
    }
    
    
    
}
