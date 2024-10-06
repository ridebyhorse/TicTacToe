//
//  PlayerSquareView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 30.09.2024.
//

import SwiftUI


struct PlayerSquareView: View {
    let player: Player
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 104, height: 104)
                .foregroundColor(Color("basicLightBlue"))
            VStack(spacing: 10){
                Image(getPlayerImageName(for: player))
                    .resizable()
                    .frame(width: 54, height: 54)
                Text(player.name)
                    .font(.basicSubtitle)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("basicBlack"))
            }
        }
    }
    // MARK: - Helper to get player image based on style and type
        private func getPlayerImageName(for player: Player) -> String {
            let imageNames = player.style.imageNames
            return player.symbol == .cross ? imageNames.player1 : imageNames.player2
        }
}

#Preview {
    PlayerSquareView(player: Player(name: "Im", symbol: .circle, style: .cakeIcecream))
}
