//
//  Player.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

struct Player: Equatable {
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

struct LeaderboardPlayer: Codable {
    let name: String
    var score: Int
}
