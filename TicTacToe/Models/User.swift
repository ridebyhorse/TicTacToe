//
//  User.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

struct User: Equatable {
    let name: String
    let type: PlayerType

//    MARK: Init
    init(name: String = Resources.Text.you, type: PlayerType = .cross) {
        self.name = name
        self.type = type
    }
    
}
