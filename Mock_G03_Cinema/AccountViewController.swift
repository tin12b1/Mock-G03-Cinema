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
        DAOUser.getUserInfo(userId: userId!, completionHandler: { (userInfo, error) in
            if error == nil {
                self.nameLabel.text = userInfo?.name
                if let age = userInfo?.age {
                    self.ageLabel.text = "\(age)"
                }
                self.addressLabel.text = userInfo?.address
            } else {
                let srcAddUserInfo = self.storyboard?.instantiateViewController(withIdentifier: "addUserInfo") as! AddUserInfoViewController
                self.present(srcAddUserInfo, animated: true)
            }
        })
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
                        DAOBooking.setSeatStatus(movieId, date, showTime, seats[i], 1, completionHandler: { (error) in
                            if error != nil {
                                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                            }
                        })
                    }
                    DAOBooking.removeBooking(self.userId!, movieId, date, showTime, seats[0])
                }
                self.bookings.removeAll()
                self.getBookingList()
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
        DAOBooking.getBookingList(userId: userId!, completionHandler: { (bookingList, error) in
            if error == nil {
                self.bookings = []
                self.bookings = bookingList!
                self.bookings.reverse()
                DispatchQueue.main.async {
                    self.bookingTableView.reloadData()
                }
                self.checkPaymentDeadline()
            } else {
                if let err = error {
                    print(err)
                }
            }
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
                            DAOBooking.setSeatStatus(movieId, date, showTime, seat, 1, completionHandler: { (error) in
                                if error != nil {
                                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alertController.addAction(defaultAction)
                                }
                            })
                            DAOBooking.removeBooking(userId!, movieId, date, showTime, seat)
                            self.bookingTableView.reloadData()
                            
                        }
                    }
                }
            }
        }
    }
}
