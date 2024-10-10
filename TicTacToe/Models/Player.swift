//
//  Player.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

// MARK: - Player Struct
struct Player: Equatable, Codable {
    let id: UUID
    var name: String
    var score: Int
    var symbol: PlayerSymbol
    var style: PlayerStyle

    // MARK: - Initializer
    init(name: String, score: Int, symbol: PlayerSymbol, style: PlayerStyle) {
        self.id = UUID()
        self.score = score
        self.name = name
        self.symbol = symbol
        self.style = style
    }
}

// MARK: - LeaderboardRound Struct
struct LeaderboardRound: Codable, Equatable {
    let id: UUID
    let player: Player
    let opponent: Player
    let date: Date
    let durationRound: Int

    // MARK: - Winner Calculation
    var winner: Player {
        return player.score > opponent.score ? player : opponent
    }
    
    // MARK: - Initializer
    init(player: Player, opponent: Player, durationRound: Int) {
        self.id = UUID()
        self.player = player
        self.opponent = opponent
        self.durationRound = durationRound
        self.date = Date()
    }
}

// MARK: - LeaderboardGame Struct
struct LeaderboardGame: Codable, Identifiable {
    let id: UUID
    let player: Player
    let opponent: Player
    let score: String
    let totalDuration: String
    let date: Date

    // MARK: - Initializer
    init(player: Player, opponent: Player, score: String, totalDuration: String) {
        self.id = UUID()
        self.player = player
        self.opponent = opponent
        self.score = score
        self.totalDuration = totalDuration
        self.date = Date()
    }
}
