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
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie cell", for: indexPath)
        
        cell.textLabel?.text = "Movie"
        cell.detailTextLabel?.text = "My favorite movie is Transformer!"
        
        return cell
    }
    
    func getMoviesList() {
        let databaseRef = Database.database().reference()
        var listMovie = [String:Any]()
        databaseRef.child("movies").observe(.childAdded, with: {snapshot in
            listMovie = snapshot.value as! Dictionary<String, AnyObject>
        })
        /*
        for movie in listMovie {
            movies.append(Movie(json: movie))
        }
        print(movies) */
        print("Data: \(listMovie)")
    }

}

