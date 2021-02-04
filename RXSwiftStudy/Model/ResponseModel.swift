//
//  ResponseModel.swift
//  RXSwiftStudy
//
//  Created by BHJ on 2021/02/04.
//

import Foundation

struct ResponseModel: Codable {
    var resultCount : Int?
    var results : [Results]?
    
    enum CodingKeys: String,CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
}

struct Results : Codable,Equatable {
    var artistName : String
    var trackName : String
    var artworkUrl100 : String
    
    enum CodingKeys : String , CodingKey {
        case artistName = "artistName"
        case trackName = "trackName"
        case artworkUrl100 = "artworkUrl100"
    }
}
