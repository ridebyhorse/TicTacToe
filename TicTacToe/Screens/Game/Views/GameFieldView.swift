//
//  GameFieldView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 29.09.2024.
//

import SwiftUI

struct GameFieldView: View {
    let gameBoard: [PlayerSymbol?]
    let action: (_ index: Int) -> Void
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 300, height: 300)
                .foregroundColor(.white)
                .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)

            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<9) { index in
                    GameSquareView(playerSymbol: gameBoard[index])
                        .onTapGesture {
                            action(index)
                        }
                }
            }
            .padding(60)
        }
    }
}

#Preview {
    GameFieldView(gameBoard: Array(repeating: nil, count: 9), action: { index in index + 1 })
}
