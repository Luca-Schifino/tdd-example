//
//  TVShowsListService.swift
//  TDD Example
//
//  Created by Luca Saldanha Schifino on 23/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case fileNotFound
}

protocol TVShowsListServiceProtocol: AnyObject {
    
    func loadTVShows(completion: @escaping (Result<[TVShow], Error>) -> Void)
}

class TVShowsListService {
}

extension TVShowsListService: TVShowsListServiceProtocol {
    
    func loadTVShows(completion: @escaping (Result<[TVShow], Error>) -> Void) {
        guard let fileURL = Bundle.main.url(forResource: "tvshows", withExtension: "json") else {
            completion(.failure(ServiceError.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let tvshows = try decoder.decode([TVShow].self, from: data)
            completion(.success(tvshows))
        } catch {
            completion(.failure(error))
        }
    }
}
