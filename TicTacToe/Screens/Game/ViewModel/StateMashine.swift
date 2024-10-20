//
//  StateMashine.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 17.10.2024.
//

import Foundation

final class StateMachine {
    // MARK: - State and Event Enums
    enum State {
        case startGame
        case play
        case gameOver
    }
    
    enum GameEvent {
        case refresh
        case move(_ position: Int)
        case moveAI
        case toggleActivePlayer
        case outOfTime
    }
    
    // MARK: - Properties
    private let gameManager: GameManager
    private let gameMode: GameMode
    
    var currentState: State = .startGame
    
    var player: Player
    var opponent: Player
    
    var currentPlayer: Player
    
    var gameResult: GameResult? = nil
    var winningPattern: [Int]? = nil

    var boardBlocked = false
    
    // MARK: - Computed Properties
    var isGameOver: Bool {
        gameManager.isGameOver || gameResult != nil || currentState == .gameOver
    }
    
    // MARK: - Initializer
    init(_ player: Player,_ opponent: Player,_ gameMode: GameMode,_ gameManager: GameManager) {
        self.player = player
        self.opponent = opponent
        self.gameMode = gameMode
        self.gameManager = gameManager
        let isPlayerActive = Bool.random()
        self.currentPlayer = isPlayerActive ? player : opponent
    }
    
    // MARK: - Game Reset Methods
    func resetGame() {
        gameManager.resetGame()
        gameResult = nil
        winningPattern = nil
        boardBlocked = false
    }
    
    // MARK: - Reducer Logic
    func reduce(state: State, event: GameEvent) {
        currentState = state
        switch event {
        case  .refresh:
            self.resetGame()
            currentPlayer = randomizeCurrentActivePlayer()
            
        case .move(let position):
            guard !isGameOver else { return }
            if !currentPlayer.isAI {
                gameManager.makeMove(at: position, for: currentPlayer)
            }
            
        case .moveAI:
            guard !isGameOver else { return }
            guard gameMode == .singlePlayer else { return }
            if currentPlayer.isAI {
                gameManager.aiMove(for: currentPlayer)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.boardBlocked = false
                }
            }
            
        case .toggleActivePlayer:
            player.isActive.toggle()
            opponent.isActive = !player.isActive
            currentPlayer = player.isActive ? player : opponent
            return .play
            
        case .outOfTime:
            finishGame(with: .draw)
        }
        return currentState
    }
    
    // MARK: - Finish Game Logic
    private func finishGame(with result: GameResult) {
        winningPattern = gameManager.getWinningPattern()
        gameResult = result
        boardBlocked = true
    }
}
