//
//  Player.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

struct Player: Equatable, Codable {
    var name: String
    var score: Int
    var symbol: PlayerSymbol
    var style: PlayerStyle

    // MARK: Init
    init(name: String, score: Int, symbol: PlayerSymbol, style: PlayerStyle) {
        self.score = score
        self.name = name
        self.symbol = symbol
        self.style = style
    }
}

struct LeaderboardGameRound: Codable, Equatable {
    
    let player: Player
    let opponent: Player
    let date: Date
    let durationGame: String
    

    init(player: Player, opponent: Player, durationGame: String) {
        self.player = player
        self.opponent = opponent
        self.durationGame = durationGame
        self.date = Date() 
    }
}
