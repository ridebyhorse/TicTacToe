//
//  GameManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

final class GameManager {
    public static let shared = GameManager()
    
    private(set) var gameBoard: [PlayerSymbol?] = []
    private(set) var isGameOver: Bool = false
    var winner: Player?
    var onBoardChange: (([PlayerSymbol?]) -> Void)?
    
    // MARK: - Winning Patterns
    var winningCombinations: [[Int]] {
        return [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],  // Horizontal
            [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Vertical
            [0, 4, 8], [2, 4, 6]  // Diagonal
        ]
    }
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Game Reset
    func resetGame() {
        self.gameBoard = Array(repeating: nil, count: 9)
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
    
    // MARK: - AI Move
    @discardableResult
    func aiMove(for aiPlayer: Player, against humanPlayer: Player, difficulty: DifficultyLevel) -> Bool {

        guard !isGameOver else {
            print("Игра окончена. AI не может сделать ход.")
            return false
        }
        
        print("AI делает ход. Игрок AI: \(aiPlayer.name), Уровень сложности: \(difficulty)")
        
        aiDecision(for: aiPlayer, and: humanPlayer, level: difficulty) { [weak self] move in
            guard let self = self else {
                print("Ссылка на GameManager потеряна.")
                return
            }
            
            guard let move = move else {
                print("AI не смог найти ход.")
                return
            }
            
            print("AI выбрал позицию: \(move)")
            self.performAIMove(player: aiPlayer, at: move)
            print("AI сделал ход на позицию: \(move)")
        }
        
        return true
    }
    
    private func aiDecision(for player: Player, and opponent: Player, level: DifficultyLevel, completion: @escaping (Int?) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let move: Int?
            switch level {
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
    private func performAIMove(player: Player, at position: Int) {
        gameBoard[position] = player.symbol
        onBoardChange?(self.gameBoard) 
        evaluateGameState(for: player)
    }
    
    // MARK: - Validation and Evaluation
    private func isValidMove(at position: Int) -> Bool {
        return position >= 0 && position < 9 && gameBoard[position] == nil && !isGameOver
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
    
    // MARK: - Helpers for Winning/Available Moves
    private func findWinningMove(for symbol: PlayerSymbol) -> Int? {
        for pattern in winningCombinations {
            let values = pattern.map { gameBoard[$0] }
            if values.filter({ $0 == symbol }).count == 2, let emptyIndex = pattern.first(where: { gameBoard[$0] == nil }) {
                return emptyIndex
            }
        }
        return nil
    }
    
    private func findCenterMove() -> Int? {
        return gameBoard[4] == nil ? 4 : nil
    }
    
    private func findCornerMove() -> Int? {
        let corners = [0, 2, 6, 8]
        return corners.first(where: { gameBoard[$0] == nil })
    }
    
    private func findFirstAvailableMove() -> Int? {
        return gameBoard.firstIndex(where: { $0 == nil })
    }
    
    
    // MARK: - Game Result and Pattern
    func getGameResult(gameMode: GameMode, player: Player, opponent: Player) -> GameResult {
        if let winner = winner {
            if gameMode == .singlePlayer && winner == opponent {
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
            let (a, b, c) = (combination[0], combination[1], combination[2])
            if gameBoard[a] != nil, gameBoard[a] == gameBoard[b], gameBoard[b] == gameBoard[c] {
                return combination
            }
        }
        return nil
    }
}
