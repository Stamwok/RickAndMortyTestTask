//
//  PageInfo.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 18.04.22.
//

import Foundation
import ObjectMapper

struct PageInfo: Mappable {
    var count: Int?
    var pages: Int?
    var next: String?
    var prev: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        count <- map["count"]
        pages <- map["pages"]
        next <- map["next"]
        prev <- map["prev"]
    }
}
