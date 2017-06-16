//
//  CheckoutViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/16/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class CheckoutViewController: UIViewController {
    
    let databaseRef = Database.database().reference()
    let userId = Auth.auth().currentUser?.uid
    var movie: Movie?
    var showTimeId: String?
    var bookedSeats: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonClick(_ sender: Any) {
        var showTime = "11:00"
        if (showTimeId == "S2")  {
            showTime = "17:00"
        }
        else if (showTimeId == "S3") {
            showTime = "21:00"
        }
        if let ticketCount = bookedSeats?.count {
            for i in 0...ticketCount - 1 {
                if let movieId = movie?.id, let seatId = bookedSeats?[i]{
                    databaseRef.child("movies").child("\(movieId)").child("screening").child(showTimeId!).child(seatId).setValue(["id": seatId,
                                                                                                                                  "status": 0])
                }

            }
        }
        if let movieId = movie?.id, let movieTitle = movie?.title, let firstSeat = bookedSeats?[0] {
            databaseRef.child("users").child(userId!).child("booking").child("\(movieId)-\(showTime)-\(firstSeat)").setValue(["movie": movieId,
                                                                                                                                   "title": movieTitle,
                                                                                                                                   "seats": bookedSeats!,
                                                                                                                                   "show_time": showTime,
                                                                                                                                   "payment_status": 1])
        }
    }

}
