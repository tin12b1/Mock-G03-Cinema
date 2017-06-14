//
//  SeatCollectionViewCell.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/9/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit

class SeatCollectionViewCell: UICollectionViewCell {
    @IBOutlet var seatNameLabel: UILabel!
    func configureCell(id: String, status: Int) {
        seatNameLabel.text = id
        switch status {
        case 0:
            backgroundColor = UIColor.red
        case 1:
            backgroundColor = UIColor.lightGray
        case 2:
            backgroundColor = UIColor.green
        case 3:
            backgroundColor = UIColor.yellow
        default:
            backgroundColor = UIColor.clear
        }
    }
}
