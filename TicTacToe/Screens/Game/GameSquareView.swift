//
//  GameSquareView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 30.09.2024.
//

import SwiftUI

import SwiftUI

struct GameSquareView: View {
    
    @Binding var move: Move?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 74, height: 74)
                .foregroundColor(Color("basicLightBlue"))
            
            if let move = move {
                Image(move.indicator)
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    @State var squareMove: Move? = Move(player: .human, boardIndex: 0)
    return GameSquareView(move: $squareMove)
}

