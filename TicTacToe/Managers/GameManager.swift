//
//  GameManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//


import Foundation

final class GameManager {
    public static let shared = GameManager()

    private var settings: GameSettings?

    var gameBoard: [PlayerSymbol?] = Array(repeating: nil, count: 9)
    private(set) var isGameOver: Bool = false
    private(set) var winner: User? = nil
    private(set) var gameMode: GameMode = .singlePlayer
    private var currentPlayerSymbol: PlayerSymbol = .cross
    private var aiSymbol: PlayerSymbol = .circle

    // MARK: - Init
    private init() {}

    // MARK: - Установка настроек игры
    func setGameSettings(_ settings: GameSettings) {
        self.settings = settings
        self.currentPlayerSymbol = settings.playerSymbol
        
        // Присвоение AI символа, противоположного символу игрока
        aiSymbol = (settings.playerSymbol == .cross) ? .circle : .cross
    }

    // Сброс игры с начальной настройкой игроков и символов
    func resetGame(gameMode: GameMode, firstPlayer: User, secondPlayer: User) {
        guard let settings = self.settings else { return }
        self.gameMode = gameMode
        self.gameBoard = Array(repeating: nil, count: 9)
        self.winner = nil
        self.isGameOver = false
        self.currentPlayerSymbol = settings.playerSymbol
    }

    // Получение результата игры
    func getGameResult(firstPlayer: User, secondPlayer: User) -> GameResult {
        if let winner = winner {
            if gameMode == .singlePlayer && winner == secondPlayer {
                return .lose
            } else {
                return .win(name: winner.name)
            }
        } else if isBoardFull() {
            return .draw
        }
        return .draw
    }

    // Ход игрока
    @discardableResult
    func makeMove(at position: Int, currentPlayer: User, opponentPlayer: User) -> Bool {
        guard isValidMove(at: position) else { return false }

        gameBoard[position] = currentPlayerSymbol
        evaluateGameState(currentPlayer: currentPlayer, opponentPlayer: opponentPlayer)

        // Если режим игры одиночный и ход AI
        if gameMode == .singlePlayer && !isGameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.aiMove()
            }
        }
        return true
    }

    // Ход AI
    private func aiMove() {
        let level = settings?.level ?? .easy // Берём уровень сложности из настроек
        switch level {
        case .easy:
            aiEasyMove()
        case .standard:
            aiStandardMove()
        case .hard:
            aiHardMove()
        }
    }

    // AI стратегия для сложного уровня
    private func aiHardMove() {
        guard !isGameOver else { return }

        if let move = findWinningMove(for: aiSymbol) ??
            findWinningMove(for: currentPlayerSymbol) ??
            findCenterMove() ??
            findCornerMove() ??
            findFirstAvailableMove() {
            performAIMove(at: move)
        }
    }

    // AI стратегия для среднего уровня
    private func aiStandardMove() {
        guard !isGameOver else { return }

        if let move = findCenterMove() ??
            findWinningMove(for: aiSymbol) ??
            findFirstAvailableMove() {
            performAIMove(at: move)
        }
    }

    // AI стратегия для простого уровня
    private func aiEasyMove() {
        guard !isGameOver else { return }

        if let move = findFirstAvailableMove() {
            performAIMove(at: move)
        }
    }

    // Выполнение хода AI
    private func performAIMove(at position: Int) {
        gameBoard[position] = aiSymbol // Символ AI
        evaluateGameState(currentPlayer: nil, opponentPlayer: nil)
    }

    // Логика проверки состояния игры после хода
    private func evaluateGameState(currentPlayer: User?, opponentPlayer: User?) {
        if checkWin(for: currentPlayerSymbol) {
            if let currentPlayer = currentPlayer, let opponentPlayer = opponentPlayer {
                winner = currentPlayerSymbol == currentPlayer.type ? currentPlayer : opponentPlayer
            }
            isGameOver = true
        } else if isBoardFull() {
            isGameOver = true
        } else {
            switchPlayer()
        }
    }

    // Переключение игрока
    private func switchPlayer() {
        currentPlayerSymbol = (currentPlayerSymbol == .cross) ? .circle : .cross
    }

    // Проверка, что ход корректен
    private func isValidMove(at position: Int) -> Bool {
        return position >= 0 && position < 9 && gameBoard[position] == nil && !isGameOver
    }

    // Проверка на полную доску
    private func isBoardFull() -> Bool {
        return gameBoard.allSatisfy { $0 != nil }
    }

    // Проверка выигрыша
    private func checkWin(for type: PlayerSymbol) -> Bool {
        return winningPatterns.contains { pattern in
            pattern.allSatisfy { gameBoard[$0] == type }
        }
    }

    // Логика нахождения выигрышного хода
    private func findWinningMove(for type: PlayerSymbol) -> Int? {
        for pattern in winningPatterns {
            let values = pattern.map { gameBoard[$0] }
            if values.filter({ $0 == type }).count == 2, let emptyIndex = pattern.first(where: { gameBoard[$0] == nil }) {
                return emptyIndex
            }
        }
        return nil
    }

    // Нахождение свободного центра
    private func findCenterMove() -> Int? {
        return gameBoard[4] == nil ? 4 : nil
    }

    // Нахождение свободного угла
    private func findCornerMove() -> Int? {
        let corners = [0, 2, 6, 8]
        return corners.first(where: { gameBoard[$0] == nil })
    }

    // Нахождение первого доступного хода
    private func findFirstAvailableMove() -> Int? {
        return gameBoard.firstIndex(where: { $0 == nil })
    }

    // Шаблоны для выигрыша
    private var winningPatterns: [[Int]] {
        return [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Горизонтальные
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Вертикальные
            [0, 4, 8], [2, 4, 6]             // Диагональные
        ]
    }
}
