//
//  PreferencesRepository.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/14.
//

import Foundation

class PreferencesRepository {
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    
    private var preferences: UserPreferences?
    
    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        preferences = nil
    }
    
    func getPreferences() -> UserPreferences {
        if let preferences {
            return preferences
        }
        if let data = UserDefaults.standard.data(forKey: "userPreferences") {
            preferences = try? decoder.decode(UserPreferences.self, from: data)
        }
        if let preferences {
            return preferences
        }
        preferences = .init()
        return preferences!
    }
    
    func setPreferences(_ preferences: UserPreferences) {
        self.preferences = preferences
        if let data = try? encoder.encode(preferences) {
            UserDefaults.standard.set(data, forKey: "userPreferences")
        }
    }
}
