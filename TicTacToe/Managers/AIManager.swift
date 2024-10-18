//
//  AIManager.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 18.10.2024.
//

import Foundation

final class AIManager {
    static let shared = AIManager()
    
    private(set) var gameBoard: [PlayerSymbol?] = []
    
    var winner: Player?
    var onBoardChange: (([PlayerSymbol?]) -> Void)?
    
    private var gameEnvironmentsModel: GameEnvironmentsModel?
    
    // MARK: - Init
    private init() {
        // Забираем из настроек размер борда
        let boardSize = StorageManager.shared.getSettings().boardSize
        
        switch boardSize {
        case .small:
            gameEnvironmentsModel = GameEnvironmentsModel.getSmallEnvironments()
        case .medium:
            gameEnvironmentsModel = GameEnvironmentsModel.getSmallEnvironments()
        case .large:
            gameEnvironmentsModel = GameEnvironmentsModel.getSmallEnvironments()
        case .extraLarge:
            gameEnvironmentsModel = GameEnvironmentsModel.getSmallEnvironments()
        }
    }
    
    // MARK: - AI Move
    func aiMove(for aiPlayer: Player, against humanPlayer: Player, difficulty: DifficultyLevel) -> Int? {
        var aiMove: Int?
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
            aiMove = move
        }
        return aiMove
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
    
    // MARK: - Winning/Available Moves Helpers
    private func findWinningMove(for symbol: PlayerSymbol) -> Int? {
        guard 
            let winningCombinations = gameEnvironmentsModel?.winningCombinations,
            let boardSize = gameEnvironmentsModel?.boardSize
        else { return nil }
        
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
        guard let boardSize = gameEnvironmentsModel?.boardSize else { return nil }
        
        let size = boardSize.dimension
        let corners = [0, size - 1, gameBoard.count - size, gameBoard.count - 1]
        return corners.first(where: { gameBoard[$0] == nil })
    }
    
    private func findFirstAvailableMove() -> Int? {
        return gameBoard.firstIndex(where: { $0 == nil })
    }
}
