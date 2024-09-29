//
//  GameManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

protocol IGameManager {
    var currentPlayer: User { get }
    var gameBoard: [PlayerType?] { get }
    var winner: User? { get }
    var isGameOver: Bool { get }
    
    func makeMove(at position: Int) -> Bool
    func resetGame()
}

import Foundation

final class GameManager: ObservableObject, IGameManager {
    @Published private(set) var currentPlayer: User
    @Published private(set) var gameBoard: [PlayerType?]
    @Published private(set) var winner: User?
    @Published private(set) var isGameOver: Bool = false
    
    private let player1: User
    private let player2: User
    private let isPlayingAgainstAI: Bool
    
    init(player1: User = User(name: "You", type: .cross),
         player2: User = User(name: "Second Player", type: .circle),
         isPlayingAgainstAI: Bool = false) {
        
        self.player1 = player1
        self.player2 = player2
        self.isPlayingAgainstAI = isPlayingAgainstAI
        self.currentPlayer = player1
        self.gameBoard = Array(repeating: nil, count: 9)
    }
    
    func makeMove(at position: Int) -> Bool {
        guard position >= 0 && position < 9, gameBoard[position] == nil, !isGameOver else {
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
            aiMove()
        }
        
        return true
    }
    
    func resetGame() {
        gameBoard = Array(repeating: nil, count: 9)
        winner = nil
        isGameOver = false
        currentPlayer = player1
    }
    
    // AI делает ход
    private func aiMove() {
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
