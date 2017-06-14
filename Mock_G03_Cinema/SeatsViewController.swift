//
//  SeatsViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/8/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class SeatsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var seatsCollectionView: UICollectionView!
    @IBOutlet var confirmButton: UIButton!

    let databaseRef = Database.database().reference()
    let userId = Auth.auth().currentUser?.uid
    var movie: Movie?
    var seats = [Seat]()
    var count = 0
    var showTimeId: String?
    let currentDate = Date()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
        getSeats()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        seats.removeAll()
        getSeats()
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // * Under construction *
    @IBAction func confirmButtonClick(_ sender: Any) {
 /*       var bookedSeats = ""
        var showTime = ""
        for seat in seats {
            if (seat.status == 2) {
                if let movieId = movie?.id {
                    databaseRef.child("movies").child("\(movieId)").child("screening").child(showTimeId!).child(seat.id!).setValue(["id": seat.id!,
                                                                                                                             "col": seat.col!,
                                                                                                                             "row": seat.row!,
                                                                                                                             "status": 3,
                                                                                                                             "booked_time": currentDate])
                }
                if (bookedSeats == "") {
                    bookedSeats = bookedSeats + seat.id!
                }
                else {
                    bookedSeats = bookedSeats + ", " + seat.id!
                }
            }
        }
        if (showTimeId == "S1") {
            showTime = "11:00"
        }
        else if (showTimeId == "S2")  {
            showTime = "17:00"
        }
        else {
            showTime = "21:00"
        }
        if (bookedSeats != "") {
            if let movieId = movie?.id, let movieTitle = movie?.title {
                databaseRef.child("users").child(userId!).child("booking").childByAutoId().setValue(["movie": movieId,
                                                                                                     "title": movieTitle,
                                                                                                     "seats": bookedSeats,
                                                                                                    "show_time": showTime,
                                                                                                    "booked_time": currentDate])
            }
        }
        let srcUserInfo = self.storyboard?.instantiateViewController(withIdentifier: "userInfo") as! AccountViewController
        self.present(srcUserInfo, animated: true) */
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
        seatsCollectionView.reloadItems(at: [indexPath])
    }
    
    func getSeats() {
        let databaseRef = Database.database().reference()
        if let movieId = movie?.id {
            databaseRef.child("movies").child("\(movieId)").child("screening").child(showTimeId!).observe(.childAdded, with: {snapshot in
                let snapshotValue = snapshot.value as? NSDictionary
                self.seats.append(Seat(json: snapshotValue as! [String : Any]))
                DispatchQueue.main.async {
                    self.seatsCollectionView.reloadData()
                }
                self.checkPaymentDeadline()
            })
        }
    }
    
    // Reset seats status if user not pay in 24 hours until booked
    func checkPaymentDeadline() {
        for seat in seats {
            if seat.status == 3 {
                if let time = seat.bookedTime {
                    print(time)
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
}
