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
                        .padding(.top, 50)
                        .padding(.leading)
                    
                    playerStylesScrollView
                }
            }
        }



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
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    SettingGameView(viewModel: SettingsViewModel(coordinator: Coordinator()))
}
