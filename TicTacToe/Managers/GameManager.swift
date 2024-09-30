//
//  GameManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//


import Foundation

final class GameManager: ObservableObject {
    @Published private(set) var currentPlayer: User
    @Published private(set) var gameBoard: [PlayerType?]
    @Published private(set) var winner: User?
    @Published private(set) var isGameOver: Bool = false
    
    private let player1: User
    private let player2: User
    private let isPlayingAgainstAI: Bool
    
    init(player1: User = User(type: .cross),
         player2: User = User(name: Resources.Text.secondPlayer, type: .circle),
         isPlayingAgainstAI: Bool = false) {
        
        self.player1 = player1
        self.player2 = player2
        self.isPlayingAgainstAI = isPlayingAgainstAI
        self.currentPlayer = player1
        self.gameBoard = Array(repeating: nil, count: 9)
    }
    
    func makeMove(at position: Int, with level: DifficultyLevel) -> Bool {
        guard position >= 0 && position < 9,
                gameBoard[position] == nil,
                !isGameOver else {
            return false
        }
        
        // Совершаем ход
        gameBoard[position] = currentPlayer.type
        
        // Проверяем на победу
        if checkWin(for: currentPlayer.type) {
            winner = currentPlayer
            isGameOver = true
        } else if gameBoard.allSatisfy({ $0 != nil }) {
            isGameOver = true // Ничья
        } else {
            // Меняем игрока
            currentPlayer = currentPlayer.type == .cross ? player2 : player1
        }
        
        // Если играем против AI и не завершена
        if isPlayingAgainstAI && !isGameOver && currentPlayer.type == player2.type {
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
    
//    MARK: AI
    
    private func aiMove(with level: DifficultyLevel) {
        switch level {
        case .easy:
            aiEasyMove()
        case .standart:
            aiStandartMove()
        case .hard:
            aiHardMove()
        }
    }
    
    // AI делает ход
    private func aiHardMove() {
        guard !isGameOver else { return }
        
        // 1. Если ИИ может победить на этом ходу — сделать ход.
        if let winningMove = findWinningMove(for: player2.type) {
            gameBoard[winningMove] = player2.type
            winner = player2
            isGameOver = true
            return
        }
        
        // 2. Если игрок может победить на следующем ходу — заблокировать его.
        if let blockingMove = findWinningMove(for: player1.type) {
            gameBoard[blockingMove] = player2.type
            currentPlayer = player1
            return
        }
        
        // 3. Если центр свободен, занять его.
        if gameBoard[4] == nil {
            gameBoard[4] = player2.type
            currentPlayer = player1
            return
        }
        
        // 4. Если один из углов свободен, занять его.
        let corners = [0, 2, 6, 8]
        if let cornerMove = corners.first(where: { gameBoard[$0] == nil }) {
            gameBoard[cornerMove] = player2.type
            currentPlayer = player1
            return
        }
        
        // 5. Сделать наивный ход (первый доступный).
        if let emptyPosition = gameBoard.firstIndex(where: { $0 == nil }) {
            gameBoard[emptyPosition] = player2.type
            currentPlayer = player1
        }
    }
    
    private func aiStandartMove() {
        
    }
    
    private func aiEasyMove() {
           guard !isGameOver else { return }
           
           // Наивная логика для AI (просто делает первый доступный ход)
           if let emptyPosition = gameBoard.firstIndex(where: { $0 == nil }) {
               gameBoard[emptyPosition] = player2.type
               if checkWin(for: player2.type) {
                   winner = player2
                   isGameOver = true
               }
               currentPlayer = player1
           }
       }

    
    // Найти выигрышный ход для данного типа игрока
    private func findWinningMove(for type: PlayerType) -> Int? {
        let winPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Горизонтальные линии
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Вертикальные линии
            [0, 4, 8], [2, 4, 6]             // Диагональные линии
        ]
        
        // Проверяем каждый возможный выигрышный шаблон
        for pattern in winPatterns {
            let values = pattern.map { gameBoard[$0] }
            // Считаем, сколько клеток занято данным игроком и сколько пусто
            let occupiedByPlayer = values.filter { $0 == type }.count
            let emptySpaces = values.filter { $0 == nil }.count
            
            // Если две клетки заняты данным игроком и одна пуста — это выигрышная ситуация
            if occupiedByPlayer == 2 && emptySpaces == 1 {
                if let emptyIndex = pattern.first(where: { gameBoard[$0] == nil }) {
                    return emptyIndex
                }
            }
        }
        
        return nil
    }
    
    // Проверка победной комбинации
    private func checkWin(for type: PlayerType) -> Bool {
        let winPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Горизонтали
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Вертикали
            [0, 4, 8], [2, 4, 6]             // Диагонали
        ]
        
        return winPatterns.contains { pattern in
            pattern.allSatisfy { gameBoard[$0] == type }
        }
    }
}
