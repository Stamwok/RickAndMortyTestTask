//
//  Character.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 18.04.22.
//

import Foundation
import ObjectMapper

struct CharacterForList: Mappable {
    var id: Int?
    var name: String?
    var species: String?
    var gender: String?
    var image: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        species <- map["species"]
        gender <- map["gender"]
        image <- map["image"]
    }
}

struct CharacterForDetailScreen: Mappable {
    var id: Int?
    var name: String?
    var species: String?
    var gender: String?
    var image: String?
    var status: String?
    var location: Location?
    var episode: [String]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        species <- map["species"]
        gender <- map["gender"]
        image <- map["image"]
        status <- map["status"]
        location <- map["location"]
        episode <- map["episode"]
    }
}

struct Location: Mappable {
    var name: String?
    var url: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        url <- map["url"]
    }
}

