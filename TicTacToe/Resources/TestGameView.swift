//
//  TestGameView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

//import SwiftUI
//
//struct TestGameView: View {
//    @StateObject private var gameManager = GameManager( isPlayingAgainstAI: true)
//    var level: DifficultyLevel = .easy
//    
//    var body: some View {
//        VStack {
//            // Отображение победителя или текущего игрока
//            Text(gameManager.isGameOver ? (gameManager.winner != nil ? "\(gameManager.winner!.name) победил!" : "Ничья!") : "Текущий игрок: \(gameManager.userManager.currentPlayer.name)")
//                .font(.title)
//                .padding()
//            
//            // Сетка для игрового поля
//            gameBoardView()
//            
//            // Кнопка перезапуска игры при окончании
//            if gameManager.isGameOver {
//                Button("Начать заново") {
//                    gameManager.resetGame()
//                }
//                .padding()
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.white.ignoresSafeArea())
//    }
//    
//    // Представление для игрового поля
//    @ViewBuilder
//    private func gameBoardView() -> some View {
//        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
//            ForEach(0..<9) { index in
//                gameCell(at: index)
//            }
//        }
//        .padding()
//    }
//    
//    // Представление для каждой ячейки игрового поля
//    @ViewBuilder
//    private func gameCell(at index: Int) -> some View {
//        Button(action: {
//            gameManager.makeMove(at: index, with: level)
//        }) {
//            Text(symbolForCell(at: index))
//                .font(.system(size: 48, weight: .bold))
//                .frame(width: 80, height: 80)
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(12)
//        }
//        .disabled(gameManager.gameBoard[index] != nil || gameManager.isGameOver)
//    }
//    
//    // Возвращает символ для ячейки ("X", "O" или пусто)
//    private func symbolForCell(at index: Int) -> String {
//        if let playerType = gameManager.gameBoard[index] {
//            return playerType == .cross ? "X" : "O"
//        }
//        return ""
//    }
//}
//
//#Preview {
//    TestGameView()
//}
