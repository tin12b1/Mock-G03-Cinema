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
    var image: UIImage?
    
    init(id: Int?, title: String?, posterPath: String?, overview: String?, releaseDate: String?, voteAverage: Double?, genres: String?, image: UIImage?) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.genres = genres
        self.image = image
    }
}
