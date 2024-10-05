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
    
    @Published var player: Player
    @Published var opponent: Player
    @Published var currentPlayer: Player
    
    var gameMode: GameMode {
        userManager.gameMode
    }
    
    var level: DifficultyLevel {
        storageManager.getSettings().level
    }
    
    var playerStyle: PlayerStyle {
        player.style
    }

    
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
        self.player = userManager.getPlayer()
        self.opponent = userManager.getOpponent()
        self.currentPlayer = userManager.getOpponent()
        
        
        resetGame()
        musicManager.playMusic()
    }
    
    // Метод для случайного выбора первого хода
    private func getFirstMove() {
        currentPlayer = Bool.random() ? player : opponent
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
        getFirstMove()  // Случайный выбор первого игрока
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
