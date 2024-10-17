//
//  GameSquareView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 30.09.2024.
//

import SwiftUI

struct GameSquareView: View {
    var playerSymbol: PlayerSymbol? 
    var playerStyle: PlayerStyle
    var squareSize: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: squareSize, height: squareSize)
                .foregroundColor(Color("basicLightBlue"))

            if let symbol = playerSymbol {
                Image(symbol == .x ? playerStyle.imageNames.player1 : playerStyle.imageNames.player2)
                    .resizable()
                    .scaledToFit()
                    .padding(10)
            }
        }
    }
}
