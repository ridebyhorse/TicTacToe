//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class GameViewModel: ObservableObject {
    // MARK: - Properties
    @Published var gameBoard: [PlayerSymbol?] = Array(repeating: nil, count: 9)
    @Published private(set) var gameResult: GameResult? = nil
    
    @Published var player: Player
    @Published var opponent: Player
    @Published var currentPlayer: Player
    @Published var secondsCount = 0
    
    private let coordinator: Coordinator
    private let userManager: UserManager
    private let gameManager: GameManager
    private let storageManager: StorageManager
    private let musicManager: MusicManager
    private let timerManager: TimerManager
    private var boardBlocked = false
    
    var gameMode: GameMode { userManager.gameMode }
    var level: DifficultyLevel { storageManager.getSettings().level }
    var playerStyle: PlayerStyle { player.style }

    
    // MARK: - Initialization
    init(
        coordinator: Coordinator,
        userManager: UserManager = .shared,
        gameManager: GameManager = .shared,
        storageManager: StorageManager = .shared,
        musicManager: MusicManager = .shared,
        timerManager: TimerManager = .shared
    ) {
        self.coordinator = coordinator
        self.userManager = userManager
        self.gameManager = gameManager
        self.storageManager = storageManager
        self.musicManager = musicManager
        self.timerManager = timerManager
        
        // Инициализация игроков
        self.player = userManager.getPlayer()
        self.opponent = userManager.getOpponent()
        self.currentPlayer = userManager.getOpponent()
        
        gameManager.aiMoveHandler = processMoveResult
        timerManager.outOfTime = handleOutOfTime
        timerManager.onTimeChange = { [weak self] in self?.secondsCount = $0 }
        resetGame()
        musicManager.playMusic()
//        timeManager.startTimer()
    }
    
    // Метод для случайного выбора первого хода
    private func getFirstMove() {
        currentPlayer = Bool.random() ? player : opponent
        if gameMode == .singlePlayer && currentPlayer == opponent  {
            gameManager.makeFirstMoveForSinglePlayerMode(player1: player, player2: opponent, level: level)
        }
    }

    // MARK: - Game Logic
    func processPlayerMove(for position: Int) {
        guard !boardBlocked else { return }
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
            if gameManager.isGameOver {
                let result = gameManager.getGameResult(
                    gameMode: gameMode,
                    player: currentPlayer,
                    opponent: opponentPlayer
                )
                boardBlocked = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                    self?.handleGameResult(result)
                }
            } else {
                togglePlayer()
            }
        }
        if gameMode == .twoPlayers {
            processMoveResult()
        }
    }
    
    func processMoveResult() {
        if gameMode == .twoPlayers {
            gameBoard = gameManager.gameBoard
        } else {
            boardBlocked = true
            let playerSymbol = opponent.name == Resources.Text.ai ? player.symbol : opponent.symbol
            for (index, symbol) in gameManager.gameBoard.enumerated() {
                if symbol == playerSymbol {
                    gameBoard[index] = symbol
                }
            }
            togglePlayer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard
                    let player = self?.player,
                    let gameManager = self?.gameManager
                else { return }
                self?.gameBoard = gameManager.gameBoard
                self?.currentPlayer = player
                self?.boardBlocked = false
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
        timerManager.startTimer()
        secondsCount = timerManager.secondsCount
        getFirstMove()  // Случайный выбор первого игрока
        gameBoard = Array(repeating: nil, count: 9)
    }

    private func handleGameResult(_ result: GameResult) {
        gameResult = result
        musicManager.stopMusic()
        timerManager.stopTimer()
        if let leaderboardWinner = gameManager.winner {
            storageManager.saveUsersScore([player, opponent], winner: leaderboardWinner)
        }
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
    
    private func handleOutOfTime() {
        timerManager.stopTimer()
        coordinator.updateNavigationState(
            action: .showResult(
                winner: nil,
                playedAgainstAI: gameMode == .singlePlayer
            )
        )
    }
}
