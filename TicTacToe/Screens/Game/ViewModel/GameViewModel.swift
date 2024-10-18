//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class GameViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var state: StateMashine
    @Published var gameBoard: [PlayerSymbol?] = []
    
    private let coordinator: Coordinator
    private let storageManager: StorageManager
    private let userManager: UserManager
    private let gameManager: GameManager
    private let musicManager: MusicManager
    private let timerManager: TimerManager
    
    var player: Player
    var opponent: Player
    
    let boardSize: BoardSize
    var gameMode: GameMode
    var level: DifficultyLevel
    
    var currentScore: String {
        "\(state.player.score) : \(state.opponent.score)"
    }
    
    var currentPlayer: Player {
        player.isActive ? player : opponent
    }
    
    var timerDisplay: String {
        let minutes = state.secondsCount / 60
        let seconds = state.secondsCount % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Initialization
    init(coordinator: Coordinator, userManager: UserManager = .shared, storageManager: StorageManager = .shared, gameManager: GameManager = .shared, musicManager: MusicManager = .shared, timerManager: TimerManager = .shared) {
        self.coordinator = coordinator
        self.userManager = userManager
        self.storageManager = storageManager
        self.gameManager = gameManager
        self.musicManager = musicManager
        self.timerManager = timerManager
        
        self.gameMode = userManager.gameMode
        self.level = storageManager.getSettings().level
        self.boardSize = gameManager.boardSize
        
        self.player = userManager.getPlayer()
        self.opponent = userManager.getOpponent()
        
        self.state = StateMashine(
            timerManager: timerManager,
            gameManager: gameManager,
            userManager: userManager,
            gameMode: gameMode,
            player: player,
            opponent: opponent,
            level: level
        )
    
        setupGameBindings()
        startGame()
        
    }
    
    private func setupGameBindings() {
        gameManager.onBoardChange = { [weak self] updatedBoard in
            self?.gameBoard = updatedBoard
            
            
        }
        
        timerManager.outOfTime = { [weak self] in self?.dispatch(.outOfTime) }
        timerManager.onTimeChange = { [weak self] in self?.state.secondsCount = $0 }
    }
    
    private func dispatch(_ event: StateMashine.GameEvent) {
        let newState = state.reduce(state: state.currentState, event: event)
        state.currentState = newState
        
        if state.isGameOver {
            updateScore()
            musicManager.stopMusic()
            state.winningPattern = gameManager.getWinningPattern()
            musicManager.playSoundFor(.final)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.musicManager.stopMusic()
                self.navigateToResultScreen()
            }
        }
    }
    
    private func updateScore() {
        if let winner = gameManager.winner {
            winner == player
            ? userManager.updatePlayerScore()
            : userManager.updateOpponentScore()
        }
    }
    
    private func startGame() {
        dispatch(.refresh)
        musicManager.playMusic()
    }
    
    func processPlayerMove(at position: Int) {
        dispatch(.move(position))
        processMoveResult()
    }
    
    private func processMoveResult() {
        if gameManager.isGameOver {
            let result = gameManager.getGameResult(
                player: state.player.isActive ? state.player : state.opponent,
                opponent: state.opponent
            )
            dispatch(.gameOver(result))
        }
    }

    private func navigateToResultScreen() {
        coordinator.updateNavigationState(action: .showResult(
            winner: gameManager.winner,
            playedAgainstAI: gameMode == .singlePlayer)
        )
    }
}
