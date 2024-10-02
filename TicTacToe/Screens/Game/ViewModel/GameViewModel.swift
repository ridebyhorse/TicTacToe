//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    // MARK: Properties
    private let coordinator: Coordinator
    
    private let gameManager: GameManager
    private let userManager: UserManager
    private let storageManager: StorageManager
    
    private let user: User? = nil
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    
    // MARK: - Published Properties
    @Published private(set) var winner: User?
    @Published private(set) var gameResult: GameResult? = nil
    
    let level: DifficultyLevel = .standard
//    булька для смены варианта с ИИ играть или вдвоем
    let isPlayingAgainstAI: Bool = true
    
    // MARK: Initialization
    init(
        coordinator: Coordinator,
        gameManager: GameManager = .shared,
        userManager: UserManager = .shared,
        storageManager: StorageManager = .shared
    ) {
        self.coordinator = coordinator
        self.gameManager = gameManager
        self.userManager = userManager
        self.storageManager = storageManager
     
        resetGame()
    }
    
    // MARK: - Game Logic
    func processPlayerMove(for position: Int) {
        guard !isSquareOccupied(in: moves, forIndex: position) else { return }
        
        if gameManager.makeMove(at: position, with: level, with: isPlayingAgainstAI) {
            updateMoves()
            
            if gameManager.isGameOver {
                let result = gameManager.getGameResult(isPlayingAgainstAI: isPlayingAgainstAI)
                handleGameResult(result)
            }
        }
    }
    
    func resetGame() {
        gameManager.resetGame()
        updateMoves()
    }
    
    func updateMoves() {
        moves = gameManager.gameBoard.enumerated().map { index, playerType in
            guard let playerType = playerType else { return nil }
            return Move(player: playerType == .cross ? .human : .computer, boardIndex: index)
        }
        
        if gameManager.isGameOver {
            let result = gameManager.getGameResult(isPlayingAgainstAI: isPlayingAgainstAI)
            handleGameResult(result)
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func showResult() {
        coordinator.updateNavigationState(action: .showResult(
            winner: user,
            playedAgainstAI: isPlayingAgainstAI)
        )
    }
    
    private func handleGameResult(_ result: GameResult) {
        gameResult = result
        switch result {
        case .win(_):
            coordinator.updateNavigationState(
                action: .showResult(
                    winner: userManager.currentPlayer,
                    playedAgainstAI: isPlayingAgainstAI)
            )
        case .lose:
            coordinator.updateNavigationState(
                action: .showResult(
                    winner: nil,
                    playedAgainstAI: isPlayingAgainstAI)
            )
        case .draw:
            coordinator.updateNavigationState(
                action: .showResult(
                    winner: nil,
                    playedAgainstAI: isPlayingAgainstAI)
            )
        }
    }
}
