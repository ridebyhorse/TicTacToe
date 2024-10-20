//
//  StateMashine.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 17.10.2024.
//


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
        case gameOver(_ result: GameResult)
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
    var updateCurrentPlayer: (() -> Void)?
    
    // MARK: - Computed Properties
    var isGameOver: Bool {
        return gameManager.isGameOver || gameResult != nil || currentState == .gameOver
    }
    
    // MARK: - Initializer
    init(_ player: Player,_ opponent: Player,_ gameMode: GameMode,_ gameManager: GameManager) {
        self.player = player
        self.opponent = opponent
        self.gameMode = gameMode
        self.gameManager = gameManager
        self.currentPlayer = player
    }
    
    // MARK: - Game Reset Methods
    func resetGame() {
        gameManager.resetGame()

        gameResult = nil
        winningPattern = nil
        boardBlocked = false
    }
    
    // MARK: - Reducer Logic
    func reduce(state: State, event: GameEvent) -> State {
        currentState = state
        
        switch event {
        case  .refresh:
            self.resetGame()
            currentPlayer = randomizeCurrentActivePlayer()
            
        case .move(let position):
            guard !isGameOver else { return .gameOver }
            if !currentPlayer.isAI {
                gameManager.makeMove(at: position, for: currentPlayer)
            }
            
        case .moveAI:
            guard !isGameOver else { return .gameOver }
            guard gameMode == .singlePlayer else { return .play }
            
            if currentPlayer.isAI {
                gameManager.aiMove(for: currentPlayer)
            }
            
        case .toggleActivePlayer:
            player.isActive.toggle()
            opponent.isActive = !player.isActive
            currentPlayer = player.isActive ? player : opponent
            return .play
            
        case .outOfTime:
            finishGame(with: .draw)
            return .gameOver
            
        case .gameOver(let result):
            finishGame(with: result)
            return .gameOver
        }
        return currentState
    }
    
    // MARK: - Finish Game Logic
    private func finishGame(with result: GameResult) {
        winningPattern = gameManager.getWinningPattern()
        gameResult = result
        boardBlocked = true
    }
    
    private func randomizeCurrentActivePlayer() -> Player {
        let isPlayerActive = Bool.random()
        return isPlayerActive ? player : opponent
    }
}
