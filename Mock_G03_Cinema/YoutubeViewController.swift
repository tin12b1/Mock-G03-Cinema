//
//  YoutubeViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 7/1/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit

class YoutubeViewController: UIViewController {

    @IBOutlet var trailerLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet var youtubeWebView: UIWebView!
    var videoCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVideo(videoCode: videoCode!)
        trailerLoadingIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getVideo(videoCode: String) {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        youtubeWebView.loadRequest(URLRequest(url: url!))
        if (!youtubeWebView.isLoading) {
            trailerLoadingIndicator.stopAnimating()
        }
    }
    @IBAction func backButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
