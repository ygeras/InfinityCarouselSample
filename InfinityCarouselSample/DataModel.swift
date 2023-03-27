//
//  DataModel.swift
//  InfinityCarouselSample
//
//  Created by Yuri Gerasimchuk on 27.03.2023.
//

struct Description: Codable {
    var name = ""
    var description = ""
    var rating = 0.0
    var reviews = 0
    var price = 0.0
    var colors = [String]()
    var imageURLs = [String]()
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case price
        case rating
        case reviews = "number_of_reviews"
        case colors
        case imageURLs = "image_urls"
    }
}
