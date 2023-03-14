//
//  Character.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/8/23.
//

import Foundation

struct Character: Codable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
