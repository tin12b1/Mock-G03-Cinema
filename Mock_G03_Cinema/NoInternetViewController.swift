//
//  NoInternetViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 7/13/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func reloadButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
}
