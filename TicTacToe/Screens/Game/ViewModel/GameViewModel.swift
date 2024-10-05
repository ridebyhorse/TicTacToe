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
    var timeManager: TimeManager
    
    @Published var gameBoard: [PlayerSymbol?] = Array(repeating: nil, count: 9)
    @Published private(set) var gameResult: GameResult? = nil
    
    @Published var player: Player
    @Published var opponent: Player
    @Published var currentPlayer: Player
    
    @Published var gameMode: GameMode = .singlePlayer
    
    var level: DifficultyLevel = .normal
    var playerStyle: PlayerStyle = .crossFilledPurpleCircleFilledPurple
    var player1Symbol: PlayerSymbol = .cross
    
    // MARK: - Initialization
    init(
        coordinator: Coordinator,
        userManager: UserManager = .shared,
        gameManager: GameManager = .shared,
        storageManager: StorageManager = .shared,
        musicManager: MusicManager = .shared,
        timeManager: TimeManager = .shared
    ) {
        self.coordinator = coordinator
        self.userManager = userManager
        self.gameManager = gameManager
        self.storageManager = storageManager
        self.musicManager = musicManager
        self.timeManager = timeManager
        
        // Инициализация игроков
        self.player = userManager.player
        self.opponent = userManager.opponent
        self.currentPlayer = userManager.currentPlayer
        self.gameMode = userManager.gameMode
        
        // Загрузка настроек и установка их в GameManager
        let savedSettings = storageManager.getSettings()
        self.level = savedSettings.level
        self.playerStyle = savedSettings.selectedStyle
        self.player1Symbol = savedSettings.playerSymbol
        
        let duration = TimeManager.convertDurationToTimeInterval(savedSettings.duration)
        self.timeManager = TimeManager(duration: duration)
        
        updatePlayerData()
        resetGame()
        musicManager.playMusic()
//        timeManager.startTimer()
    }
    
    // MARK: - Player Configuration
    func startGame() {
        timeManager.startTimer()
    }

    func endGame() {
        timeManager.stopTimer()
    }
    private func updatePlayerData() {
        // Установка символов и стилей для игроков
        player.symbol = player1Symbol
        opponent.symbol = player.symbol == .cross ? .circle : .cross
        currentPlayer.symbol = player1Symbol
        currentPlayer.style = playerStyle
        player.style = playerStyle
        opponent.style = playerStyle
    }
    
    
    // MARK: - Game Logic
    func processPlayerMove(for position: Int) {
        gameManager.setCurrentPlayer(currentPlayer)
        let opponentPlayer = currentPlayer == player ? opponent : player
        var moved = false
        switch gameMode {
        case .singlePlayer:
            moved = gameManager.makeMoveForSinglePlayerMode(
                at: position,
                player1: currentPlayer,
                player2: opponentPlayer,
                level: level
            )
        case .twoPlayers:
            moved = gameManager.makeMove(at: position, for: currentPlayer, opponent: opponentPlayer)
        }
        
        if moved {
            gameBoard = gameManager.gameBoard
            if gameManager.isGameOver {
                let result = gameManager.getGameResult(gameMode: gameMode, player: currentPlayer, opponent: opponentPlayer)
                handleGameResult(result)
            } else {
                togglePlayer()
            }
        }
    }
    
    // Метод для переключения между игроками
    private func togglePlayer() {
        gameManager.switchPlayer(with: player, opponent: opponent)
        currentPlayer = gameManager.currentPlayer ?? player
    }
    
    func resetGame() {
        gameManager.resetGame(firstPlayer: player, secondPlayer: opponent)
        // Update the game board after resetting the game state
        gameBoard = gameManager.gameBoard
    }
    

    private func handleGameResult(_ result: GameResult) {
        gameResult = result
        musicManager.stopMusic()
        timeManager.stopTimer()
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
                    winner: opponent,
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
