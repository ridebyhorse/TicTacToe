//
//  CoordinatorVIew.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct CoordinatorView: View {
    @ObservedObject var coordinator = Coordinator()
    
    var body: some View {
        Group {
            switch coordinator.navigationState {
            case .onboarding:
                StartView(viewModel: StartViewModel(coordinator: coordinator))
            case .game:
                GameView(viewModel: GameViewModel(coordinator: coordinator))
            case .setting:
                SettingGameView(viewModel: SettingsViewModel(coordinator: coordinator))
            case .rules:
                RulesView(viewModel: RulesViewModel(coordinator: coordinator))
            case .result:
                ResultView(viewModel: ResultViewModel(coordinator: coordinator))
            }
        }
        .animation(.bouncy, value: coordinator.navigationState)
    }
}


