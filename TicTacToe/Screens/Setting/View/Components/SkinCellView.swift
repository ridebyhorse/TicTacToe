//
//  StyleCellView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import SwiftUI

struct SkinCellView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    let styleImageForPlayer1: String
    let styleImageForPlayer2: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Image(styleImageForPlayer1)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: isSelected ? 50 : 40,
                        height: isSelected ? 50 : 40
                    )
                
                Spacer()
                
                Image(styleImageForPlayer2)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: isSelected ? 50 : 40,
                        height: isSelected ? 50 : 40
                    )
                
                Spacer()
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(isSelected ? Color.secondaryPurple : Color.clear, lineWidth: 3)
        )
        .frame(
            width: isSelected ? 100 : 90,
            height: isSelected ? 100 : 90
        )
        .animation(.easeInOut, value: isSelected)
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    SkinCellView(
        styleImageForPlayer1: "crossPink",
        styleImageForPlayer2: "circlePurple",
        isSelected: true,
        action: { print("Selected") }
    )
}
