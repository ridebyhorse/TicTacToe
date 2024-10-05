//
//  UserManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//
import Foundation

final class UserManager {
    public static let shared = UserManager()
    
    var player: Player
    var opponent: Player
    private(set) var currentPlayer: Player
    private(set) var gameMode: GameMode = .singlePlayer
    
    private init() {
        self.player = Player(name: "", symbol: .cross, style: .crossPinkCirclePurple)
        self.opponent = Player(name: "", symbol: .circle, style: .crossPinkCirclePurple)
        self.currentPlayer = player
    }
    
    // Устанавливаем режим игры
    func setGameMode(_ mode: GameMode) {
        self.gameMode = mode
    }
    
    // Устанавливаем имена игроков
    func setPlayers(player1Name: String, player2Name: String) {
        self.player.name = player1Name
        self.opponent.name = player2Name
        self.currentPlayer = player
    }
    
    // Жребьевка для случайного выбора первого игрока
//    func randomizeFirstPlayer() {
//        currentPlayer = Bool.random() ? player1 : player2
//    }
}
