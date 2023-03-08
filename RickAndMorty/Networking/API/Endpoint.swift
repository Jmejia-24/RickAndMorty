//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/8/23.
//

import Foundation

@frozen enum Endpoint: String, CaseIterable, Hashable {
    case character
    case location
    case episode
}
