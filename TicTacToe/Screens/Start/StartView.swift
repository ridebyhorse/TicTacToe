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
    
    let textArray = Array(Resources.Text.ticTacToe)
    let colorsArray: [Color] = [
        .basicBlue, .secondaryPurple, .blue, .purple, .secondaryPink, .yellow.opacity(0.5), .pink.opacity(0.5), .cyan, .mint
    ]

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
                    viewModel.openLeaderboard()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.basicLightBlue)
                            .frame(height: 54)
                        HStack {
                            Image(.leaderboardIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 38, height: 29)
                            Text(Resources.Text.leaderboard.localized(language))
                                .font(.buttonTitle)
                                .foregroundStyle(.basicBlack)
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.top, 6)
                    .padding(.horizontal, 28)
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
            
            HStack(spacing: 2) {
                ForEach(0..<textArray.count, id: \.self) { index in
                    Text(String(textArray[index]))
                        .font(.mainTitle)
                        .foregroundColor(colorsArray[index % colorsArray.count])  // Применяем цвет из массива
                }
            }
            .padding(30)
            
            Spacer()
            
            BasicButton(
                styleType: .primary,
                title: Resources.Text.letsPlay.localized(language),
                tapHandler: { viewModel.startGame() }
            )
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 21)
    }
}
