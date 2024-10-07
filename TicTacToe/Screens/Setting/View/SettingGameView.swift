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
    
    @State private var isTimeState = false
    @State private var isLanguageState = false
    @State private var isMusicState = false
    @State private var isSelectMusic = false
    @State private var isLevelState = false
    @State private var isSymbolState = false
    
    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea()
            VStack {
                toolBar
                Spacer()
                ShadowedCardView {
                    settingsContent
                }
                .padding(16)
                .animation(.easeInOut(duration: 0.3), value: isTimeState)
                .animation(.easeInOut(duration: 0.3), value: isSelectMusic)
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
            title: Resources.Text.settings.localized(language)
        )
        .frame(height: 44)
    }
    
    private var settingsContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) { // Задаем равные отступы
                TimerView(
                    title: Resources.Text.turnOnTime,
                    subTitle: Resources.Text.duration,
                    isTimerEnabled: $isTimeState,
                    timerSeconds: $viewModel.raundDuration,
                    onUpdate: { duration in
                        viewModel.selectedDuration = duration
                    }
                )
                
                SettingPickerView(
                    selectedValue: $language,
                    isExpanded: $isLanguageState,
                    title: Resources.Text.selectedLanguage.localized(language)
                )
                
                VStack(spacing: 20) {
                    HStack {
                        Toggle(isOn: $isSelectMusic) {
                            Text(Resources.Text.selectMusicStyle.localized(language))
                                .titleText(size: 20)
                        }
                        .tint(.basicBlue)
                    }
                    .padding()
                    .background(LightBlueBackgroundView {
                    })
                    .cornerRadius(30)
                    
                    if isSelectMusic {
                        SettingPickerView(
                            selectedValue: $viewModel.selectedMusic,
                            isExpanded: $isMusicState,
                            title: Resources.Text.selectMusicStyle.localized(language)
                        )
                    }
                }
                
                SettingPickerView(
                    selectedValue: $viewModel.selectedLevel,
                    isExpanded: $isLevelState,
                    title: Resources.Text.selectDifficultyLevel.localized(language)
                )
                
                GameSymbolSelectionView(
                    selectedSymbol: $viewModel.selectedPlayerSymbol,
                    imageNameForPlayer1: viewModel.selectedIndex.imageNames.player1,
                    imageNameForPlayer2: viewModel.selectedIndex.imageNames.player2
                )
                playerStylesScrollView
            }
            .padding(.top, 16)
            .padding()
        }
    }
    
    private var playerStylesScrollView: some View {
        ScrollViewReader { proxy in
            LightBlueBackgroundView {
                Text(Resources.Text.selectPlayerSkins.localized(language))
                    .font(.headline)
                    .foregroundColor(.basicBlack)
                
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(PlayerStyle.allCases, id: \.self) { style in
                                let isSelected = viewModel.selectedIndex == style
                                
                                SkinCellView(
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
                                .frame(
                                    width: isSelected ? 90 : 85,
                                    height: isSelected ? 90 : 85)
                            }
                        }
                        .padding(.horizontal, (geometry.size.width + 300) / 2)
                    }
                }
                .frame(height: 100)
            }
        }
    }
}

#Preview {
    SettingGameView(viewModel: SettingsViewModel(coordinator: Coordinator()))
}
