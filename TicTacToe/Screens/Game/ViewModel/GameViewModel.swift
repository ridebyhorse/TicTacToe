//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//
import Foundation

// MARK: - GameViewModel
final class GameViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var state: GameState
    @Published var gameBoard: [PlayerSymbol?] = []
    
    private let coordinator: Coordinator
    private let storageManager: StorageManager
    private let userManager: UserManager
    private let gameManager: GameManager
    private let musicManager: MusicManager
    private let timerManager: TimerManager

    // MARK: - Computed Properties
    var gameMode: GameMode
    var level: DifficultyLevel
    
    var currentPlayer: Player {
        return state.player.isActive ? state.player : state.opponent
    }
    
    var currentScore: String {
        "\(state.player.score) : \(state.opponent.score)"
    }
    
    var timerDisplay: String {
        let minutes = state.secondsCount / 60
        let seconds = state.secondsCount % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    // MARK: - Initialization
    init(
        coordinator: Coordinator,
        userManager: UserManager = .shared,
        storageManager: StorageManager = .shared,
        gameManager: GameManager = .shared,
        musicManager: MusicManager = .shared,
        timerManager: TimerManager = .shared
    ) {
        self.coordinator = coordinator
        self.userManager = userManager
        self.storageManager = storageManager
        self.gameManager = gameManager
        self.musicManager = musicManager
        self.timerManager = timerManager
        
        let player = userManager.getPlayer()
        let opponent = userManager.getOpponent()
        
        gameMode = userManager.gameMode
        level = storageManager.getSettings().level
        self.state = GameState(player: player, opponent: opponent)
        
        self.gameBoard = gameManager.gameBoard
        timerManager.outOfTime = { [weak self] in self?.dispatch(.endGame(result: .draw)) }
        timerManager.onTimeChange = { [weak self] in self?.state.secondsCount = $0 }
        
        dispatch(.refreshGame(currentPlayer: currentPlayer))
        musicManager.playMusic()
    }
    
    // MARK: - Actions Dispatch
    func dispatch(_ action: GameAction) {
        gameReducer(
            action: action,
            state: &state,
            userManager: userManager,
            gameManager: gameManager,
            musicManager: musicManager,
            timerManager: timerManager
        )
        
        self.gameBoard = gameManager.gameBoard
        
        if state.showResultScreen {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.navigateToResultScreen()
            }
        }
    }
    
    // MARK: - Game Logic
    func processPlayerMove(at position: Int) {
        dispatch(.makeMove(currentPlayer: currentPlayer, position: position, gameMode: gameMode, level: level))
    }
    
    private func processMoveResult() {
           if gameManager.isGameOver {
               let result = gameManager.getGameResult(
                   gameMode: gameMode,
                   player:
                       state.player.isActive ? state.player : state.opponent,
                   opponent: state.opponent
               )
               dispatch(.endGame(result: result))
           }
  
           self.gameBoard = gameManager.gameBoard
       }
   
    
    // MARK: - Navigation to Result Screen
    private func navigateToResultScreen() {
        coordinator.updateNavigationState(action: .showResult(
            winner: gameManager.winner,
            playedAgainstAI: gameMode == .singlePlayer)
        )
    }
}
