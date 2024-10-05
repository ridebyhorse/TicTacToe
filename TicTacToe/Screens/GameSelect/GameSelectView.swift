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
        }
        .alert(Resources.Text.enterYourNameAlert.localized(language), isPresented: $viewModel.showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    // MARK: - Game Selection Card
    private var gameSelectionCard: some View {
        VStack {
            Text(Resources.Text.selectGame.localized(language))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.basicBlack)
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
                        text: $viewModel.singlePlayerName,
                        onSubmit: viewModel.startGame
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
                        text: $viewModel.playerOneName
                    )
                    playerNameTextField(
                        placeholder: Resources.Text.player2Name.localized(language),
                        text: $viewModel.playerTwoName
                    )
                }
                
                nextButton
            }
        }
        .padding()
        .frame(width: 285, height: cardHeight)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)
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
        Button(action: viewModel.startGame) {
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
