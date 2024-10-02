//
//  StyleCellView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import SwiftUI

struct StyleCellView: View {
    let styleImageForPlayer1: String
    let styleImageForPlayer2: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack {
            HStack {
                Image(styleImageForPlayer1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: isSelected ? 80 : 60, height: isSelected ? 80 : 60)
                    .padding(5)
                
                Image(styleImageForPlayer2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: isSelected ? 80 : 60, height: isSelected ? 80 : 60)
                    .padding(5)
            }
            .padding(.bottom, isSelected ? 20 : 10)

            Button(action: {
                action()
            }) {
                Text(isSelected ? Resources.Text.picked : Resources.Text.choose)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(isSelected ? Color.basicBlue : Color.basicLightBlue)
                    .cornerRadius(20)
                    .foregroundColor(isSelected ? .white : Color.basicBlack)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .frame(width: isSelected ? 250 : 200, height: isSelected ? 250 : 200) 
    }
}

#Preview {
    StyleCellView(
        styleImageForPlayer1: "crossPink",
        styleImageForPlayer2: "circlePurple",
        isSelected: true,
        action: { print("Selected") }
    )
}
