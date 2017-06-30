//
//  DAOMovies.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/29/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DAOMovies {
    
    static func getMoviesList(completionHandler: @escaping (_ moviesList: [Movie]?, _ error: String?) -> Void) {
        var moviesList: [Movie] = []
        let databaseRef = Database.database().reference()
        databaseRef.child("movies").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                moviesList = []
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        if let postDict = snap.value as? [String: AnyObject] {
                            let movieModel = Movie(json: postDict)
                            moviesList.append(movieModel)
                        }
                    }
                }
                completionHandler(moviesList, nil)
            } else {
                let error = "Movie list empty or problem when get data from firebase!"
                completionHandler(nil, error)
            }
        })
    }

    static func getSeatsList(_ movieId: Int,_ screeningDate: String,_ showTime: String, completionHandler: @escaping (_ seatsList: [Seat]?, _ error: String?) -> Void) {
        var seatsList: [Seat] = []
        let databaseRef = Database.database().reference()
        databaseRef.child("movies").child("\(movieId)").child("screening").child(screeningDate).child(showTime).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                seatsList = []
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        if let postDict = snap.value as? [String: AnyObject] {
                            let seatModel = Seat(json: postDict)
                            seatsList.append(seatModel)
                        }
                    }
                }
                completionHandler(seatsList, nil)
            } else {
                let error = "Seat empty or problem when get data from firebase!"
                completionHandler(nil, error)
            }
        })
    }
}
