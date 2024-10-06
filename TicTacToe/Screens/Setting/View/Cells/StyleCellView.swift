//
//  StyleCellView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import SwiftUI

struct StyleCellView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
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
                Text(isSelected ? Resources.Text.picked.localized(language) : Resources.Text.choose.localized(language))
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
        .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)
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
