//
//  SettingGameView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct SettingGameView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea()
            VStack {
                toolBar
                Spacer()
                settingsContent
                Spacer()
            }
        }
        //MARK: - Default Icon Selection
        .onAppear {
           
            if viewModel.selectedSymbol.isEmpty && viewModel.secondPlayerSymbol.isEmpty {
                viewModel.selectedSymbol = "cross"
                viewModel.secondPlayerSymbol = "circle"
                viewModel.updateSymbol("cross")
                viewModel.updateSecondPlayerSymbol("circle")
            }
        }
    }

    private var toolBar: some View {
        ToolBarView(
            showBackButton: true,
            backButtonAction: {
                viewModel.saveSettings()
                viewModel.dissmisSettings()
            },
            title: Resources.Text.settings
        )
        .frame(height: 44)
    }
    
    private var settingsContent: some View {
            VStack {
                SettingPickerView(
                    selectedValue: $viewModel.selectedDuration,
                    title: Resources.Text.turnOnTime.localized(language)
                )
                
                SettingPickerView(
                    selectedValue: $viewModel.selectedMusic,
                    title: Resources.Text.selectMusicStyle.localized(language)
                )
                
                SettingPickerView(
                    selectedValue: $viewModel.selectedLevel,
                    title: Resources.Text.selectDifficultyLevel.localized(language)
                )
                
               
                VStack(alignment: .center) {
                    Text(Resources.Text.selectPlayerStyle.localized(language))
                        .font(.headline)
                        .font(.navigationTitle)
                            
                        .foregroundColor(.basicBlack)
                        .padding(.top, 20)
                        
                    
                   selectPlayer
                    Spacer()
                    playerStylesScrollView
                        .padding(.top, 50 )
                }
                .padding(.horizontal)
            }
            
        }
    
    
    // MARK: - Vertical ScrollView For Choosing icon
    private var selectPlayer: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    playerSelectionSection(playerName: viewModel.playerOneName, selectedSymbol: viewModel.selectedSymbol, selectSymbolAction: selectPlayerOneSymbol)
                    playerSelectionSection(playerName: viewModel.playerTwoName, selectedSymbol: viewModel.secondPlayerSymbol, selectSymbolAction: selectPlayerTwoSymbol)
                }
                .padding()
                .frame(width: 285, height: 330)
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 5)

                Spacer()
            }
        }
    }

    private func playerSelectionSection(playerName: String, selectedSymbol: String, selectSymbolAction: @escaping (String) -> Void) -> some View {
        VStack {
            Text("\(playerName) Player Name")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.basicBlack)

            HStack(spacing: 30) {
                symbolButton(symbol: "crossPink", isSelected: selectedSymbol == "cross", action: {
                    selectSymbolAction("cross")
                })
                symbolButton(symbol: "circlePurple", isSelected: selectedSymbol == "circle", action: {
                    selectSymbolAction("circle")
                })
            }
        }
    }

    private func symbolButton(symbol: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(symbol)
                .resizable()
                .frame(width: 48, height: 48)
                .padding()
                .background(isSelected ? Color.basicBackground : Color.white)
                .cornerRadius(20)
                .shadow(radius: 0.2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.basicBlue.opacity(0.2) : Color.clear, lineWidth: 2)
                )
        }
    }
//MARK: - Helper functions
    func selectPlayerOneSymbol(_ symbol: String) {
        viewModel.selectedSymbol = symbol
        viewModel.updateSymbol(symbol)
        viewModel.secondPlayerSymbol = (symbol == "cross") ? "circle" : "cross"
        viewModel.updateSecondPlayerSymbol(viewModel.secondPlayerSymbol)
    }

    func selectPlayerTwoSymbol(_ symbol: String) {
        viewModel.secondPlayerSymbol = symbol
        viewModel.updateSecondPlayerSymbol(symbol)
        viewModel.selectedSymbol = (symbol == "cross") ? "circle" : "cross"
        viewModel.updateSymbol(viewModel.selectedSymbol)
    }
   
   
//MARK: - Horizontal ScrollView

    private var playerStylesScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(PlayerStyle.allCases, id: \.self) { style in
                        let isSelected = viewModel.selectedIndex == style
                        StyleCellView(
                            styleImageForPlayer1: style.imageNames.player1,
                            styleImageForPlayer2: style.imageNames.player2,
                            isSelected: isSelected,
                            action: {
                                withAnimation {
                                    viewModel.selectedIndex = style
                                    proxy.scrollTo(style, anchor: .center)
                                }
                            }
                        )
                        .id(style)
                    }
                }
                .padding(.horizontal)
            }
            //.padding(.bottom)
        }
        
    }

    
}

#Preview {
    SettingGameView(viewModel: SettingsViewModel(coordinator: Coordinator()))
}
