//
//  Downloader.swift
//  Mock_G03_Cinema
//
//  Created by Cntt12 on 6/3/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation
import UIKit

class Downloader {
    
    class func downloadImageWithURL(_ url: String?) -> UIImage? {
        let data : Data
        do {
            data = try Data(contentsOf: URL(string: url!)!)
            return UIImage(data: (data))
        }
        catch {
            return nil
        }
    }
}
