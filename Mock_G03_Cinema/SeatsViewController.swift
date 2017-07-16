//
//  SeatsViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/8/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import FirebaseAuth

class SeatsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var seatsCollectionView: UICollectionView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // Global variables
    var movie: Movie?
    var showTimeId: String?
    var screeningDate: String?
    var seats = [Seat]()
    var bookedSeats: [String] = []
    var count = 0
    var bookings = [Booking]()
    let currentDate = Date()
    let netPrice = 100000
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 9 seats per row
        let maxNumberOfItemsPerRow = 9
        let width = (seatsCollectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(maxNumberOfItemsPerRow - 1)) / CGFloat(maxNumberOfItemsPerRow)
        flowLayout.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Lock Orientation (portrait)
        Struct.lockOrientation(.portrait)
        self.seatsCollectionView.dataSource = self
        self.seatsCollectionView.delegate = self
        seats.removeAll()
        getSeats()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        seats.removeAll()
        getSeats()
        bookings.removeAll()
        checkUnpaidBooking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if no user login
        if (Auth.auth().currentUser == nil) {
            let alertView = UIAlertController(title: "Alert", message: "You must login first!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                self.present(loginVC, animated: true)
            })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Reset when view is being removed
        Struct.lockOrientation(.all)
        count = 0
        priceLabel.text = "0"
        bookedSeats.removeAll()
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonClick(_ sender: Any) {
        // Check internet connection
        if (!Reachability.isConnectedToNetwork()) {
            let srcNoInternet = self.storyboard?.instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
            self.present(srcNoInternet, animated: true)
        }
        else {
            let userId = Auth.auth().currentUser?.uid
            let bookingTime = Struct.getBookingTime()
            var reCount = 0
            // Re-count choosing seats
            for seat in seats {
                if (seat.status == 2) {
                    reCount += 1
                }
            }
            // Check if any seat booked by another user
            if (reCount != count) {
                count = reCount
                priceLabel.text = "\(netPrice*reCount)"
                let myAlert = UIAlertController(title: "Alert", message: "Seat was booked by another user, please choose another seat", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
            }
            else {
                // Set booking
                for seat in self.seats {
                    if (seat.status == 2) {
                        if let movieId = self.movie?.id {
                            DAOBooking.setSeatStatusBooking(movieId, self.screeningDate!, self.showTimeId!, seat.id!, bookingTime, completionHandler: { (error) in
                                if error != nil {
                                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alertController.addAction(defaultAction)
                                }
                            })
                        }
                        self.bookedSeats.append(seat.id!)
                    }
                }
                
                //Save booking to user info
                if (self.bookedSeats != []) {
                    let price = self.netPrice*self.count
                    if let movieId = self.movie?.id, let movieTitle = self.movie?.title, let showTime = self.showTimeId, let date = self.screeningDate {
                        DAOBooking.saveBookingToUser(movieId, movieTitle, date, showTime, self.bookedSeats, bookingTime, price, userId!, self.bookedSeats[0], completionHandler: { (error) in
                            if error != nil {
                                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                            }
                        })
                    }
                    self.performSegue(withIdentifier: "show checkout", sender: self)
                }
                else {
                    self.displayMyAlertMessage(userMessage: "You must choose at least 1 seat!")
                }
            }
        }
    }

    // MARK: - Seats collection view data source
    // Each theater only need 1 section to show all seats
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // Return number of seats
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seat cell", for: indexPath) as! SeatCollectionViewCell
        let seat: Seat
        seat = seats[indexPath.row]
        cell.configureCell(id: seat.id!, status: seat.status!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seat: Seat
        seat = seats[indexPath.row]
        if (count == 3 && seat.status == 1) {
            self.displayMyAlertMessage(userMessage: "Maximum number of seats reached!")
        }
        else if (seat.status == 1) {
            seat.status = 2
            count += 1
        }
        else if (seat.status == 2) {
            seat.status = 1
            count -= 1
        }
        else if (seat.status == 3) {
            self.displayMyAlertMessage(userMessage: "Seat was booked by the other!")
        }
        else if (seat.status == 0) {
            self.displayMyAlertMessage(userMessage: "Seat was reserved by the other!")
        }
        let price = netPrice*count
        priceLabel.text = "\(price)"
        seatsCollectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - Helper Methods
    
    func checkUnpaidBooking() {
        let userId = Auth.auth().currentUser?.uid
        var unpaidBooking = 0
        DAOBooking.getBookingList(userId: userId!, completionHandler: { (bookingList, error) in
            if (error == nil) {
                self.bookings = []
                self.bookings = bookingList!
                // Check if user got an unpaid booking
                if (self.bookings.count != 0) {
                    for booking in self.bookings {
                        if (booking.paymentStatus == 0) {
                            unpaidBooking += 1
                        }
                    }
                    if (unpaidBooking >= 1) {
                        let alertView = UIAlertController(title: "Alert", message: "You must checkout or delete your unpaid booking first!", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertView.addAction(action)
                        self.present(alertView, animated: true, completion: nil)
                    }
                }
            }
        })
    }
        
    // Get seats from database
    func getSeats() {
        if let movieId = movie?.id {
            DAOMovies.getSeatsList(movieId, screeningDate!, showTimeId!, completionHandler: { (seatsList, error) in
                if error == nil {
                    self.seats = []
                    self.seats = seatsList!
                    DispatchQueue.main.async {
                        self.seatsCollectionView.reloadData()
                    }
                    self.checkPaymentDeadline()
                } else {
                    let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    // Reset seats status if user not pay in 30 minutes until booked
    func checkPaymentDeadline() {
        let userId = Auth.auth().currentUser?.uid
        for seat in seats {
            if seat.status == 3 {
                let bookedTime = Struct.getDateTimeFromString(string: seat.bookedTime!, interval: 1800)
                if (currentDate > bookedTime) {
                    seat.status = 1
                    if let movieId = movie?.id {
                        DAOBooking.setSeatStatus(movieId, screeningDate!, showTimeId!, seat.id!, 1, completionHandler: { (error) in
                            if error != nil {
                                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                            }
                        })
                        if let seatId = seat.id, let showTime = showTimeId, let date = screeningDate {
                            DAOBooking.removeBooking(userId!, movieId, date, showTime, seatId)
                        }
                    }
                }
            }
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
            case "show checkout":
                let checkoutVC = segue.destination as! CheckoutViewController
                checkoutVC.movie = movie
                checkoutVC.showTime = showTimeId
                checkoutVC.bookedSeats = bookedSeats
                checkoutVC.screeningDate = screeningDate
                break
                
            default:
                break
            }
        }
    }
}
