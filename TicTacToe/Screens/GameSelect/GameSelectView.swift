//
//  GameSelectView.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/1/24.
//

import SwiftUI

struct GameSelectView: View {
    @ObservedObject var viewModel: GameSelectViewModel
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @State private var showCustomAlert = false

    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                ToolBarView(
                    showRightButton: true,
                    rightButtonAction: viewModel.showSettings,
                    title: ""
                )
                .frame(height: 44)
                .background(Color.white)
                .zIndex(1)
                
                Spacer()
                gameSelectionCard
                Spacer()
            }
            .blur(radius: showCustomAlert ? 5 : 0)
            
            // Показ кастомного алерта
            if showCustomAlert {
                CustomAlertView(message: Resources.Text.enterYourNameAlert.localized(language)) {
                    showCustomAlert = false
                }
                .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
                .transition(.opacity)
                .zIndex(2)
                .frame(maxWidth: 300, maxHeight: 200)
                .cornerRadius(30)
            }
        }
        .onChange(of: viewModel.showingAlert) { newValue in
            if newValue {
                showCustomAlert = true
            }
        }
    }
    
    // MARK: - Game Selection Card
    private var gameSelectionCard: some View {
        VStack {
            Text(Resources.Text.selectGame.localized(language))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.basicBlue)
                .padding(10)
            
            VStack(alignment: .center) {
                Spacer()
                
                // Выбор между одиночной игрой и игрой на двоих
                gameModeButton(
                    icon: "singlePlayerIcon",
                    title: Resources.Text.singlePlayer.localized(language),
                    isSelected: viewModel.selectedGameMode == .singlePlayer
                ) {
                    viewModel.setGameMode(.singlePlayer)
                }
                
                if viewModel.selectedGameMode == .singlePlayer {
                    playerNameTextField(
                        placeholder: Resources.Text.enterYourName.localized(language),
                        text: $viewModel.player,
                        onSubmit: {
                            if viewModel.player.isEmpty {
                                showCustomAlert = true
                            } else {
                                viewModel.startGame()
                            }
                        }
                    )
                }
                
                gameModeButton(
                    icon: "twoPlayersIcon",
                    title: Resources.Text.twoPlayers.localized(language),
                    isSelected: viewModel.selectedGameMode == .twoPlayers
                ) {
                    viewModel.setGameMode(.twoPlayers)
                }
                
                if viewModel.selectedGameMode == .twoPlayers {
                    playerNameTextField(
                        placeholder: Resources.Text.player1Name.localized(language),
                        text: $viewModel.player
                    )
                    playerNameTextField(
                        placeholder: Resources.Text.player2Name.localized(language),
                        text: $viewModel.opponent
                    )
                }
                
                nextButton
            }
        }
        .padding()
        .frame(width: 285, height: cardHeight)
        .background(Color.white)
        .cornerRadius(30)
        .basicShadow()
    }
    
    // MARK: - Buttons
    private func gameModeButton(icon: String, title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(icon)
                Text(title)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .basicBlack)
            }
        }
        .frame(width: 245, height: 70)
        .background(isSelected ? Color.basicBlue : Color.basicLightBlue)
        .cornerRadius(35)
        .shadow(radius: 2)
        .padding(10)
    }
    
    private var nextButton: some View {
        Button(action: {
            if viewModel.player.isEmpty {
                showCustomAlert = true
            } else {
                viewModel.startGame()
            }
        }) {
            Text(Resources.Text.next.localized(language))
                .font(.title3)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
        .frame(width: 245, height: 70)
        .background(Color.basicBlue)
        .cornerRadius(35)
        .shadow(radius: 2)
        .padding(20)
    }
    
    // MARK: - Player Name TextField
    private func playerNameTextField(placeholder: String, text: Binding<String>, onSubmit: @escaping () -> Void = {}) -> some View {
        TextField(placeholder, text: text)
            .padding()
            .background(Color.basicLightBlue)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.basicBlack.opacity(0.08), lineWidth: 2)
            )
            .padding(.horizontal)
            .foregroundColor(.gray)
            .font(.system(size: 18, weight: .medium))
            .multilineTextAlignment(.center)
            .onSubmit(onSubmit)
    }
    
    // MARK: - Computed Properties
    private var cardHeight: CGFloat {
        switch viewModel.selectedGameMode {
        case .singlePlayer: return 450
        case .twoPlayers: return 514
        }
    }
}

#Preview {
    GameSelectView(viewModel: GameSelectViewModel(coordinator: Coordinator()))
}
