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
    private(set) var gameMode: GameMode = .singlePlayer
    

    private init() {
        self.player1 = User(name: "", type: .cross, style: .crossPinkCirclePurple)
        self.player2 = User(name: "", type: .circle, style: .crossPinkCirclePurple)
        self.currentPlayer = player1
    }
    
    // Устанавливаем режим игры
    func setGameMode(_ mode: GameMode) {
        self.gameMode = mode
    }
    
    // Устанавливаем имена игроков
    func setPlayers(player1Name: String, player2Name: String) {
        self.player1.name = player1Name
        self.player2.name = player2Name
        self.currentPlayer = player1
    }
    
    // Set player styles based on settings
    func setPlayerStyles(style: PlayerStyle) {
        player1.style = style
        player2.style = style
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
