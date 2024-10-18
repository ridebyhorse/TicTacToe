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
                    PlayerSquareView(player: viewModel.state.player)
                    VStack(spacing: 8) {
                        Text(viewModel.timerDisplay)
                            .font(.basicTitle)

                        Text(Resources.Text.score)
                            .font(.basicTitle)

                        Text(viewModel.currentScore)
                            .font(.basicSubtitle)
                    }
                    PlayerSquareView(player: viewModel.state.opponent)
                }
                HStack {
                    Image(getPlayerImageName(for: viewModel.currentPlayer))
                        .resizable()
                        .frame(width: 54, height: 54)
                    Text(viewModel.currentPlayer.name)
                     
                        .font(.basicTitle)
                }
                .padding(.top, 45)
                GameFieldView(
                    gameBoard: viewModel.gameBoard,
                    playerStyle: viewModel.currentPlayer.style,
                    action: viewModel.processPlayerMove(at:),
                    boardSize: viewModel.boardSize,
                    winningPattern: viewModel.state.winningPattern
                )
                .padding(.top, 20)
                Spacer()
                    .padding(.bottom, 40)
            }
            .padding(.bottom, 50)
        }
 
    }

    // MARK: - Helper to get player image based on style and type
    private func getPlayerImageName(for player: Player) -> String {
        let imageNames = player.style.imageNames
        return player.symbol == .x ? imageNames.player1 : imageNames.player2
    }
}

#Preview {
    GameView(viewModel: GameViewModel(coordinator: Coordinator()))
}
