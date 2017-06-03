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
    
    @IBOutlet var movieTableView: UITableView!
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieTableView.dataSource = self
        self.movieTableView.delegate = self
        getMoviesList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func accountButtonClick(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            performSegue(withIdentifier: "show account", sender: self)
        } else {
            // No user is signed in.
            performSegue(withIdentifier: "show login", sender: self)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie cell", for: indexPath)
        
        cell.textLabel?.text = "Movie"
        cell.detailTextLabel?.text = "My favorite movie is Transformer!"
        
        return cell
    }
    
    func getMoviesList() {
        let databaseRef = Database.database().reference()
        databaseRef.child("movies").observe(.childAdded, with: {snapshot in
            let snapshotValue = snapshot.value as? NSDictionary
            let title = snapshotValue?["title"] as? String
            let genres = snapshotValue?["genres"] as? String
            let movieId = snapshotValue?["id"] as? Int
            let voteAverage = snapshotValue?["vote_average"] as? Double
            let releaseDate = snapshotValue?["release_date"] as? String
            let overview = snapshotValue?["overview"] as? String
            let posterPath = snapshotValue?["poster_path"] as? String
            print(title!)
   //         print(genres!)
//            print(id!)
            print(voteAverage!)
 //           print(releaseDate!)
 //           print(overview!)
 //           print(posterPath!)
            self.movies.append(Movie(id: movieId, title: title, posterPath: posterPath, overview: overview, releaseDate: releaseDate, voteAverage: voteAverage, genres: genres, image: #imageLiteral(resourceName: "timthumb.php")))
        })
    }

}

