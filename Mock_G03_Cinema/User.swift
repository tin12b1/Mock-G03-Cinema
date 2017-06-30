//
//  User.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/29/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var age: Int?
    var address: String?
    
    init(json: [String:Any]) {
        name        = json["name"]          as? String
        age         = json["age"]           as? Int
        address     = json["address"]       as? String
    }
    
    init(name: String, age: Int, address: String) {
        self.name = name
        self.age = age
        self.address = address
    }
}
