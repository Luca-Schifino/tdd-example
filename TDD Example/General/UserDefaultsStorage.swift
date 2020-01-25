//
//  UserDefaultsStorage.swift
//  TDD Example
//
//  Created by Luca Schifino on 25/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import Foundation

enum UserDefaultsStorageError: Error {
    case noData
}

class UserDefaultsStorage {
    
    enum Key: String {
        case ratings
    }
    
    static func encodeObject<T: Encodable>(data: T, forKey key: Key) throws {
        do {
            UserDefaults.standard.set(try PropertyListEncoder().encode(data), forKey: key.rawValue)
        } catch {
            throw error
        }
    }
    
    static func decodeObject<T: Decodable>(forKey key: Key) throws -> T {
        guard let data = UserDefaults.standard.value(forKey: key.rawValue) as? Data else {
            throw UserDefaultsStorageError.noData
        }
        do {
            return try PropertyListDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    static func removeObject(forKey key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
