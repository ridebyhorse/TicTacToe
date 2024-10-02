//
//  GameManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//


import Foundation

final class GameManager: ObservableObject {
    // MARK: - Properties
    @Published private(set) var currentPlayer: User
    @Published private(set) var gameBoard: [PlayerType?]
    @Published private(set) var winner: User?
    @Published private(set) var isGameOver: Bool = false
    
    private let player1: User
    private let player2: User
    private let isPlayingAgainstAI: Bool
    
    // MARK: - Init
    init(player1: User = User(name: Resources.Text.you, type: .cross),
         player2: User = User(name: Resources.Text.secondPlayer, type: .circle),
         isPlayingAgainstAI: Bool = false) {
        self.player1 = player1
        self.player2 = player2
        self.isPlayingAgainstAI = isPlayingAgainstAI
        self.currentPlayer = player1
        self.gameBoard = Array(repeating: nil, count: 9)
    }
    
    // MARK: - Game Actions
    @discardableResult
    func makeMove(at position: Int, with level: DifficultyLevel) -> Bool {
        guard isValidMove(at: position) else { return false }

        // Совершаем ход
        gameBoard[position] = currentPlayer.type
        evaluateGameState()

        // Если играем против AI и ход AI
        if isPlayingAgainstAI && !isGameOver && currentPlayer == player2 {
            aiMove(with: level)
        }
        return true
    }
    
    func resetGame() {
        gameBoard = Array(repeating: nil, count: 9)
        winner = nil
        isGameOver = false
        currentPlayer = player1
    }
    
    // MARK: - AI Move
    private func aiMove(with level: DifficultyLevel) {
        switch level {
        case .easy:
            aiEasyMove()
        case .standard:
            aiStandardMove()
        case .hard:
            aiHardMove()
        }
    }
    
    // MARK: - AI Strategies
    private func aiHardMove() {
        guard !isGameOver else { return }

        if let move = findWinningMove(for: player2.type) ?? findWinningMove(for: player1.type) ?? findCenterMove() ?? findCornerMove() ?? findFirstAvailableMove() {
            performAIMove(at: move)
        }
    }
    
    private func aiStandardMove() {
        guard !isGameOver else { return }

        if let move = findCenterMove() ?? findWinningMove(for: player2.type) ?? findFirstAvailableMove() {
            performAIMove(at: move)
        }
    }

    private func aiEasyMove() {
        guard !isGameOver else { return }

        if let move = findFirstAvailableMove() {
            performAIMove(at: move)
        }
    }

    // MARK: - Game Logic Helpers
    private func isValidMove(at position: Int) -> Bool {
        return position >= 0 && position < 9 && gameBoard[position] == nil && !isGameOver
    }

    private func evaluateGameState() {
        if checkWin(for: currentPlayer.type) {
            winner = currentPlayer
            isGameOver = true
        } else if isBoardFull() {
            isGameOver = true // Ничья
        } else {
            switchPlayer()
        }
    }
    
    private func switchPlayer() {
        currentPlayer = (currentPlayer == player1) ? player2 : player1
    }

    private func performAIMove(at position: Int) {
        gameBoard[position] = player2.type
        evaluateGameState()
    }

    // MARK: - Winning Logic
    private func findWinningMove(for type: PlayerType) -> Int? {
        for pattern in winningPatterns {
            let values = pattern.map { gameBoard[$0] }
            if values.filter({ $0 == type }).count == 2, let emptyIndex = pattern.first(where: { gameBoard[$0] == nil }) {
                return emptyIndex
            }
        }
        return nil
    }
    
    // MARK: - AI Move Helpers
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

    private func isBoardFull() -> Bool {
        return gameBoard.allSatisfy { $0 != nil }
    }
    
    // MARK: - Check for Win
    private func checkWin(for type: PlayerType) -> Bool {
        return winningPatterns.contains { pattern in
            pattern.allSatisfy { gameBoard[$0] == type }
        }
    }

    // MARK: - Win Patterns
    private var winningPatterns: [[Int]] {
        return [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Горизонтальные
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Вертикальные
            [0, 4, 8], [2, 4, 6]             // Диагональные
        ]
    }
}
