//
//  GameFieldView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 29.09.2024.
//

import SwiftUI

struct GameFieldView: View {
    
    
    @State private var gridValues = Array(repeating: String?.none, count: 9)
    @State private var isXTurn = true
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 300, height: 300)
                .foregroundColor(.white)
                .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)
            
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(0..<9) { index in
                    GameSquareView(value: $gridValues[index])
                        .onTapGesture {
                            if gridValues[index] == nil {
                                gridValues[index] = isXTurn ? "crossPink" : "circlePurple"
                                isXTurn.toggle()
                            }
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
