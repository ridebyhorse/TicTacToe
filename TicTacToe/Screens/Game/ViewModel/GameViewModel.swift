//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    // MARK: - Properties
    private let coordinator: Coordinator
    private let userManager: UserManager
    private let gameManager: GameManager
    private let storageManager: StorageManager

    @Published var gameBoard: [PlayerSymbol?] = Array(repeating: nil, count: 9)
    @Published private(set) var gameResult: GameResult? = nil
    @Published var player1: User
    @Published var player2: User
    @Published var currentPlayer: User
    @Published var gameMode: GameMode = .singlePlayer

    private var level: DifficultyLevel = .standard
    
    // MARK: - Initialization
    init(
        coordinator: Coordinator,
        userManager: UserManager = .shared,
        gameManager: GameManager = .shared,
        storageManager: StorageManager = .shared
    ) {
        self.coordinator = coordinator
        self.userManager = userManager
        self.gameManager = gameManager
        self.storageManager = storageManager

        // Инициализация игроков
        self.player1 = userManager.player1
        self.player2 = userManager.player2
        self.currentPlayer = userManager.currentPlayer
        
        // Загрузка настроек и установка их в GameManager
        let savedSettings = storageManager.getSettings()
        self.level = savedSettings.level
        
        resetGame()
    }
    
    // MARK: - Game Logic
    func processPlayerMove(for position: Int) {
        guard !isSquareOccupied(at: position) else { return }
        
        if gameManager.makeMove(at: position, currentPlayer: currentPlayer, opponentPlayer: player2) {
            updateGameBoard()
            
            if gameManager.isGameOver {
                let result = gameManager.getGameResult(firstPlayer: player1, secondPlayer: player2)
                handleGameResult(result)
            }
        }
    }
    
    func resetGame() {
        // Получаем сохраненные настройки из StorageManager
        let savedSettings = storageManager.getSettings()
        
        // Установка настроек в GameManager
        gameManager.setGameSettings(savedSettings)
        gameManager.resetGame(gameMode: gameMode, firstPlayer: player1, secondPlayer: player2)
        
        // Обновление доски
        updateGameBoard()
    }
    
    func updateGameBoard() {
        gameBoard = gameManager.gameBoard // Обновляем gameBoard напрямую
    }
    
    func isSquareOccupied(at index: Int) -> Bool {
        return gameBoard[index] != nil
    }
    
    private func handleGameResult(_ result: GameResult) {
        gameResult = result
        switch result {
        case .win(let name):
            coordinator.updateNavigationState(
                action: .showResult(
                    winner: gameManager.winner,
                    playedAgainstAI: gameMode == .singlePlayer
                )
            )
        case .lose:
            coordinator.updateNavigationState(
                action: .showResult(
                    winner: player2,
                    playedAgainstAI: gameMode == .singlePlayer
                )
            )
        case .draw:
            coordinator.updateNavigationState(
                action: .showResult(
                    winner: nil,
                    playedAgainstAI: gameMode == .singlePlayer
                )
            )
        }
    }
}
