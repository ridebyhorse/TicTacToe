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
        ZStack {
            Color("basicBackground").ignoresSafeArea(.all)
            VStack {
                Color(.basicBackground)
                    .frame(height: 80)
                HStack(spacing: 32) {
                    PlayerSquareView(player: viewModel.player)
                    VStack(spacing: 8) {
                        Text(Resources.Text.time)
                            .font(.basicTitle)
                        Text(
                            String(viewModel.secondsCount / 60)
                            + ":"
                            + String(viewModel.secondsCount % 60)
                        )
                        Text(Resources.Text.score)
                            .font(.basicTitle)
                        Text(
                            String(viewModel.player.score)
                            + ":"
                            + String(viewModel.opponent.score)
                        )
                        
                            .font(.basicSubtitle)
                    }
                    PlayerSquareView(player: viewModel.opponent)
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
                    gameBoard: viewModel.gameBoard,
                    playerStyle: viewModel.playerStyle,
                    action: viewModel.processPlayerMove(for:),
                    winningPattern: viewModel.winningPattern)
                    .padding(.top, 20)
                Spacer()
                    .padding(.bottom, 50)
            }
            .padding(.bottom, 60)
        }
    }
    
    // MARK: - Helper to get player image based on style and type
        private func getPlayerImageName(for player: Player) -> String {
            let imageNames = player.style.imageNames
            return player.symbol == .cross ? imageNames.player1 : imageNames.player2
        }
}

#Preview {
    GameView(viewModel: GameViewModel(coordinator: Coordinator()))
}
