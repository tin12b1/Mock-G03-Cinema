//
//  DAOUser.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/29/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DAOUser {

    static func getUserInfo(userId: String, completionHandler: @escaping (_ userInfo: User?, _ error: String?) -> Void) {
        var userInfo: User?
        let databaseRef = Database.database().reference()
        databaseRef.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? [String: AnyObject] {
                    userInfo = User(json: value)
                }
                completionHandler(userInfo, nil)
            }
            else {
                let error = "User info unavailable"
                completionHandler(nil, error)
            }
        })
    }
    
    static func addNewUser(userId: String, userInfo: User, completionHandler: @escaping (_ error: Error?) -> Void) {
        let databaseRef = Database.database().reference()
        let data = [
            "name": userInfo.name!,
            "age": userInfo.age!,
            "address": userInfo.address!
            ] as [String : Any]
        
        databaseRef.child("users").child(userId).setValue(data, withCompletionBlock: { (error, databaseRef) in
            completionHandler(error)
        })
    }
}
