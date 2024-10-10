//
//  GameSelectView.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/1/24.
//

import SwiftUI

// MARK: - GameSelectView
struct GameSelectView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: GameSelectViewModel
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @State private var showCustomAlert = false
    
    // MARK: - Drawing Constants
    private struct Drawing {
        static let toolbarHeight: CGFloat = 44
        static let cornerRadius: CGFloat = 30
        static let frameWidth: CGFloat = 285
        static let singlePlayerHeight: CGFloat = 450
        static let twoPlayersHeight: CGFloat = 514
        static let padding10: CGFloat = 10
        static let paddingBottom: CGFloat = 20
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                ToolBarView(
                    showRightButton: true,
                    rightButtonAction: viewModel.showSettings,
                    title: ""
                )
                .frame(height: Drawing.toolbarHeight)
                .background(Color.white)
                .zIndex(1)
                
                Spacer()
                gameSelectionCard
                    .animation(.easeInOut(duration: 0.3), value: viewModel.selectedGameMode)
                Spacer()
            }
            .blur(radius: showCustomAlert ? 5 : 0)
            
            // Custom Alert
            if showCustomAlert {
                CustomAlertView(message: Resources.Text.enterYourNameAlert.localized(language)) {
                    showCustomAlert = false
                }
                .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
                .transition(.opacity)
                .zIndex(2)
                .cornerRadius(Drawing.cornerRadius)
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
        ShadowedCardView {
            VStack {
                Text(Resources.Text.selectGame.localized(language))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.basicBlue)
                    .padding(Drawing.padding10)
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    GameModeButton(
                        icon: "singlePlayerIcon",
                        title: Resources.Text.singlePlayer.localized(language),
                        isSelected: viewModel.selectedGameMode == .singlePlayer
                    ) {
                        withAnimation {
                            viewModel.setGameMode(.singlePlayer)
                        }
                    }
                    
                    if viewModel.selectedGameMode == .singlePlayer {
                        CustomTextField(
                            placeHolder: Resources.Text.enterYourName.localized(language),
                            text: $viewModel.player
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    GameModeButton(
                        icon: "twoPlayersIcon",
                        title: Resources.Text.twoPlayers.localized(language),
                        isSelected: viewModel.selectedGameMode == .twoPlayers
                    ) {
                        withAnimation {
                            viewModel.setGameMode(.twoPlayers)
                        }
                    }
                    
                    if viewModel.selectedGameMode == .twoPlayers {
                        CustomTextField(
                            placeHolder: Resources.Text.enterYourName.localized(language),
                            text: $viewModel.player
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        
                        CustomTextField(
                            placeHolder: Resources.Text.opponentName.localized(language),
                            text: $viewModel.opponent
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    nextButton
                }
            }
        }
        .frame(width: Drawing.frameWidth, height: cardHeight)
    }
    
    
    private var nextButton: some View {
        BasicButton(
            styleType: .primary,
            title: Resources.Text.next.localized(language)
        ) {
            if viewModel.player.isEmpty {
                showCustomAlert = true
            } else {
                viewModel.startGame()
            }
        }
        .padding(.bottom, Drawing.paddingBottom)
    }
    
    // MARK: - Computed Properties
    private var cardHeight: CGFloat {
        switch viewModel.selectedGameMode {
        case .singlePlayer: return Drawing.singlePlayerHeight
        case .twoPlayers: return Drawing.twoPlayersHeight
        }
    }
}

// MARK: - Preview
#Preview {
    GameSelectView(viewModel: GameSelectViewModel(coordinator: Coordinator()))
}

