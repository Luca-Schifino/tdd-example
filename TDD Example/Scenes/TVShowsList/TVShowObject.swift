//
//  TVShowObject.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 23/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import Foundation

struct TVShow: Decodable, Equatable {
    let id: String
    let title: String
}

struct TVShowRating: Codable, Equatable {
    let tvshowId: String
    let rating: Int
}
