//
//  GameView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct GameView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack{
            Color("basicBackground")
            VStack{
                HStack(spacing: 32){
                    PlayerSquareView(player: viewModel.player1)
                    Text("Time")
                        .font(.basicTitle)
                    PlayerSquareView(player: viewModel.player2)
                }
                HStack{
                    Image(getPlayerImageName(for: viewModel.currentPlayer))
                        .resizable()
                        .frame(width: 54, height: 54)
                    Text(viewModel.currentPlayer.name)
                        .font(.basicTitle)
                }
                .padding(.top, 45)
                GameFieldView(
                    moves: viewModel.moves,
                    action: viewModel.processPlayerMove(for:))
                    .padding(.top, 20)
                Spacer()
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Helper to get player image based on style and type
        private func getPlayerImageName(for player: User) -> String {
            let imageNames = player.style.imageNames
            return player.type == .cross ? imageNames.player1 : imageNames.player2
        }
}

#Preview {
    GameView(viewModel: GameViewModel(coordinator: Coordinator()))
}
