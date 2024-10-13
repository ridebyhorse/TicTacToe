//
//  GameSymbolSelectionView.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/1/24.
//

import SwiftUI

struct GameSymbolSelectionView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @Binding var selectedSymbol: PlayerSymbol
    let imageNameForPlayer1: String
    let imageNameForPlayer2: String
    
    var body: some View {
        LightBlueBackgroundView {
            HStack(spacing: 20) {
                Text(Resources.Text.selectSymbol.localized(language))
                    .font(.headline)
                    .foregroundColor(.basicBlack)
                
                Spacer()
                
                symbolButton(symbol: .tic, imageName: imageNameForPlayer1)
                symbolButton(symbol: .tacToe, imageName: imageNameForPlayer2)
            }
            .frame(height: 80)
        }
    }
    
    // MARK: - Private Methods
    
    private func symbolButton(symbol: PlayerSymbol, imageName: String) -> some View {
        Button(action: {
            selectPlayerSymbol(symbol)
        }) {
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .background(selectedSymbol == symbol ? Color.basicBackground : Color.basicWhite)
                .cornerRadius(20)
                .shadow(radius: 0.2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedSymbol == symbol ? Color.secondaryPurple : Color.clear, lineWidth: 2)
                )
        }
    }
    
    private func selectPlayerSymbol(_ symbol: PlayerSymbol) {
        selectedSymbol = symbol
    }
}

#Preview {
    GameSymbolSelectionView(
        selectedSymbol: .constant(PlayerSymbol.tacToe),
        imageNameForPlayer1: "1",
        imageNameForPlayer2: "2")
}
