//
//  UserManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//
import Foundation

final class UserManager {
    public static let shared = UserManager()
    private let storageManager: StorageManager
    
    private var player: Player
    private var opponent: Player
    
    private(set) var gameMode: GameMode = .singlePlayer
    
    private init(storageManager: StorageManager = .shared) {
        self.storageManager = storageManager
        
        // Инициализируем игроков с их счётами
        self.player = Player(name: "", score: 0, symbol: .cross, style: .crossPinkCirclePurple)
        self.opponent = Player(name: "", score: 0, symbol: .circle, style: .crossPinkCirclePurple)
    }
    
    // Устанавливаем режим игры
    func setGameMode(_ mode: GameMode) {
        self.gameMode = mode
    }
    
    // Устанавливаем имена игроков
    func setPlayers(player1Name: String, player2Name: String?) {
        self.player.name = player1Name
        self.opponent.name = player2Name ?? Resources.Text.ai
    }
    
    func getPlayer() -> Player {
        let settings = storageManager.getSettings()
        
        player.symbol = settings.playerSymbol ?? .cross
        player.style = settings.selectedStyle ?? .crossPinkCirclePurple
        player.score = storageManager.getScoreFor(player: player.name)
        
        return player
    }
    

    func getOpponent() -> Player {
        let settings = storageManager.getSettings()
        
        opponent.symbol = player.symbol == .cross ? .circle : .cross
        opponent.style = settings.selectedStyle ?? .crossPinkCirclePurple
        opponent.score = storageManager.getScoreFor(opponent: opponent.name)
        
        return opponent
    }
}
