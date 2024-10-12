//
//  ResultModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import Foundation

enum GameResult: Equatable {
    case win(name: String)
    case lose
    case draw
}
