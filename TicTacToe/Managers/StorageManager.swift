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
        static let savedPlayerScores = "savedPlayerScores"
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
    
    // MARK: - Сохранение и получение счетов игроков
    func savePlayersScore(player: Player) {
        var playerScores = getPlayersScores()
        
        // Сохраняем или обновляем счет игрока
        if let index = playerScores.firstIndex(where: { $0.name == player.name }) {
            playerScores[index].score = player.score
        } else {
            playerScores.append(player)
        }
        
        if let encodedScores = try? JSONEncoder().encode(playerScores) {
            userDefaults.set(encodedScores, forKey: UserDefaultKeys.savedPlayerScores)
        }
    }
    
    func getPlayersScores() -> [Player] {
        if let savedData = userDefaults.data(forKey: UserDefaultKeys.savedPlayerScores),
           let savedPlayerScores = try? JSONDecoder().decode([Player].self, from: savedData) {
            return savedPlayerScores
        } else {
            return []
        }
    }
    
    func getScoreFor(player: String) -> Int {
        let playerScores = getPlayersScores()
        return playerScores.first { $0.name == player }?.score ?? 0
    }
    
    func getScoreFor(opponent: String) -> Int {
        let playerScores = getPlayersScores()
        return playerScores.first { $0.name == opponent }?.score ?? 0
    }
}

