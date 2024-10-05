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
        HStack(spacing: 20) {
            Text(Resources.Text.selectSymbol.localized(language))
                .font(.headline)
                .foregroundColor(.basicBlack)
            
            HStack(spacing: 20) {
                symbolButton(symbol: .cross, imageName: imageNameForPlayer1)
                symbolButton(symbol: .circle, imageName: imageNameForPlayer2)
            }
        }
        .padding()
        .frame(width: 300, height: 100)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)
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
                .background(selectedSymbol == symbol ? Color.basicBackground : Color.white)
                .cornerRadius(20)
                .shadow(radius: 0.2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedSymbol == symbol ? Color.basicBlue.opacity(0.2) : Color.clear, lineWidth: 2)
                )
        }
    }

    private func selectPlayerSymbol(_ symbol: PlayerSymbol) {
        selectedSymbol = symbol
    }
}

