//
//  GameManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

final class GameManager {
    public static let shared = GameManager()
    
    private(set) var gameBoard: [PlayerSymbol?] = Array(repeating: nil, count: 9)
    private(set) var isGameOver: Bool = false
    var winner: Player?
    var currentPlayer: Player?
    var aiMoveHandler: (() -> Void)?
    
    // MARK: - Init
    private init() {}

    // Сброс игры с начальной настройкой игроков и символов
    func resetGame(firstPlayer: Player, secondPlayer: Player) {
        self.gameBoard = Array(repeating: nil, count: 9)
        self.winner = nil
        self.isGameOver = false
    }
    
    func setCurrentPlayer(_ currentPlayer: Player) {
        self.currentPlayer = currentPlayer
    }
    
    // MARK: - Player Move
    @discardableResult
    func makeMove(at position: Int, for player: Player, opponent: Player) -> Bool {
        guard isValidMove(at: position) else { return false }
        gameBoard[position] = player.symbol
        evaluateGameState(for: player, opponent: opponent)
        if !isGameOver {
            switchPlayer(with: player, opponent: opponent)
        }
        return true
    }

    @discardableResult
    func makeMoveForSinglePlayerMode(at position: Int, player1: Player, player2: Player, level: DifficultyLevel) -> Bool {
        guard makeMove(at: position, for: player1, opponent: player2) else { return false }
        if !isGameOver {
            aiMove(player1: player1, player2: player2, with: level)
        }
        aiMoveHandler?()
        return true
    }
    
    @discardableResult
    func makeFirstMoveForSinglePlayerMode(player1: Player, player2: Player, level: DifficultyLevel) -> Bool {
        aiMove(player1: player1, player2: player2, with: level)
        aiMoveHandler?()
        return true
    }
    
        // Получение результата игры
    func getGameResult(gameMode: GameMode, player: Player, opponent: Player) -> GameResult {
            if let winner {
                if gameMode == .singlePlayer && winner == opponent {
                    return .lose
                } else {
                    return .win(name: winner.name)
                }
            } else {
                return .draw
            }
        }
    
    // MARK: - AI Move
    func aiMove(player1: Player, player2: Player, with level: DifficultyLevel) {
        guard !isGameOver else { return }
        
        let move = aiDecision(for: player1, opponent: player2, level: level)
        if let move {
            performAIMove(player1: player1, player2: player2, at: move)
        }
    }

    private func aiDecision(for player1: Player, opponent: Player, level: DifficultyLevel) -> Int? {
        switch level {
        case .easy:
            return findFirstAvailableMove()
        case .normal:
            return findCenterMove() ?? findWinningMove(for: opponent.symbol) ?? findFirstAvailableMove()
        case .hard:
            return findWinningMove(for: opponent.symbol) ?? findWinningMove(for: player1.symbol) ?? findCenterMove() ?? findCornerMove() ?? findFirstAvailableMove()
        }
    }

    // MARK: - Game Logic Helpers
    private func isValidMove(at position: Int) -> Bool {
        return position >= 0 && position < 9 && gameBoard[position] == nil && !isGameOver
    }

    private func evaluateGameState(for player: Player, opponent: Player) {
        if checkWin(for: player.symbol) {
            winner = player
            isGameOver = true
        } else if checkWin(for: opponent.symbol) {
            winner = opponent
            isGameOver = true
        } else if isBoardFull() {
            isGameOver = true
        } else {
            switchPlayer(with: player, opponent: opponent)
        }
    }

    func switchPlayer(with player: Player, opponent: Player) {
        currentPlayer = (currentPlayer == player) ? opponent : player
    }
    

    
    private func performAIMove(player1: Player, player2: Player, at position: Int) {
        gameBoard[position] = player2.symbol
        evaluateGameState(for: player1, opponent: player2)
    }

    // MARK: - Winning Logic
    private func findWinningMove(for type: PlayerSymbol) -> Int? {
        for pattern in winningCombinations {
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
    private func checkWin(for type: PlayerSymbol) -> Bool {
        return winningCombinations.contains { pattern in
            pattern.allSatisfy { gameBoard[$0] == type }
        }
    }
    
    // MARK: - Win Patterns
    var winningCombinations: [[Int]] {
        return [
            [0, 1, 2], // Верхняя горизонтальная линия
            [3, 4, 5], // Средняя горизонтальная линия
            [6, 7, 8], // Нижняя горизонтальная линия
            [0, 3, 6], // Левая вертикальная линия
            [1, 4, 7], // Средняя вертикальная линия
            [2, 5, 8], // Правая вертикальная линия
            [0, 4, 8], // Диагональ сверху слева направо
            [2, 4, 6]  // Диагональ сверху справа налево
        ]
    }

    // MARK: - Функция для получения выигрышного паттерна
    func getWinningPattern() -> [Int]? {
        for combination in winningCombinations {
            let (a, b, c) = (combination[0], combination[1], combination[2])
            
            // Проверяем, что все три клетки в комбинации заняты одним и тем же символом
            if gameBoard[a] != nil, gameBoard[a] == gameBoard[b], gameBoard[b] == gameBoard[c] {
                return combination // Возвращаем индексы выигрышной комбинации
            }
        }
        return nil // Если нет выигрышной комбинации
    }
    

}
