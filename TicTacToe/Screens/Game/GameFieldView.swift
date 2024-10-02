//
//  GameFieldView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 29.09.2024.
//

import SwiftUI

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        return player == .human ? "crossPink" : "circlePurple"
    }    
}

struct GameFieldView: View {
    @StateObject private  var viewModel = GameViewModel(coordinator: Coordinator())
    @State private var isXTurn = true
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 300, height: 300)
                .foregroundColor(.white)
                .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)
            
            LazyVGrid(columns: viewModel.columns, spacing: 20){
                ForEach(0..<9) { index in
                    GameSquareView(move: $viewModel.moves[index])
                        .onTapGesture {
                            viewModel.processPlayerMove(for: index)
                        }
                }
            }
            .padding(60)
        }
    }
}

#Preview {
    GameFieldView()
}
