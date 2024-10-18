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
    
    // Initializes the UserManager with a shared StorageManager
    private init(storageManager: StorageManager = .shared) {
        self.storageManager = storageManager
        
        // Initialize players with their default settings and scores
        self.player = Player(name: "", score: 0, symbol: .x, style: .crossPinkCirclePurple)
        self.opponent = Player(name: "", score: 0, symbol: .o, style: .crossPinkCirclePurple)
    }
    
    // Sets the game mode (single player or multiplayer)
    func setGameMode(_ mode: GameMode) {
        self.gameMode = mode
    }
    
    // Set player names; if player 2's name is not provided, set opponent's name to AI
    func setPlayers(player1Name: String, player2Name: String?) {
        self.player.name = player1Name
        self.opponent.name = player2Name ?? Resources.Text.ai
        if gameMode == .singlePlayer && player2Name == nil {
            opponent.isAI = true
        }
    }
    
    // Returns the current player, updating the player's symbol and style from settings
    func getPlayer() -> Player {
        let settings = storageManager.getSettings()
        player.symbol = settings.playerSymbol ?? .x
        player.style = settings.selectedStyle ?? .crossPinkCirclePurple
        return player
    }
    
    // Returns the opponent, updating the opponent's symbol and style based on the player
    func getOpponent() -> Player {
        let settings = storageManager.getSettings()
        
        opponent.symbol = player.symbol == .x ? .o : .x
        opponent.style = settings.selectedStyle ?? .crossPinkCirclePurple
        return opponent
    }
    
    // Updates the player's score
    func updatePlayerScore() {
        player.score += 1
    }
    
    // Updates the opponent's score
    func updateOpponentScore() {
        opponent.score += 1
    }
}
