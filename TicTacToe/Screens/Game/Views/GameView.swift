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
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack{
            Color("basicBackground")
            VStack{
                HStack(spacing: 32){
                    PlayerSquareView(playerIcon: settingsViewModel.selectedPlayerStyle.imageNames.player1)
                    Text("Time")
                        .font(.basicTitle)
                    PlayerSquareView(playerIcon: settingsViewModel.selectedPlayerStyle.imageNames.player2)
                }
                HStack{
                    Image("crossPink")
                        .resizable()
                        .frame(width: 54, height: 54)
                    Text("Player")
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
}

//#Preview {
//    GameView(viewModel: GameViewModel(coordinator: Coordinator()))
//}
