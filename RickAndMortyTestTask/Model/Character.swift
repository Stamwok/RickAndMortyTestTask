//
//  Character.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 18.04.22.
//

import Foundation

struct CharacterForList: Codable {
    var id: Int
    var name: String
    var species: String
    var gender: String
    var image: String
}

struct CharacterForDetailScreen: Codable {
    var id: Int
    var name: String
    var species: String
    var gender: String
    var image: String
    var status: String
    var location: Location
    var episode: [String]
}

struct Location: Codable {
    var name: String
    var url: String
}

