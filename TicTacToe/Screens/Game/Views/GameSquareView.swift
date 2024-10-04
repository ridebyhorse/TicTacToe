//
//  GameSquareView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 30.09.2024.
//

import SwiftUI

struct GameSquareView: View {
    var playerSymbol: PlayerSymbol? 

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 74, height: 74)
                .foregroundColor(Color("basicLightBlue"))

            if let symbol = playerSymbol {
                Image(symbol == .cross ? "crossPink" : "circlePurple")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
    }
}
