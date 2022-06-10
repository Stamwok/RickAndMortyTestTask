//
//  CharacterForList.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import Foundation

struct CharacterForList: Decodable {
    var id: Int
    var name: String
    var species: String
    var gender: String
    var image: String
}

struct CharacterInfo: Decodable {
    var id: Int
    var name: String
    var species: String
    var gender: String
    var image: String
    var status: String
    var location: Location
    var episode: [String]
}

struct Location: Decodable {
    var name: String
    var url: String
}

extension CharacterForList: Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: CharacterForList, rhs: CharacterForList) -> Bool {
        return lhs.id == rhs.id
    }
}
