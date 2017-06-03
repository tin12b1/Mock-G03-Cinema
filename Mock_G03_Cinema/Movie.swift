//
//  Movie.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/2/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    
    var id: Int?
    var title: String?
    var posterPath: String?
    var overview: String?
    var releaseDate: String?
    var voteAverage: Double?
    var genres: String?
    
    init(json: [String:Any]) {
        posterPath              = json["poster_path"]       as? String
        title                   = json["title"]             as? String
        overview                = json["overview"]          as? String
        releaseDate             = json["release_date"]      as? String
        genres                  = json["genres"]            as? String
        id                      = json["id"]                as? Int
        voteAverage             = json["vote_average"]      as? Double
    }
}
