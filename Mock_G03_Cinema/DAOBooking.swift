//
//  DAOBooking.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/29/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DAOBooking {
    
    static func getBookingList(userId: String, completionHandler: @escaping (_ bookingList: [Booking]?, _ error: String?) -> Void) {
        var bookingList: [Booking] = []
        let databaseRef = Database.database().reference()
        databaseRef.child("users").child(userId).child("booking").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                bookingList = []
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        if let postDict = snap.value as? [String: AnyObject] {
                            let bookingModel = Booking(json: postDict)
                            bookingList.append(bookingModel)
                        }
                    }
                }
                completionHandler(bookingList, nil)
            } else {
                let error = "Booking list empty!"
                completionHandler(nil, error)
            }
        })
    }
    
    static func setSeatStatus(_ movieId: Int,_ screeningDate: String,_ showTime: String,_ seat: String,_ status: Int, completionHandler: @escaping (_ error: Error?) -> Void) {
        let databaseRef = Database.database().reference()
        let data = [
            "id": seat,
            "status": status
            ] as [String : Any]
        
        databaseRef.child("movies").child("\(movieId)").child("screening").child(screeningDate).child(showTime).child(seat).setValue(data, withCompletionBlock: { (error, databaseRef) in
            completionHandler(error)
        })
    }
    
    static func setSeatStatusBooking(_ movieId: Int,_ screeningDate: String,_ showTime: String,_ seat: String,_ bookedTime: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        let databaseRef = Database.database().reference()
        let data = [
            "id": seat,
            "status": 3,
            "booked_time": bookedTime
            ] as [String : Any]
        
        databaseRef.child("movies").child("\(movieId)").child("screening").child(screeningDate).child(showTime).child(seat).setValue(data, withCompletionBlock: { (error, databaseRef) in
            completionHandler(error)
        })
    }
    
    static func removeBooking(_ userId: String,_ movieId: Int,_ screeningDate: String,_ showTime: String,_ seat: String) {
        let databaseRef = Database.database().reference()
        databaseRef.child("users").child(userId).child("booking").child("\(movieId)-\(screeningDate)-\(showTime)-\(seat)").removeValue()
    }
}
