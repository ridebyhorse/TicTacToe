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
    
    @State private var isLanguageState = false
    @State private var isMusicState = false
    @State private var isLevelState = false
    @State private var isSymbolState = false
    @State private var isThemeState = false
    
    
    // MARK: - Drawing Constants
    enum Drawing {
        static let defaultPadding: CGFloat = 20
        static let topPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 30
        static let horizontalSpacing: CGFloat = 24
        static let spacingBetweenElements: CGFloat = 20
        static let cornerRadius: CGFloat = 30
        static let toolBarHeight: CGFloat = 44
        static let animationDuration: Double = 0.3
        static let titleFontSize: CGFloat = 20
    }
    
    var body: some View {
        ZStack {
            Color.basicBackground.ignoresSafeArea()
            VStack {
                toolBar
                Spacer()
                ShadowedCardView {
                    settingsContent
                }
                .padding(Drawing.defaultPadding)
                .animation(
                    .easeInOut(duration: Drawing.animationDuration),
                    value: viewModel.selectedDuration.isSelectedDuration
                )
                .animation(
                    .easeInOut(duration: Drawing.animationDuration),
                    value: viewModel.isSelectedMusic
                )
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
        .frame(height: Drawing.toolBarHeight)
    }
    
    private var settingsContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Drawing.spacingBetweenElements) {
                
                SettingPickerView(
                    selectedValue: $viewModel.userTheme,
                    isExpanded: $isThemeState,
                    title: Resources.Text.selectTheme.localized(language)
                )
                
                TimerView(
                    title: Resources.Text.time.localized(language),
                    subTitle: Resources.Text.duration.localized(language),
                    isTimerEnabled: $viewModel.selectedDuration.isSelectedDuration,
                    timerSeconds: $viewModel.duration
                )
                
                SettingPickerView(
                    selectedValue: $language,
                    isExpanded: $isLanguageState,
                    title: Resources.Text.selectedLanguage.localized(language)
                )
                
                VStack(spacing: Drawing.spacingBetweenElements) {
                    HStack {
                        Toggle(isOn: $viewModel.isSelectedMusic) {
                            Text(Resources.Text.selectMusicStyle.localized(language))
                                .titleText(size: Drawing.titleFontSize)
                        }
                        .tint(.basicBlue)
                    }
                    .padding()
                    .background(LightBlueBackgroundView {
                    })
                    .cornerRadius(Drawing.cornerRadius)
                    
                    if viewModel.isSelectedMusic {
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
            .padding(.top, Drawing.topPadding)
            .padding()
        }
    }
    
    private var playerStylesScrollView: some View {
        ScrollViewReader { proxy in
            LightBlueBackgroundView {
                Text(Resources.Text.selectPlayerSkins.localized(language))
                    .font(.headline)
                    .foregroundColor(.basicBlack)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Drawing.horizontalSpacing) {
                        ForEach(PlayerStyle.allCases, id: \.self) { style in
                            let isSelected = viewModel.selectedIndex == style
                            
                            SkinCellView(
                                styleImageForPlayer1: style.imageNames.player1,
                                styleImageForPlayer2: style.imageNames.player2,
                                isSelected: isSelected,
                                isPlayer1Selected: viewModel.selectedPlayerSymbol == .tic,
                                action: {
                                    withAnimation {
                                        viewModel.selectedIndex = style
                                        proxy.scrollTo(style, anchor: .center)
                                    }
                                }
                            )
                            .id(style)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, Drawing.bottomPadding)
                }
                .onAppear {
                    proxy.scrollTo(viewModel.selectedIndex, anchor: .center)
                }
            }
        }
    }
    
}

#Preview {
    SettingGameView(viewModel: SettingsViewModel(coordinator: Coordinator()))
}

