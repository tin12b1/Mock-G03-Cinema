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
        let databaseRef = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
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
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booking cell", for: indexPath)
        let booking: Booking
        booking = bookings[indexPath.row]
        cell.textLabel?.text = booking.title
        cell.detailTextLabel?.text = booking.seats
        return cell
    }
    
    func getBookingList() {
        let databaseRef = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        databaseRef.child("users").child(userId!).child("booking").observe(.childAdded, with: {snapshot in
            let snapshotValue = snapshot.value as? NSDictionary
            self.bookings.append(Booking(json: snapshotValue as! [String : Any]))
            DispatchQueue.main.async {
                self.bookingTableView.reloadData()
            }
        })
    }
}
