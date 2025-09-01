//
//  UserDefaultsManager.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import Foundation

class UserDefaultsManager {

    let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// Save a Codable object to UserDefaults
    func saveObject<T: Codable>(_ object: T, forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(object)
            defaults.set(data, forKey: key)
        } catch {
            print("UserDefaultsManager ==> saveObject ==> Failed to encode object: \(error)")
        }
    }

    /// Fetch a Codable object from UserDefaults
    func fetchObject<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key) else {
            print("UserDefaultsManager ==> fetchObject ==> No data found for key: \(key)")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            print("UserDefaultsManager ==> fetchObject ==> Failed to decode object: \(error)")
            return nil
        }
    }

    /// Remove an object for a key
    func removeObject(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
