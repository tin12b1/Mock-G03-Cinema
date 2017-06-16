//
//  Booking.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/10/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation

class Booking {
    
    var movieId: Int?
    var title: String?
    var seats: [String]?
    var showTime: String?
    var bookedTime: String?
    var paymentStatus: Int?
    var totalPrice: Int?
    
    init(json: [String:Any]) {
        movieId             = json["movie"]             as? Int
        title               = json["title"]             as? String
        seats               = json["seats"]             as? [String]
        showTime            = json["show_time"]         as? String
        bookedTime          = json["booked_time"]       as? String
        paymentStatus       = json["payment_status"]    as? Int
        totalPrice          = json["total_price"]       as? Int
    }
}
