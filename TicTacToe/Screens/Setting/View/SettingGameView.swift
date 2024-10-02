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
    
    @State private var selectedIndex: PlayerStyle = .crossPinkCirclePurple
 
    @State private var selectedDuration: Duration = .none
    @State private var selectedMusic: MusicStyle = .none
    @State private var selectedLevel: DifficultyLevel = .standard
    
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
            backButtonAction: viewModel.dissmisSettings,
            title: Resources.Text.settings
        )
        .frame(height: 44)
    }
    
    private var settingsContent: some View {
            VStack {
                TogglePickerView(
                    selectedValue: $selectedDuration,
                    title: "Turn on the time"
                )
                
                TogglePickerView(
                    selectedValue: $selectedMusic,
                    title: "Select Music Style"
                )
                
                TogglePickerView(
                    selectedValue: $selectedLevel,
                    title: "Select difficulty level"
                )
                
                playerStylesScrollView
            }
        }



    private var playerStylesScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(PlayerStyle.allCases, id: \.self) { style in
                        let isSelected = selectedIndex == style
                        StyleCellView(
                            styleImageForPlayer1: style.imageNames.player1,
                            styleImageForPlayer2: style.imageNames.player2,
                            isSelected: isSelected,
                            action: {
                                withAnimation {
                                    selectedIndex = style
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
