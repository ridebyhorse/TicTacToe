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
    
    func saveUsersScore(_ users: [User]) {
        var decodedUsers = getLeaderboard()
        for user in users {
            guard user.name != Resources.Text.secondPlayer else { return }
            
            let leaderboardUser = LeaderboardUser(name: user.name, score: user.score)
            if let indexOfSavedUser = decodedUsers.firstIndex(where: { $0.name == leaderboardUser.name }) {
                decodedUsers.remove(at: indexOfSavedUser)
                decodedUsers.insert(leaderboardUser, at: indexOfSavedUser)
            } else {
                decodedUsers.append(leaderboardUser)
            }
        }
        
        if let encodedUsers = try? JSONEncoder().encode(decodedUsers) {
            userDefaults.set(encodedUsers, forKey: UserDefaultKeys.savedLeaderboard)
        }
    }
    
    func getLeaderboard() -> [LeaderboardUser] {
        if let savedData = userDefaults.data(forKey: UserDefaultKeys.savedLeaderboard),
           let savedLeaderboard = try? JSONDecoder().decode([LeaderboardUser].self, from: savedData) {
            return savedLeaderboard
        } else {
            return []
        }
    }
}
