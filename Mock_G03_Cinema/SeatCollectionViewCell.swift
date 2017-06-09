//
//  SeatCollectionViewCell.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/9/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit

class SeatCollectionViewCell: UICollectionViewCell {
    func configureCell(status: Int) {
        switch status {
        case 0:
            backgroundColor = UIColor.red
        case 1:
            backgroundColor = UIColor.lightGray
        case 2:
            backgroundColor = UIColor.green
        default:
            backgroundColor = UIColor.clear
        }
    }
}
