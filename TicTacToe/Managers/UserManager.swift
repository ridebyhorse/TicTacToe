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
        
        // Инициализируем игроков
        self.player = Player(name: "", symbol: .cross, style: .crossPinkCirclePurple)
        self.opponent = Player(name: "", symbol: .circle, style: .crossPinkCirclePurple)
        
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
        player.symbol = settings.playerSymbol            
        player.style = settings.selectedStyle
        return player
    }
    
    // Получаем оппонента с противоположным символом и тем же стилем
    func getOpponent() -> Player {
        let settings = storageManager.getSettings()
        opponent.symbol = player.symbol == .cross ? .circle : .cross
        opponent.style = settings.selectedStyle
        return opponent
    }
}
