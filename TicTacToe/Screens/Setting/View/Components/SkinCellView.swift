//
//  StyleCellView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import SwiftUI

struct SkinCellView: View {
    // MARK: - Properties
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    let styleImageForPlayer1: String
    let styleImageForPlayer2: String
    let isSelected: Bool
    let isPlayer1Selected: Bool

    let action: () -> Void

    // MARK: - Body
    var body: some View {
        ShadowedCardView(
            borderColor: isSelected ? Color.secondaryPurple : Color.clear,
            borderWidth: 3
        ) {
            VStack {
                HStack {
                    Spacer()
                    
                    Group {
                        Image(isPlayer1Selected ? styleImageForPlayer1 : styleImageForPlayer2)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: isSelected ? 50 : 40,
                                height: isSelected ? 50 : 40
                            )
                        
                        Spacer()
                        
                        Image(isPlayer1Selected ? styleImageForPlayer2 : styleImageForPlayer1)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: isSelected ? 50 : 40,
                                height: isSelected ? 50 : 40
                            )
                    }
                    .transition(.scale)
                    .animation(.easeInOut, value: isPlayer1Selected)
                    
                    Spacer()
                }
            }
        }
        .padding()
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
        isPlayer1Selected: true,
        action: { print("Selected") }
    )
}
