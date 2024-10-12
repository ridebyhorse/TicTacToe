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
    var aiMoveHandler: (() -> Void)?
    
    // MARK: - Init
    private init() {}

    // Сброс игры с начальной настройкой игроков и символов
    func resetGame(firstPlayer: Player, secondPlayer: Player) {
        self.gameBoard = Array(repeating: nil, count: 9)
        self.winner = nil
        self.isGameOver = false
    }

    // MARK: - Unified Move Handling
    @discardableResult
    func makeMove(at position: Int, player: Player, opponent: Player, gameMode: GameMode, level: DifficultyLevel) -> Bool {
        if gameMode == .twoPlayer {
            return makeMoveForTwoPlayerMode(at: position, player, opponent)
        }
        else {
            return makeMoveForSinglePlayerMode(at: position, player, opponent, level: level)
        }
    }
    
    // MARK: - Two Player Mode
    @discardableResult
    private func makeMoveForTwoPlayerMode(at position: Int,_ player: Player,_ opponent: Player) -> Bool {
        guard makeMove(
            at: position,
            for: player,
            and: opponent
        ) else { return false }
        
        if isGameOver {
            return true
        }
        return true
    }
    
    // MARK: - Single Player Mode (Human vs AI)
    @discardableResult
    private func makeMoveForSinglePlayerMode(at position: Int,_ player: Player,_ opponent: Player, level: DifficultyLevel) -> Bool {
        guard makeMove(at: position, for: player, and: opponent) else { return false }
        
        if !isGameOver {
            aiMove(with: player, and: opponent, with: level)
        }
        aiMoveHandler?()
        return true
    }
    
    // MARK: - Основной метод для выполнения хода
    @discardableResult
    private func makeMove(at position: Int, for player: Player, and opponent: Player) -> Bool {
        guard isValidMove(at: position) else { return false }
        gameBoard[position] = player.symbol
        evaluateGameState(for: player, opponent: opponent)
        return true
    }
    
    // MARK: - AI Move
    func aiMove(with player: Player, and opponent: Player, with level: DifficultyLevel) {
        guard !isGameOver else { return }

        aiDecision(for: player, and: opponent, level: level) { [weak self] move in
            guard let self = self, let move = move else { return }

            self.performAIMove(player1: player, player2: opponent, at: move)
            self.aiMoveHandler?()
        }
    }

    private func aiDecision(for player1: Player, and opponent: Player, level: DifficultyLevel, completion: @escaping (Int?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let move: Int?
            
            switch level {
            case .easy:
                move = self.findFirstAvailableMove()
            case .normal:
                move = self.findCenterMove() ?? self.findWinningMove(for: opponent.symbol) ?? self.findFirstAvailableMove()
            case .hard:
                move = self.findWinningMove(for: opponent.symbol) ?? self.findWinningMove(for: player1.symbol) ?? self.findCenterMove() ?? self.findCornerMove() ?? self.findFirstAvailableMove()
            }

            completion(move)
        }
    }
    
    private func performAIMove(player1: Player, player2: Player, at position: Int) {
        gameBoard[position] = player2.symbol
        evaluateGameState(for: player1, opponent: player2)
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
        }
    }


    private func findWinningMove(for type: PlayerSymbol) -> Int? {
        for pattern in winningCombinations {
            let values = pattern.map { gameBoard[$0] }
            if values.filter({ $0 == type }).count == 2, let emptyIndex = pattern.first(where: { gameBoard[$0] == nil }) {
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

    private func isBoardFull() -> Bool {
        return gameBoard.allSatisfy { $0 != nil }
    }

    private func checkWin(for type: PlayerSymbol) -> Bool {
        return winningCombinations.contains { pattern in
            pattern.allSatisfy { gameBoard[$0] == type }
        }
    }
    
    var winningCombinations: [[Int]] {
        return [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],  // Horizontal
            [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Vertical
            [0, 4, 8], [2, 4, 6]  // Diagonal
        ]
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

    // Получение результата игры
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
}
