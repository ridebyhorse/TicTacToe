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
        GridItem(.flexible(), spacing: Drawing.spacing),
        GridItem(.flexible(), spacing: Drawing.spacing),
        GridItem(.flexible(), spacing: Drawing.spacing)
    ]
    var winningPattern: [Int]?
    
    @State private var animateLine = false
    @Namespace private var symbolNamespace 
    
    // MARK: - Drawing Constants
    enum Drawing {
        static let gridSize: CGFloat = 300
        static let cornerRadius: CGFloat = 30
        static let lineWidth: CGFloat = 10
        static let animationDuration: Double = 0.5
        static let gridPadding: CGFloat = 60
        static let spacing: CGFloat = 20
        static let cellTransitionScale: CGFloat = 0.9
    }
    
    var body: some View {
        ZStack {
            // Фон игрового поля
            RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                .frame(width: Drawing.gridSize, height: Drawing.gridSize)
                .foregroundColor(.basicWhite)
                .basicShadow()
            
            // Сетка игрового поля
            LazyVGrid(columns: columns, spacing: Drawing.spacing) {
                ForEach(0..<9) { index in
                    GameSquareView(
                        playerSymbol: gameBoard[index],
                        playerStyle: playerStyle
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)) {
                            action(index)
                        }
                    }
                    .transition(.scale(scale: Drawing.cellTransitionScale).combined(with: .opacity))
                    .animation(.easeInOut(duration: Drawing.animationDuration), value: gameBoard[index])
                }
            }
            .padding(Drawing.gridPadding)
            
            // Отрисовка линии выигрыша
            if let pattern = winningPattern {
                GeometryReader { geometry in
                    let linePoints = getLinePoints(for: pattern, gridSize: geometry.size.width)
                    Path { path in
                        path.move(to: linePoints.start)
                        path.addLine(to: linePoints.end)
                    }
                    .trim(from: 0, to: animateLine ? 1 : 0)
                    .stroke(
                        Color.basicBlue,
                        style: StrokeStyle(
                            lineWidth: Drawing.lineWidth,
                            lineCap: .round
                        )
                    )
                    .onAppear {
                        withAnimation(.easeInOut(duration: Drawing.animationDuration)) {
                            animateLine = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Определяем стартовые и конечные точки линии
    private func getLinePoints(for pattern: [Int], gridSize: CGFloat) -> WinnerLine {
        let cellSize = gridSize / 3
        
        switch pattern {
        case [0, 1, 2]: // Горизонтальная первая линия
            return WinnerLine(start: CGPoint(x: cellSize / 2, y: cellSize / 1.45),
                              end: CGPoint(x: cellSize * 2.5, y: cellSize / 1.45))
            
        case [3, 4, 5]: // Горизонтальная вторая линия
            return WinnerLine(start: CGPoint(x: cellSize / 2, y: cellSize * 1.45),
                              end: CGPoint(x: cellSize * 2.5, y: cellSize * 1.45))
            
        case [6, 7, 8]: // Горизонтальная третья линия
            return WinnerLine(start: CGPoint(x: cellSize / 2, y: cellSize * 2.15),
                              end: CGPoint(x: cellSize * 2.5, y: cellSize * 2.15))
            
        case [0, 3, 6]: // Вертикальная первая линия
            return WinnerLine(start:  CGPoint(x: cellSize / 1.25, y: cellSize / 2),
                              end: CGPoint(x: cellSize / 1.25, y: cellSize * 2.5))
            
        case [1, 4, 7]: // Вертикальная вторая линия
            return WinnerLine(start: CGPoint(x: cellSize * 1.5, y: cellSize / 2),
                              end: CGPoint(x: cellSize * 1.5, y: cellSize * 2.5))
            
        case [2, 5, 8]: // Вертикальная третья линия
            return WinnerLine(start: CGPoint(x: cellSize * 2.22, y: cellSize / 2),
                              end: CGPoint(x: cellSize * 2.22, y: cellSize * 2.5))
            
        case [0, 4, 8]: // Диагональ с верхнего левого угла
            return WinnerLine(start: CGPoint(x: cellSize / 2, y: cellSize / 2),
                              end: CGPoint(x: cellSize * 2.5, y: cellSize * 2.5))
            
        case [2, 4, 6]: // Диагональ с верхнего правого угла
            return WinnerLine(start: CGPoint(x: cellSize * 2.5, y: cellSize / 2),
                              end: CGPoint(x: cellSize / 2, y: cellSize * 2.5))
            
        default:
            return WinnerLine(start: CGPoint.zero, end: CGPoint.zero) // Паттерн не найден
        }
    }
}

#Preview {
    GameFieldView(gameBoard: Array(repeating: nil, count: 9), playerStyle: .cakeIcecream, action: { index in })
}
