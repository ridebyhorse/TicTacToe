//
//  GameEnvironmentsModel.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 18.10.2024.
//

import Foundation

struct GameEnvironmentsModel {
    static var smallBoard: GameEnvironmentsModel { getSmallEnvironments() }
    static var mediumBoard: GameEnvironmentsModel { getSmallEnvironments() }
    static var largeBoard: GameEnvironmentsModel { getSmallEnvironments() }
    static var extraLargeBoard: GameEnvironmentsModel { getSmallEnvironments() }
    
    let boardSize: BoardSize
    let winningCombinations: [[Int]]

    static func getSmallEnvironments() -> GameEnvironmentsModel {
        let size = BoardSize.small.dimension
        
        var combinations: [[Int]] = []
        
        // Horizontal
        for row in 0..<size {
            let start = row * size
            combinations.append(Array(start..<(start + size)))
        }
        
        // Vertical
        for col in 0..<size {
            var combination: [Int] = []
            for row in 0..<size {
                combination.append(row * size + col)
            }
            combinations.append(combination)
        }
        
        // Diagonal
        var diagonal1: [Int] = []
        var diagonal2: [Int] = []
        for i in 0..<size {
            diagonal1.append(i * size + i)
            diagonal2.append(i * size + (size - i - 1))
        }
        combinations.append(diagonal1)
        combinations.append(diagonal2)
        
        return GameEnvironmentsModel(boardSize: .small, winningCombinations: combinations)
    }
}

