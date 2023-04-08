//
//  CharacterResponse.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/8/23.
//

import Foundation

struct CharacterResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [Character]
}
