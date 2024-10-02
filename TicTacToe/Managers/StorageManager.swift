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
    // MARK: - Settings
       func saveSettings(_ settings: GameSettings) {
           if let encodedSettings = try? JSONEncoder().encode(settings) {
               userDefaults.set(encodedSettings, forKey: UserDefaultKeys.savedSettings)
           }
       }
       
       func getSettings() -> GameSettings {
           if let savedData = userDefaults.data(forKey: UserDefaultKeys.savedSettings),
              let savedSettings = try? JSONDecoder().decode(GameSettings.self, from: savedData) {
               return savedSettings
           } else {
               return GameSettings.defaultGameSettings() // Возвращаем настройки по умолчанию
           }
       }
    
    // MARK: - Leaderboard
}
