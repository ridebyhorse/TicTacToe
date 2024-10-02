//
//  User.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

enum PlayerType {
    case circle
    case cross
}

struct User: Equatable {
    let name: String
    let type: PlayerType
    var score = 0

//    MARK: Init
    init(name: String, type: PlayerType) {
        self.name = name
        self.type = type
    }
}
