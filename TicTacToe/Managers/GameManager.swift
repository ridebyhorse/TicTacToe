//
//  GameManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

final class GameManager {
    static let shared = GameManager()
    
    private(set) var gameBoard: [PlayerSymbol?] = []
    private(set) var isGameOver: Bool = false
    var winner: Player?
    var onBoardChange: (([PlayerSymbol?]) -> Void)?
    
    let boardSize: BoardSize
    private var gameEnvironmentsModel: GameEnvironmentsModel?
    
    // MARK: - Init
    private init() {
        // Забираем из настроек размер борда
        boardSize = StorageManager.shared.getSettings().boardSize
        
        switch boardSize {
        case .small:
            gameEnvironmentsModel = GameEnvironmentsModel.getSmallEnvironments()
        case .medium:
            gameEnvironmentsModel = GameEnvironmentsModel.getSmallEnvironments()
        case .large:
            gameEnvironmentsModel = GameEnvironmentsModel.getSmallEnvironments()
        case .extraLarge:
            gameEnvironmentsModel = GameEnvironmentsModel.getSmallEnvironments()
        }
    }
    
    // MARK: - Game Reset
    func resetGame() {
        guard let boardSize = gameEnvironmentsModel?.boardSize else { return }
        let totalCells = boardSize.dimension * boardSize.dimension
        self.gameBoard = Array(repeating: nil, count: totalCells)
        self.winner = nil
        self.isGameOver = false
        onBoardChange?(self.gameBoard)
    }
    
    
    // MARK: - Perform Move
    @discardableResult
    func makeMove(at position: Int, for player: Player) -> Bool {
        guard isValidMove(at: position) else { print("ошибка\(gameBoard)"); return false  }
        gameBoard[position] = player.symbol
        onBoardChange?(self.gameBoard)
        print("делаем ход.")
        evaluateGameState(for: player)
        return true
    }
    
    func aiMove(for aiPlayer: Player, against humanPlayer: Player, difficulty: DifficultyLevel) {
        guard let move = AIManager.shared.aiMove(for: aiPlayer, against: humanPlayer, difficulty: difficulty) else { return }
        performAIMove(player: aiPlayer, at: move)
    }
    
    // MARK: - Perform AI Move
    private func performAIMove(player: Player, at position: Int) {
        gameBoard[position] = player.symbol
        onBoardChange?(self.gameBoard)
        evaluateGameState(for: player)
    }
    
    // MARK: - Validation and Evaluation
    private func isValidMove(at position: Int) -> Bool {
        return position >= 0 && position < gameBoard.count && gameBoard[position] == nil && !isGameOver
    }
    
    private func evaluateGameState(for player: Player) {
        if checkWin(for: player.symbol) {
            winner = player
            isGameOver = true
        } else if isBoardFull() {
            isGameOver = true
        }
    }
    
    private func checkWin(for symbol: PlayerSymbol) -> Bool {
        guard let winningCombinations = gameEnvironmentsModel?.winningCombinations else { return false }
        return winningCombinations.contains { pattern in
            pattern.allSatisfy { gameBoard[$0] == symbol }
        }
    }
    
    private func isBoardFull() -> Bool {
        return gameBoard.allSatisfy { $0 != nil }
    }
    
    // MARK: - Game Result and Pattern
    func getGameResult(player: Player, opponent: Player) -> GameResult {
        if let winner = winner {
            if winner == opponent && opponent.isAI {
                return .lose
            } else {
                return .win(name: winner.name)
            }
        } else {
            return .draw
        }
    }
    
    func getWinningPattern() -> [Int]? {
        guard let winningCombinations = gameEnvironmentsModel?.winningCombinations else { return nil }
        for combination in winningCombinations {
            if combination.allSatisfy({ gameBoard[$0] != nil && gameBoard[$0] == gameBoard[combination[0]] }) {
                return combination
            }
        }
        return nil
    }
}
