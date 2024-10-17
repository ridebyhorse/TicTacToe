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
    
    var gameMode: GameMode
    var level: DifficultyLevel
    
    var currentScore: String {
        "\(state.player.score) : \(state.opponent.score)"
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

        let player = userManager.getPlayer()
        let opponent = userManager.getOpponent()
        
        self.state = StateMashine(
            timerManager: timerManager,
            gameManager: gameManager,
            userManager: userManager,
            musicManager: musicManager,
            gameMode: gameMode,
            player: player,
            opponent: opponent,
            level: level
        )
    
        setupGameBindings()
        startGame()
        musicManager.playMusic()
    }
    
    private func setupGameBindings() {
        gameManager.onBoardChange = { [weak self] updatedBoard in
            self?.gameBoard = updatedBoard
        }
        
        timerManager.outOfTime = { [weak self] in self?.dispatch(.outOfTime) }
        timerManager.onTimeChange = { [weak self] in self?.state.secondsCount = $0 }
    }
    
    func startGame() {
        dispatch(.refresh)
    }
    
    func processPlayerMove(at position: Int) {
        dispatch(.move(position))
        processMoveResult()
    }
    
    func dispatch(_ event: StateMashine.GameEvent) {
        let newState = state.reduce(state: state.currentState, event: event)
        state.currentState = newState
        
        if state.isGameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.navigateToResultScreen()
            }
        }
    }

    private func processMoveResult() {
        if gameManager.isGameOver {
            let result = gameManager.getGameResult(
                gameMode: gameMode,
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
