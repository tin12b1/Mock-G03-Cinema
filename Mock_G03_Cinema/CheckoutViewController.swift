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
    var showTime: String?
    var bookedSeats: [String]?
    var screeningDate: String?

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
        if let ticketCount = bookedSeats?.count {
            for i in 0...ticketCount - 1 {
                if let movieId = movie?.id, let seatId = bookedSeats?[i]{
                    DAOBooking.setSeatStatus(movieId, screeningDate!, showTime!, seatId, 0, completionHandler: { (error) in
                        if error != nil {
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                        }
                    })
                }

            }
        }
        if let movieId = movie?.id, let movieTitle = movie?.title, let firstSeat = bookedSeats?[0], let ticketCount = bookedSeats?.count, let date = screeningDate, let showTime = showTime {
            DAOBooking.saveTicketsToUser(movieId, movieTitle, date, showTime, bookedSeats!, 100000*ticketCount, userId!, firstSeat, completionHandler: { (error) in
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                }
            })
        }
        let alertView = UIAlertController(title: "Success", message: "Checkout completed, please check in your account info!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }

}
