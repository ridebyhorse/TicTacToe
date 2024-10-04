//
//  User.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

struct User: Equatable {
    var name: String
    let type: PlayerSymbol
    var score = 0
    var style: PlayerStyle

    // MARK: Init
    init(name: String, type: PlayerSymbol, style: PlayerStyle) {
        self.name = name
        self.type = type
        self.style = style
    }
}
