//
//  BookingTableViewCell.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/16/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var seatsLabel: UILabel!
    @IBOutlet var showTimeLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var checkoutStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(title: String, seats: String, showTime: String, totalPrice: Int, checkoutStatus: Int) {
        movieTitleLabel.text = "Movie: " + title
        seatsLabel.text = "Seats: " + seats
        showTimeLabel.text = "Show Time: " + showTime
        totalPriceLabel.text = "Price: \(totalPrice)"
        if checkoutStatus == 1 {
            checkoutStatusLabel.text = "Checkout: Yes"
        }
        else {
            checkoutStatusLabel.text = "Checkout: No"
        }
    }
}
