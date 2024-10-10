//
//  GameReducer.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//


struct GameReducer {
    typealias Reducer = (GameState, GameAction) -> GameState
    
    // MARK: - Game State
    struct GameState {
        var gameBoard: [PlayerSymbol?]
        var gameResult: GameResult?
        var winningPattern: [Int]?
        var player: Player
        var opponent: Player
        var currentPlayer: Player
        var secondsCount: Int
        var isBoardBlocked: Bool
        var state: GameStateEnum
        
        enum GameStateEnum {
            case idle
            case playing
            case finished
        }
    }

    // MARK: - Game Actions
    enum GameAction {
        case resetGame
        case playerMove(Int)
        case aiMove
        case endGame(GameResult)
        case togglePlayer
        case updateTime(Int)
        case handleOutOfTime
    }
    
    // MARK: - Game Reducer Function
    static func gameReducer(state: inout GameState, action: GameAction, gameManager: GameManager) {
        switch action {
        case .resetGame:
            gameManager.resetGame(firstPlayer: state.player, secondPlayer: state.opponent)
            state.gameBoard = gameManager.gameBoard
            state.gameResult = nil
            state.winningPattern = nil
            state.isBoardBlocked = false
            state.state = .playing
            
        case .playerMove(let position):
            guard !state.isBoardBlocked else { return }
            
            // Выполняем ход игрока через GameManager
            let moveSuccess = gameManager.makeMove(at: position, for: state.currentPlayer, opponent: state.opponent)
            if moveSuccess {
                state.gameBoard = gameManager.gameBoard
                state.winningPattern = gameManager.getWinningPattern()
                state.isBoardBlocked = gameManager.isGameOver
                if gameManager.isGameOver {
                    state.gameResult = gameManager.getGameResult(gameMode: .twoPlayer, player: state.currentPlayer, opponent: state.opponent)
                    state.state = .finished
                } else {
                    gameManager.switchPlayer(with: state.currentPlayer, opponent: state.opponent)
                    state.currentPlayer = gameManager.currentPlayer ?? state.currentPlayer
                }
            }

        case .aiMove:
            guard !state.isBoardBlocked else { return }
            
            // Логика AI хода через GameManager
            gameManager.aiMove(player1: state.player, player2: state.opponent, with: .normal)
            state.gameBoard = gameManager.gameBoard
            state.winningPattern = gameManager.getWinningPattern()
            state.isBoardBlocked = gameManager.isGameOver
            if gameManager.isGameOver {
                state.gameResult = gameManager.getGameResult(gameMode: .singlePlayer, player: state.player, opponent: state.opponent)
                state.state = .finished
            }

        case .endGame(let result):
            state.gameResult = result
            state.state = .finished
            state.isBoardBlocked = true
            
        case .togglePlayer:
            gameManager.switchPlayer(with: state.currentPlayer, opponent: state.opponent)
            state.currentPlayer = gameManager.currentPlayer ?? state.currentPlayer
            
        case .updateTime(let seconds):
            state.secondsCount = seconds
            
        case .handleOutOfTime:
            state.state = .finished
            state.gameResult = .lose
            state.isBoardBlocked = true
        }
    }
}
