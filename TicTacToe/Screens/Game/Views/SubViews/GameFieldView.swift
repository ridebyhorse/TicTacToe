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
    let boardSize: BoardSize
    
    var winningPattern: [Int]?
    
    @State private var animateLine = false
    @Namespace private var symbolNamespace
    
    // MARK: - Drawing Constants
    enum Drawing {
        static let cornerRadius: CGFloat = 30
        static let lineWidth: CGFloat = 10
        static let animationDuration: Double = 0.5
        static let gridPadding: CGFloat = 10
        static let spacing: CGFloat = 10
        static let cellTransitionScale: CGFloat = 0.9
    }
    
    // MARK: - Body
    var body: some View {
        ShadowedCardView() {
            LazyVGrid(
                columns: getColumns(),
                spacing: Drawing.spacing
            ) {
                ForEach(0..<gameBoard.count, id: \.self) { index in
                    GameSquareView(
                        playerSymbol: gameBoard[index],
                        playerStyle: playerStyle,
                        squareSize: getSquareWidth()
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
        }
        .frame(width: getFieldWidth(), height: getFieldWidth())
        
        // MARK: - Winning Line Drawing
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
    
    // MARK: - Helper Methods
    private func getFieldWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth - (44 * 2)
    }
    
    private func getSquareWidth() -> CGFloat {
        let totalSpacing = Drawing.spacing * CGFloat(boardSize.dimension - 1)
        let availableWidth = getFieldWidth() - totalSpacing
        return availableWidth / CGFloat(boardSize.dimension) / 1.2
    }
    
    private func getColumns() -> [GridItem] {
        return Array(
            repeating: GridItem(.flexible(), spacing: Drawing.spacing),
            count: boardSize.dimension
        )
    }
    
    // MARK: - Line Calculation for Winning Pattern
    private func getLinePoints(for pattern: [Int], gridSize: CGFloat) -> WinnerLine {
        let cellSize = gridSize / CGFloat(boardSize.dimension)
        
        let startRow = pattern.first! / boardSize.dimension
        let startCol = pattern.first! % boardSize.dimension
        let endRow = pattern.last! / boardSize.dimension
        let endCol = pattern.last! % boardSize.dimension
        
        let startX = CGFloat(startCol) * cellSize + cellSize / 2
        let startY = CGFloat(startRow) * cellSize + cellSize / 2
        let endX = CGFloat(endCol) * cellSize + cellSize / 2
        let endY = CGFloat(endRow) * cellSize + cellSize / 2
        
        return WinnerLine(start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }
}

#Preview {
    GameFieldView(
        gameBoard: Array(repeating: nil, count: 16),
        playerStyle: .cakeIcecream,
        action: { index in },
        boardSize: .medium
    )
}
