//
//  GameManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

final class GameManager {
    
    private(set) var gameBoard: [PlayerSymbol?] = []
    private(set) var isGameOver: Bool = false
    var winner: Player? = nil
    var onBoardChange: (([PlayerSymbol?]) -> Void)?
    
    var boardSize: BoardSize
    var level: DifficultyLevel
    
    
    // MARK: - Winning Patterns
    private var winningCombinations: [[Int]] {
        let size = boardSize.dimension
        var combinations: [[Int]] = []
        
        // Horizontal
        for row in 0..<size {
            let start = row * size
            combinations.append(Array(start..<(start + size)))
        }
        
        // Vertical
        for col in 0..<size {
            var combination: [Int] = []
            for row in 0..<size {
                combination.append(row * size + col)
            }
            combinations.append(combination)
        }
        
        // Diagonal
        var diagonal1: [Int] = []
        var diagonal2: [Int] = []
        for i in 0..<size {
            diagonal1.append(i * size + i)
            diagonal2.append(i * size + (size - i - 1))
        }
        combinations.append(diagonal1)
        combinations.append(diagonal2)
        
        return combinations
    }
    
    // MARK: - Init
    init(_ boardSize: BoardSize,_ level: DifficultyLevel ) {
        self.boardSize = boardSize
        self.level = level
    }
    
    // MARK: - Game Reset
    func resetGame() {
        let totalCells = boardSize.dimension * boardSize.dimension
        self.gameBoard = Array(repeating: nil, count: totalCells)
        self.winner = nil
        self.isGameOver = false
        onBoardChange?(self.gameBoard)
    }
    
    
    // MARK: - Perform Move
    func makeMove(at position: Int, for player: Player) {
        guard isValidMove(at: position) else { return }
        gameBoard[position] = player.symbol
        onBoardChange?(self.gameBoard)
      
        evaluateGameState(for: player)
    }
    
    // MARK: - AI Move
    func aiMove(for aiPlayer: Player, against humanPlayer: Player) {
        guard !isGameOver else { return }
        
        aiDecision(for: aiPlayer, and: humanPlayer) { [weak self] move in
            guard let self = self else {
                return
            }
            guard let move = move else {
                return
            }
            self.performAIMove(aiPlayer: aiPlayer, at: move)
            print("AI сделал ход на позицию: \(move)")
        }
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
        for combination in winningCombinations {
            if combination.allSatisfy({ gameBoard[$0] != nil && gameBoard[$0] == gameBoard[combination[0]] }) {
                return combination
            }
        }
        return nil
    }
    
    // MARK: - Private Methods
    private func aiDecision(for player: Player, and opponent: Player, completion: @escaping (Int?) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let move: Int?
            switch self.level {
            case .easy:
                move = self.findFirstAvailableMove()
            case .normal:
                move = self.findCenterMove() ?? self.findWinningMove(for: opponent.symbol) ?? self.findFirstAvailableMove()
            case .hard:
                move = self.findWinningMove(for: opponent.symbol) ?? self.findWinningMove(for: player.symbol) ?? self.findCenterMove() ?? self.findCornerMove() ?? self.findFirstAvailableMove()
            }
            completion(move)
        }
    }
    
    // MARK: - Perform AI Move
    private func performAIMove(aiPlayer: Player, at position: Int) {
        gameBoard[position] = aiPlayer.symbol
        onBoardChange?(self.gameBoard)
        evaluateGameState(for: aiPlayer)
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
        return winningCombinations.contains { pattern in
            pattern.allSatisfy { gameBoard[$0] == symbol }
        }
    }
    
    private func isBoardFull() -> Bool {
        return gameBoard.allSatisfy { $0 != nil }
    }
    
    // MARK: - Winning/Available Moves Helpers
    private func findWinningMove(for symbol: PlayerSymbol) -> Int? {
        for pattern in winningCombinations {
            let values = pattern.map { gameBoard[$0] }
            if values.filter({ $0 == symbol }).count == boardSize.dimension - 1,
               let emptyIndex = pattern.first(where: { gameBoard[$0] == nil }) {
                return emptyIndex
            }
        }
        return nil
    }
    
    private func findCenterMove() -> Int? {
        let centerIndex = (gameBoard.count - 1) / 2
        return gameBoard[centerIndex] == nil ? centerIndex : nil
    }
    
    private func findCornerMove() -> Int? {
        let size = boardSize.dimension
        let corners = [0, size - 1, gameBoard.count - size, gameBoard.count - 1]
        return corners.first(where: { gameBoard[$0] == nil })
    }
    
    private func findFirstAvailableMove() -> Int? {
        return gameBoard.firstIndex(where: { $0 == nil })
    }
}
