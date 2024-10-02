//
//  StartView.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 29.09.2024.
//

import SwiftUI

struct StartView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @ObservedObject var viewModel: StartViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.openRules()
                }, label: {
                    Image(.rulesIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                })
                Spacer()
                Button(action: {
                    viewModel.openSettings()
                }, label: {
                    Image(.settingsIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 38, height: 36)
                })
            }
            .padding(.top, 8)
            Spacer()
            Image(.mainIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 48)
            Text(Resources.Text.ticTacToe)
                .font(.mainTitle)
                .foregroundStyle(.basicBlack)
                .padding(30)
            Spacer()
            BasicButton(
                styleType: .primary,
                title: Resources.Text.letsPlay,
                tapHandler: { viewModel.startGame() }
            )
        }
        .padding(.horizontal, 21)
        
    }
}

#Preview {
    StartView(viewModel: StartViewModel(coordinator: Coordinator()))
}
