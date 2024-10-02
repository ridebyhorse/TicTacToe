//
//  StorageManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import Foundation

final class StorageManager {
    // MARK: - Properties
    public static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    
    enum UserDefaultKeys {
        static let savedSettings = "savedSettings"
        static let savedLeaderboard = "savedLeaderboard"
    }
    
    // MARK: - Initialization
    private init () {}
    
    // MARK: - Settings
    func saveSettings() {
        userDefaults.set(GameSettings.self, forKey: UserDefaultKeys.savedSettings)
    }
    
    func getSettings() -> GameSettings {
        if let savedGameSettings = userDefaults.object(forKey: UserDefaultKeys.savedSettings) as? GameSettings {
            return savedGameSettings
        } else {
            return GameSettings.defaultGameSettings()
        }
        
    }
    
    // MARK: - Leaderboard
}
