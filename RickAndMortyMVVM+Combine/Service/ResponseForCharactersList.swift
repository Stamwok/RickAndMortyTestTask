//
//  ResponseForCharacterList.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import Foundation

struct ResponseForCharactersList: Decodable {
    var info: PageInfo
    var results: [CharacterForList]
}
struct PageInfo: Decodable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}
