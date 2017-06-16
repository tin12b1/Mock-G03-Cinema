//
//  Seat.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/8/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation

class Seat {
    
    var id: String?
    var status: Int?
    var bookedTime: String?
    
    init(json: [String:Any]) {
        id          = json["id"]            as? String
        status      = json["status"]        as? Int
        bookedTime  = json["booked_time"]   as? String
    }
}
