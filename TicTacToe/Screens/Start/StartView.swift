//
//  StartView.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 29.09.2024.
//
import SwiftUI

struct StartView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @State private var isAnimating = false
    @ObservedObject var viewModel: StartViewModel

    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea(.all)
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
                                    .foregroundStyle(.basicBlack.opacity(0.9))
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
                    .scaleEffect(isAnimating ? 1.05 : 1)
                    .animation(
                        isAnimating ?
                            .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default,
                        value: isAnimating
                    )
                    .onAppear {
                        withAnimation(
                            .spring(response: 1, dampingFraction: 0.5)
                        ) {
                            isAnimating = true
                        }
                    }
                
                HStack(spacing: 2) {
                    Text(Resources.Text.ticTacToe)
                        .font(.mainTitle)
                        .foregroundColor(.basicBlack)
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
}
