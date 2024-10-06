//
//  ResultView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct ResultView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @ObservedObject var viewModel: ResultViewModel
    
    var body: some View {
        VStack {
            Spacer()
            switch viewModel.gameResult {
            case .win(let name):
                Text(name + " " + Resources.Text.winResult.localized(language))
                    .font(.basicTitle)
                    .padding(10)
                Image(.winIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 60)
            case .lose:
                Text(Resources.Text.loseResult.localized(language))
                    .font(.basicTitle)
                    .padding(10)
                Image(.loseIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 60)
            case .draw:
                Text(Resources.Text.drawResult.localized(language))
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
                title: Resources.Text.playAgain.localized(language),
                tapHandler: viewModel.restartGame
            )
            BasicButton(
                styleType: .secondary,
                title: Resources.Text.back.localized(language),
                tapHandler: viewModel.openLaunch
            )
        }
        .padding(.horizontal, 21)
    }
}

#Preview {
    ResultView(viewModel: ResultViewModel(coordinator: Coordinator(), winner: Player(name: Resources.Text.ai, symbol: .cross, style: .burgerFries), playedAgainstAI: true))
}
