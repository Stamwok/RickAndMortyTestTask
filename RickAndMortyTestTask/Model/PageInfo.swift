//
//  PageInfo.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 18.04.22.
//

import Foundation

struct PageInfo: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}
