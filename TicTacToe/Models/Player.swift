//
//  Player.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

struct Player: Equatable {
    var name: String
    var symbol: PlayerSymbol
    var style: PlayerStyle
    var score = 0

    // MARK: Init
    init(name: String, symbol: PlayerSymbol, style: PlayerStyle) {
        self.name = name
        self.symbol = symbol
        self.style = style
    }
}

struct LeaderboardUser: Codable {
    let name: String
    let score: Int
}
