//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class GameViewModel: ObservableObject {
    // MARK: - Properties
    private let coordinator: Coordinator
    private let userManager: UserManager
    private let gameManager: GameManager
    private let storageManager: StorageManager
    private let musicManager: MusicManager
    
    @Published var gameBoard: [PlayerSymbol?] = Array(repeating: nil, count: 9)
    @Published private(set) var gameResult: GameResult? = nil
    
    @Published var player1: Player
    @Published var player2: Player
    @Published var currentPlayer: Player
    
    @Published var gameMode: GameMode = .singlePlayer
    
    var level: DifficultyLevel = .standard
    var playerStyle: PlayerStyle = .crossFilledPurpleCircleFilledPurple
    var player1Symbol: PlayerSymbol = .cross
    
    // MARK: - Initialization
    init(
        coordinator: Coordinator,
        userManager: UserManager = .shared,
        gameManager: GameManager = .shared,
        storageManager: StorageManager = .shared,
        musicManager: MusicManager = .shared
    ) {
        self.coordinator = coordinator
        self.userManager = userManager
        self.gameManager = gameManager
        self.storageManager = storageManager
        self.musicManager = musicManager
        
        // Инициализация игроков
        self.player1 = userManager.player1
        self.player2 = userManager.player2
        self.currentPlayer = userManager.currentPlayer
        
        // Загрузка настроек и установка их в GameManager
        let savedSettings = storageManager.getSettings()
        self.level = savedSettings.level
        self.playerStyle = savedSettings.selectedStyle
        self.player1Symbol = savedSettings.playerSymbol
        
        updatePlayerData()
        resetGame()
        musicManager.playMusic()
    }
    
    // MARK: - Player Configuration
    private func updatePlayerData() {
        // Установка символов и стилей для игроков
        player1.symbol = player1Symbol
        player2.symbol = player1.symbol == .cross ? .circle : .cross
        
        player1.style = playerStyle
        player2.style = playerStyle
    }
    
    
    // MARK: - Game Logic
    func processPlayerMove(for position: Int) {
        let opponentPlayer = currentPlayer == player1 ? player2 : player1
        switch gameMode {
            
        case .singlePlayer:
            
            gameManager.makeMoveForSinglePlayerMode(
                at: position,
                player1: currentPlayer,
                player2: opponentPlayer,
                level: level
            )
            resetGame()
            togglePlayer()
        case .twoPlayers:
            gameManager.makeMove(at: position, for: currentPlayer, opponent: opponentPlayer)
            resetGame()
            togglePlayer()
        }
        
    }
    
    // Метод для переключения между игроками
    private func togglePlayer() {
        currentPlayer = currentPlayer == player1 ? player2 : player1
    }
    
    func resetGame() {
        // Обновление доски
        gameBoard = gameManager.gameBoard
    }
    

    private func handleGameResult(_ result: GameResult) {
        gameResult = result
        musicManager.stopMusic()
        switch result {
        case .win:
            coordinator.updateNavigationState(
                action: .showResult(
                    winner: gameManager.winner,
                    playedAgainstAI: gameMode == .singlePlayer
                )
            )
        case .lose:
            coordinator.updateNavigationState(
                action: .showResult(
                    winner: player2,
                    playedAgainstAI: gameMode == .singlePlayer
                )
            )
        case .draw:
            coordinator.updateNavigationState(
                action: .showResult(
                    winner: nil,
                    playedAgainstAI: gameMode == .singlePlayer
                )
            )
        }
    }
}
