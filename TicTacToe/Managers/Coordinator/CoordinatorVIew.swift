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
        ZStack {
            switch coordinator.navigationState {
            case .onboarding:
                StartView(viewModel: StartViewModel(coordinator: coordinator))
            case .selectGame:
                GameSelectView(viewModel: GameSelectViewModel(coordinator: coordinator))
            case .game:
                GameView(viewModel: GameViewModel(coordinator: coordinator))
            case .setting:
                SettingGameView(viewModel: SettingsViewModel(coordinator: coordinator))
            case .rules:
                RulesView(viewModel: RulesViewModel(coordinator: coordinator))
            case .result(let winner, let playedAgainstAI):
                ResultView(viewModel: ResultViewModel(coordinator: coordinator, winner: winner, playedAgainstAI: playedAgainstAI))
            case .leaderboard:
                LeaderboardView(viewModel: LeaderboardViewModel(coordinator: coordinator))
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: coordinator.navigationState)
    }
}
