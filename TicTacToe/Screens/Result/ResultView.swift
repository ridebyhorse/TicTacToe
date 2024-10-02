//
//  ResultView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

enum GameResult {
    case win(name: String)
    case lose
    case draw
}

struct ResultView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @ObservedObject var viewModel: ResultViewModel
    
    var body: some View {
        VStack {
            Spacer()
            switch viewModel.gameResult {
            case .win(let name):
                Text(name + Resources.Text.winResult)
                    .font(.basicTitle)
                    .padding(10)
                Image(.winIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 60)
            case .lose:
                Text(Resources.Text.loseResult)
                    .font(.basicTitle)
                    .padding(10)
                Image(.loseIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 60)
            case .draw:
                Text(Resources.Text.drawResult)
                    .font(.basicTitle)
                    .padding(10)
                Image(.drawIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 60)
            }
            Spacer()
            BasicButton(
                styleType: .primary,
                title: Resources.Text.playAgain,
                tapHandler: viewModel.restartGame
            )
            BasicButton(
                styleType: .secondary,
                title: Resources.Text.back,
                tapHandler: viewModel.openLaunch
            )
        }
        .padding(.horizontal, 21)
    }
}

#Preview {
    ResultView(viewModel: ResultViewModel(coordinator: Coordinator(), winner: User(name: Resources.Text.secondPlayer, type: .cross), playedAgainstAI: false))
}
