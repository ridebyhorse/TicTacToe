//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//
import Foundation

final class GameViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var stateMachine: StateMachine
    @Published var gameBoard: [PlayerSymbol?] = []
    @Published var secondsCount = 0
    
    private let coordinator: Coordinator
    private var gameManager: GameManager
    private let userManager: UserManager
    private let timerManager: TimerManager
    private let musicManager: MusicManager
    private let storageManager: StorageManager
    
    var boardSize: BoardSize
    var gameMode: GameMode
    var level: DifficultyLevel
    
    var currentPlayer: Player {
        stateMachine.player.isActive ? stateMachine.player : stateMachine.opponent
    }
    
    var timerDisplay: String {
        let minutes = secondsCount / 60
        let seconds = secondsCount % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var currentScore: String {
        "\(stateMachine.player.score) : \(stateMachine.opponent.score)"
    }
    
    // MARK: - Initialization
    init(coordinator: Coordinator,
         userManager: UserManager = .shared,
         storageManager: StorageManager = .shared
    ) {
        self.coordinator = coordinator
        self.userManager = userManager
        self.storageManager = storageManager
        
        self.timerManager = TimerManager()
        self.musicManager = MusicManager()
        
        let player = userManager.getPlayer()
        let opponent = userManager.getOpponent()
        
        self.boardSize = storageManager.getSettings().boardSize
        self.gameMode = userManager.gameMode
        self.level = storageManager.getSettings().level
        
        self.gameManager = GameManager(boardSize, level)
       
        self.stateMachine = StateMachine(
            player,
            opponent,
            gameMode,
            gameManager
        )
        
        setupGameBindings()
        startGame()
    }
    
    // MARK: - Game Logic
    func processPlayerMove(at position: Int) {
        dispatch(.move(position))
    }
    
    func getWinningPattern() -> [Int]? {
        stateMachine.winningPattern
    }
    
    private func dispatch(_ event: StateMachine.GameEvent) {
        let newState = stateMachine.reduce(state: stateMachine.currentState, event: event)
        stateMachine.currentState = newState
        
        if stateMachine.isGameOver {
            stopGame()
        }
    }
    
    private func startGame() {
        musicManager.playMusic()
        timerManager.startTimer()
        
        dispatch(.refresh)
    }
    
    private func stopGame() {
        musicManager.stopMusic()
        timerManager.stopTimer()
        playFinalMusic()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigateToResultScreen()
        }
    }
    
    private func setupGameBindings() {
        gameManager.onBoardChange = { [weak self] updatedBoard in
            self?.gameBoard = updatedBoard
        }
        
        timerManager.onTimeChange = { [weak self] newTime in
            DispatchQueue.main.async {
                self?.secondsCount = newTime
            }
        }
        
        timerManager.outOfTime = { [weak self] in
            self?.dispatch(.outOfTime)
        }
    }
    
    private func playFinalMusic() {
        musicManager.playSoundFor(.final)
        musicManager.stopMusic()
    }
    
    private func navigateToResultScreen() {
        coordinator.updateNavigationState(action: .showResult(
            winner: gameManager.winner,
            playedAgainstAI: gameMode == .singlePlayer
        ))
    }
    
    private func updateScore() {
        if let winner = gameManager.winner {
            winner == stateMachine.player
            ? userManager.updatePlayerScore()
            : userManager.updateOpponentScore()
        }
    }
}
