//
//  User.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

struct User {
    let name: String
    let type: PlayerType

//    MARK: Init
    init(name: String = Recources.Text.you, type: PlayerType) {
        self.name = name
        self.type = type
    }
}
