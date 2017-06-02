//
//  Movie.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/2/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import Foundation

class Movie {
    
    var poster_path: String?
    var overview: String?
    var release_date: String?
    var genres: String?
    var id: Int?
    var title: String?
    var vote_average: Double?
    
    init(json: [String:Any]) {
        poster_path             = json["poster_path"]       as? String
        overview                = json["overview"]          as? String
        release_date            = json["release_date"]      as? String
        id                      = json["id"]                as? Int
        genres                  = json["genres"]            as? String
        title                   = json["title"]             as? String
        vote_average            = json["vote_average"]      as? Double
    }
}
