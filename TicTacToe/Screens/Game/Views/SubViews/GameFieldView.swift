//
//  GameFieldView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 29.09.2024.
//

import SwiftUI

struct GameFieldView: View {
    let gameBoard: [PlayerSymbol?]
    let playerStyle: PlayerStyle
    let action: (_ index: Int) -> Void
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    var winningPattern: [Int]?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 300, height: 300)
                .foregroundColor(.white)
                .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<9) { index in
                    GameSquareView(
                        playerSymbol: gameBoard[index],
                        playerStyle: playerStyle
                    )
                    .onTapGesture {
                        action(index)
                    }
                }
            }
            .padding(60)
            // Отрисовка линии выигрыша
            if let pattern = winningPattern {
                GeometryReader { geometry in
                    let linePoints = getLinePoints(for: pattern, gridSize: geometry.size.width)
                    Path { path in
                        path.move(to: linePoints.start)
                        path.addLine(to: linePoints.end)
                    }
                    .stroke(Color.pink, lineWidth: 5)
                }
            }
        }
    }
    
    private func getLinePoints(for pattern: [Int], gridSize: CGFloat) -> LinePoints {
        let cellSize = gridSize / 3
        let lineExtension: CGFloat = 0.3 // Amount to extend the lines beyond the grid
        
        // Определяем стартовые и конечные точки в зависимости от паттерна
        switch pattern {
        case [0, 1, 2]: // Горизонтальная первая линия
            return LinePoints(start: CGPoint(x: -lineExtension, y: cellSize / 1.5),
                              end: CGPoint(x: gridSize + lineExtension, y: cellSize / 1.3))
            
        case [3, 4, 5]: // Горизонтальная вторая линия
            return LinePoints(start: CGPoint(x: -lineExtension, y: cellSize * 1.5),
                              end: CGPoint(x: gridSize + lineExtension, y: cellSize * 1.5))
            
        case [6, 7, 8]: // Горизонтальная третья линия
            return LinePoints(start: CGPoint(x: -lineExtension, y: cellSize * 2.1),
                              end: CGPoint(x: gridSize + lineExtension, y: cellSize * 2.3))
        
        case [0, 3, 6]: // Вертикальная первая линия
            return LinePoints(start: CGPoint(x: cellSize * 0.8, y: -lineExtension),
                                      end: CGPoint(x: cellSize * 0.9, y: gridSize + lineExtension))
            
        case [1, 4, 7]: // Вертикальная вторая линия
            return LinePoints(start: CGPoint(x: cellSize * 1.5, y: -lineExtension),
                              end: CGPoint(x: cellSize * 1.6, y: gridSize + lineExtension))
            
        case [2, 5, 8]: // Вертикальная третья линия
            return LinePoints(start: CGPoint(x: cellSize * 2.2, y: -lineExtension),
                              end: CGPoint(x: cellSize * 2.3, y: gridSize + lineExtension))
            
        case [0, 4, 8]: // Диагональ с верхнего левого угла
            return LinePoints(start: CGPoint(x: -lineExtension, y: -lineExtension),
                              end: CGPoint(x: gridSize + lineExtension, y: gridSize + lineExtension))
            
        case [2, 4, 6]: // Диагональ с верхнего правого угла
            return LinePoints(start: CGPoint(x: gridSize + lineExtension, y: -lineExtension),
                              end: CGPoint(x: -lineExtension, y: gridSize + lineExtension))
            
        default:
            return LinePoints(start: CGPoint.zero, end: CGPoint.zero) // Паттерн не найден
        }
    }
}

#Preview {
    GameFieldView(gameBoard: Array(repeating: nil, count: 9), playerStyle: .cakeIcecream, action: { index in })
}
