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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 74, height: 74)
                .foregroundColor(Color("basicLightBlue"))

            if let symbol = playerSymbol {
                Image(symbol == .tic ? playerStyle.imageNames.player1 : playerStyle.imageNames.player2)
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
    }
}
