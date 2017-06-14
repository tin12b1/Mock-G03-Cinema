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
    var col: Int?
    var row: Int?
    var status: Int?
    var bookedTime: Date?
    
    init(json: [String:Any]) {
        id          = json["id"]            as? String
        col         = json["col"]           as? Int
        row         = json["row"]           as? Int
        status      = json["status"]        as? Int
        bookedTime  = json["booked_time"]   as? Date
    }
}
