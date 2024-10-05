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
                Text("Difficulty level - \(viewModel.level.rawValue)")
                    .padding(.top)
                Text("mode - \(viewModel.gameMode)")
                    .padding(.top)
                HStack(spacing: 32) {
                    PlayerSquareView(player: viewModel.player)
                    Text("Time")
                        .font(.basicTitle)
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
                    action: viewModel.processPlayerMove(for:))
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
