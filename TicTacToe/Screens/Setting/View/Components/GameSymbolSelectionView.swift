//
//  GameSymbolSelectionView.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/1/24.
//
import SwiftUI

struct GameSymbolSelectionView: View {
    @Binding var selectedSymbol: PlayerSymbol
    let imageNameForPlayer1: String
    let imageNameForPlayer2: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your Symbol:")
                .font(.headline)
                .foregroundColor(.basicBlack)
            
            HStack(spacing: 30) {
                symbolButton(symbol: .cross, imageName: imageNameForPlayer1)
                symbolButton(symbol: .circle, imageName: imageNameForPlayer2)
            }
        }
        .padding()
        .frame(width: 270, height: 120)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 5)
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

