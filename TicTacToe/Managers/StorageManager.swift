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
        static let savedLeaderboardRounds = "savedLeaderboardRounds"
        static let savedLeaderboardGames = "savedLeaderboardGames"
    }
    
    // MARK: - Initialization
    private init() {}
    
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
            return GameSettings.defaultGameSettings()
        }
    }
    
    // MARK: - Leaderboard for Rounds
    func saveLeaderboardRound(player: Player, opponent: Player, durationRound: Int) {
        var leaderboardRounds = getLeaderboardRounds()
        
        let leaderboardEntry = LeaderboardRound(
            player: player,
            opponent: opponent,
            durationRound: durationRound
        )
        
        leaderboardRounds.append(leaderboardEntry)
        
        leaderboardRounds.sort { $0.durationRound < $1.durationRound }
        if leaderboardRounds.count > 3 {
            leaderboardRounds = Array(leaderboardRounds.prefix(10))
        }
        
        if let encodedRounds = try? JSONEncoder().encode(leaderboardRounds) {
            userDefaults.set(encodedRounds, forKey: UserDefaultKeys.savedLeaderboardRounds)
        }
    }
    
    func getLeaderboardRounds() -> [LeaderboardRound] {
        if let savedData = userDefaults.data(forKey: UserDefaultKeys.savedLeaderboardRounds),
           let savedLeaderboardRounds = try? JSONDecoder().decode([LeaderboardRound].self, from: savedData) {
            return savedLeaderboardRounds
        } else {
            return []
        }
    }
    
    // MARK: - Leaderboard for Games
    func saveLeaderboardGame(player: Player, opponent: Player, score: String, totalDuration: String) {
        var leaderboardGames = getLeaderboardGames()
        
        let leaderboardEntry = LeaderboardGame(
            player: player,
            opponent: opponent,
            score: score,
            totalDuration: totalDuration
        )
        
        leaderboardGames.append(leaderboardEntry)
        
        // Сохранение лучших игр, можно использовать отсечку, например, 7 лучших
        leaderboardGames.sort { $0.score > $1.score }
        if leaderboardGames.count > 7 {
            leaderboardGames = Array(leaderboardGames.prefix(7))
        }
        
        if let encodedGames = try? JSONEncoder().encode(leaderboardGames) {
            userDefaults.set(encodedGames, forKey: UserDefaultKeys.savedLeaderboardGames)
        }
    }
    
    func getLeaderboardGames() -> [LeaderboardGame] {
        if let savedData = userDefaults.data(forKey: UserDefaultKeys.savedLeaderboardGames),
           let savedLeaderboardGames = try? JSONDecoder().decode([LeaderboardGame].self, from: savedData) {
            return savedLeaderboardGames
        } else {
            return []
        }
    }
}

