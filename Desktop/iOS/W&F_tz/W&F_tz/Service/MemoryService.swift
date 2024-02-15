//
//  MemoryService.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 14.02.2024.
//

import Foundation

class MemoryService {
    
    func addToFavorites(photoID: String) {
        var favorites = getFavorites()
        if !favorites.contains(where: { $0 == photoID }) {
            favorites.append(photoID)
            saveFavorites(favorites: favorites)
        }

    }
    
    func removeFromFavorites(photoID: String) {
        var favorites = getFavorites()
        favorites.removeAll { $0 == photoID }
        saveFavorites(favorites: favorites)
    }

    
    func saveFavorites(favorites: [String]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }
    
    func getFavorites() -> [String] {
        if let savedFavorites = UserDefaults.standard.object(forKey: "favorites") as? Data {
            let decoder = JSONDecoder()
            if let loadedFavorites = try? decoder.decode([String].self, from: savedFavorites) {
                return loadedFavorites
            }
        }
        return []
    }

}
