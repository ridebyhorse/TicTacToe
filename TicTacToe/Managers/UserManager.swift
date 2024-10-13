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
    private let isPlayerActive = Bool.random()
    
    private(set) var gameMode: GameMode = .singlePlayer
    
    // Initializes the UserManager with a shared StorageManager
    private init(storageManager: StorageManager = .shared) {
        self.storageManager = storageManager
        
        // Initialize players with their default settings and scores
        self.player = Player(name: "", score: 0, symbol: .tic, style: .crossPinkCirclePurple)
        self.opponent = Player(name: "", score: 0, symbol: .tacToe, style: .crossPinkCirclePurple)
    }
    
    // Sets the game mode (single player or multiplayer)
    func setGameMode(_ mode: GameMode) {
        self.gameMode = mode
    }
    
    // Set player names; if player 2's name is not provided, set opponent's name to AI
    func setPlayers(player1Name: String, player2Name: String?) {
        self.player.name = player1Name
        self.opponent.name = player2Name ?? Resources.Text.ai
    }
    
    // Returns the current player, updating the player's symbol and style from settings
    func getPlayer() -> Player {
        let settings = storageManager.getSettings()
        player.symbol = settings.playerSymbol ?? .tic
        player.style = settings.selectedStyle ?? .crossPinkCirclePurple
        player.isActive = isPlayerActive
        return player
    }
    
    // Returns the opponent, updating the opponent's symbol and style based on the player
    func getOpponent() -> Player {
        let settings = storageManager.getSettings()
        
        opponent.symbol = player.symbol == .tic ? .tacToe : .tic
        opponent.style = settings.selectedStyle ?? .crossPinkCirclePurple
        opponent.isActive = !isPlayerActive
        return opponent
    }
    
    // Updates the player's active
    func getActivePlayer() -> Player {
        return player.isActive ? player : opponent
    }
    
    // Switches the active player
    func switchPlayerActive() {
        player.isActive.toggle()
        opponent.isActive.toggle()
    }
    
    // Updates the player's score
    func updatePlayerScore(_ score: Int) {
        player.score = score
    }
    
    // Updates the opponent's score
    func updateOpponentScore(_ score: Int) {
        opponent.score = score
    }
}
