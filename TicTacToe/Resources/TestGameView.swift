//
//  TestGameView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct TestGameView: View {
    @StateObject private var gameManager = GameManager(isPlayingAgainstAI: true)
    var level: DifficultyLevel = .easy
    
      var body: some View {
          VStack {
              Text(gameManager.winner != nil ? "\(gameManager.winner!.name) победил!" : "Текущий игрок: \(gameManager.currentPlayer.name)")
                  .font(.title)
                  .padding()

              LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                  ForEach(0..<9) { index in
                      Button(action: {
                          gameManager.makeMove(
                            at: index,
                            with: level
                          )
                      }) {
                          Text(gameManager.gameBoard[index] == .cross ? "X" : gameManager.gameBoard[index] == .circle ? "O" : "")
                              .font(.system(size: 64))
                              .frame(width: 100, height: 100)
                              .background(Color.gray.opacity(0.5))
                              .cornerRadius(12)
                      }
                      .disabled(gameManager.gameBoard[index] != nil || gameManager.isGameOver)
                  }
              }
              
              if gameManager.isGameOver {
                  Button("Начать заново") {
                      gameManager.resetGame()
                  }
                  .padding()
              }
          }
          .padding()
      }
}

#Preview {
    TestGameView()
}
