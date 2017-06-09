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

    var movie: Movie?
    var seats = [Seat]()
    var count = 0
    
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
    
    // * Under construction *
    @IBAction func confirmButtonClick(_ sender: Any) {
        let databaseRef = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        var bookedSeats = ""
        for seat in seats {
            if seat.status == 2 {
                if let movieId = movie?.id {
                    databaseRef.child("movies").child("\(movieId)").child("screening").child("S1").child(seat.id!).setValue(["id": seat.id!,
                                                                                                                             "col": seat.col!,
                                                                                                                            "row": seat.row!,
                                                                                                                            "status": 0])
                }
                if bookedSeats == "" {
                    bookedSeats = bookedSeats + seat.id!
                }
                else {
                    bookedSeats = bookedSeats + " " + seat.id!
                }
            }
        }
        if bookedSeats != "" {
            
        }
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
        cell.configureCell(status: seat.status!)
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
        } else if (seat.status == 0) {
            self.displayMyAlertMessage(userMessage: "Seat was reserved by the other!")
        }
        seatsCollectionView.reloadItems(at: [indexPath])
        print(seat.id!)
    }
    
    func getSeats() {
        let databaseRef = Database.database().reference()
        if let movieId = movie?.id {
            databaseRef.child("movies").child("\(movieId)").child("screening").child("S1").observe(.childAdded, with: {snapshot in
                let snapshotValue = snapshot.value as? NSDictionary
                self.seats.append(Seat(json: snapshotValue as! [String : Any]))
                DispatchQueue.main.async {
                    self.seatsCollectionView.reloadData()
                }
            })
        }
    }
    
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
