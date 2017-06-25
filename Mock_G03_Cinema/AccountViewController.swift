//
//  AccountViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/1/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var bookingTableView: UITableView!
    
    let databaseRef = Database.database().reference()
    let userId = Auth.auth().currentUser?.uid
    var bookings = [Booking]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookingTableView.dataSource = self
        self.bookingTableView.delegate = self
        getUserInfo()
        getBookingList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Log out
    @IBAction func logOutButtonClick(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let srcView = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
            self.present(srcView, animated: true)
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func changePasswordButtonClick(_ sender: Any) {
    }
    
    func getUserInfo() {
        databaseRef.child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user info and show to view
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String
            let age = value?["age"] as? Int
            let address = value?["address"] as? String
            self.nameLabel.text = name
            self.ageLabel.text = String(age!)
            self.addressLabel.text = address
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func homeButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booking cell", for: indexPath) as! BookingTableViewCell
        let booking: Booking
        booking = bookings[indexPath.row]
        if booking.movieId != nil {
            cell.configureCell(title: booking.title!, seats: (booking.seats?.joined(separator: "-"))!, showTime: booking.showTime!, totalPrice: booking.totalPrice!, checkoutStatus: booking.paymentStatus!, date: booking.screeningDate!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "LIST OF SEATS YOU BOOKED"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let booking: Booking
        booking = bookings[indexPath.row]
        if booking.paymentStatus == 0 {
            let questionController = UIAlertController(title: "What you want to do?", message: nil, preferredStyle: .alert)
            questionController.addAction(UIAlertAction(title: "Delete Booking", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                print("Delete")
                if let ticketCount = booking.seats?.count, let movieId = booking.movieId, let showTime = booking.showTime, let seats = booking.seats, let date = booking.screeningDate {
                    for i in 0...ticketCount - 1 {
                        self.databaseRef.child("movies").child("\(movieId)").child("screening").child("\(date)").child("\(showTime)").child(seats[i]).setValue(["id": seats[i],
                                                                                                                                "status": 1])
                    }
                    self.databaseRef.child("users").child(self.userId!).child("booking").child("\(movieId)-\(date)-\(showTime)-\(seats[0])").removeValue()
                }
                self.bookings.removeAll()
                self.getBookingList()
                if self.bookings.count == 0 {
                    self.dismiss(animated: true, completion: nil)
                }
            }))
            
            questionController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                print("Cancel")
            }))
            
            present(questionController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper Method
    
    func getBookingList() {
        databaseRef.child("users").child(userId!).child("booking").observe(.childAdded, with: {snapshot in
            let snapshotValue = snapshot.value as? NSDictionary
            self.bookings.append(Booking(json: snapshotValue as! [String : Any]))
            DispatchQueue.main.async {
                self.bookingTableView.reloadData()
            }
            self.checkPaymentDeadline()
        })
    }
    
    func checkPaymentDeadline() {
        for booking in bookings {
            if booking.paymentStatus == 0 {
                let bookedTime = Struct.getDateTimeFromString(string: booking.bookedTime!, interval: 1800)
                let currentDate = Date()
                if (currentDate > bookedTime) {
                    for seat in booking.seats! {
                        if let movieId = booking.movieId, let showTime = booking.showTime, let date = booking.screeningDate {
                            databaseRef.child("movies").child("\(movieId)").child("screening").child("\(date)").child("\(showTime)").child(seat).setValue(["id": seat,
                                                                                                                                          "status": 1])
                            
                            databaseRef.child("users").child(userId!).child("booking").child("\(movieId)-\(date)-\(showTime)-\(seat)").removeValue()
                            self.bookingTableView.reloadData()
                            
                        }
                    }
                }
            }
        }
    }
}
