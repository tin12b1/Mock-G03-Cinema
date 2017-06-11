//
//  Booking.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/10/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation

class Booking {
    
    var id: Int?
    var title: String?
    var seats: String?
    var showTime: String?
    
    init(json: [String:Any]) {
        id          = json["id"]        as? Int
        title       = json["title"]     as? String
        seats       = json["seats"]     as? String
        showTime    = json["show_time"] as? String
    }
}
