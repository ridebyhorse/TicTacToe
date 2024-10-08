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
    
    // MARK: - Leaderboard
    func saveUsersScore(player: Player, opponent: Player, score: String, duration: String) {
        var leaderboard = getLeaderboard()

        let leaderboardEntry = LeaderboardGameRound(
            player: player,
            opponent: opponent,
            durationGame: duration
            )

        leaderboard.append(leaderboardEntry)

        if let encodedLeaderboard = try? JSONEncoder().encode(leaderboard) {
            userDefaults.set(encodedLeaderboard, forKey: UserDefaultKeys.savedLeaderboard)
        }
    }
    
    func getLeaderboard() -> [LeaderboardGameRound] {
        if let savedData = userDefaults.data(forKey: UserDefaultKeys.savedLeaderboard),
           let savedLeaderboard = try? JSONDecoder().decode([LeaderboardGameRound].self, from: savedData) {
            return savedLeaderboard
        } else {
            return []
        }
    }
    
//    func getScoreFor(playerName: String) -> Int {
//        let leaderboard = getLeaderboard()
//        return leaderboard.first { $0.name == playerName }?.score  0
//    }
//    
//    // MARK: - New Methods
//    
//    // 1. Проверка существования игрока
//    func playerExists(with name: String) -> Bool {
//        let leaderboard = getLeaderboard()
//        return leaderboard.contains(where: { $0.name == name })
//    }
//    
//    // 2. Сохранение всех счётов игроков
//    func saveAllScores(_ scores: [LeaderboardGameRound]) {
//        if let encodedScores = try? JSONEncoder().encode(scores) {
//            userDefaults.set(encodedScores, forKey: UserDefaultKeys.savedLeaderboard)
//        }
//    }
//    
//    // 3. Получение всех счётов игроков
//    func getAllScores() -> [String: Int] {
//        let leaderboard = getLeaderboard()
//        var scoresDict = [String: Int]()
//        
//        for player in leaderboard {
//            scoresDict[player.name] = player.score
//        }
//        
//        return scoresDict
//    }
}
