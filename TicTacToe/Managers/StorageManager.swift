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
    
    func saveUsersScore(_ users: [Player], winner: Player) {
        let winnerName = winner.name
        var decodedUsers = getLeaderboard()
        
        for user in users {
            //если бот - не сохраняем score
            guard user.name != Resources.Text.ai else { return }
            
            if let indexOfSavedUser = decodedUsers.firstIndex(where: { $0.name == user.name }) {
                decodedUsers[indexOfSavedUser].score += (winnerName == user.name) ? 1 : 0
            } else {
                let leaderboardUser = LeaderboardPlayer(name: user.name, score: (winnerName == user.name) ? 1 : 0)
                if leaderboardUser.score != 0 {
                    decodedUsers.append(leaderboardUser)
                }
            }
        }
        
        if let encodedUsers = try? JSONEncoder().encode(decodedUsers) {
            userDefaults.set(encodedUsers, forKey: UserDefaultKeys.savedLeaderboard)
        }
    }
    
    func getLeaderboard() -> [LeaderboardPlayer] {
        if let savedData = userDefaults.data(forKey: UserDefaultKeys.savedLeaderboard),
           let savedLeaderboard = try? JSONDecoder().decode([LeaderboardPlayer].self, from: savedData) {
            return savedLeaderboard
        } else {
            return []
        }
    }
}
