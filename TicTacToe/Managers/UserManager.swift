//
//  UserManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import Foundation

final class UserManager {
   public static let shared = UserManager()
    
   var player1: User
   var player2: User
   var currentPlayer: User
    
    private init(player1: User = User(name: Resources.Text.you, type: .cross),
         player2: User = User(name: Resources.Text.secondPlayer, type: .circle)) {
        self.player1 = player1
        self.player2 = player2
        self.currentPlayer = player1
    }
    
    // Жребьевка для случайного выбора первого игрока
    func randomizeFirstPlayer() {
        currentPlayer = Bool.random() ? player1 : player2
    }
    
    // Смена текущего игрока
    func switchPlayer() {
        currentPlayer = (currentPlayer == player1) ? player2 : player1
    }
}
