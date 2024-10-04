//
//  Coordinator.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class Coordinator: ObservableObject {
    
    enum NavigationState: Equatable {
        case onboarding
        case selectGame
        case game
        case setting
        case rules
        case result(winner: User?, playedAgainstAI: Bool)
        case leaderboard
    }
    
    enum CoordinatorAction {
        case showOnboarding
        case selectGame
        case startGame
        case showSettings
        case showRules
        case showResult(winner: User?, playedAgainstAI: Bool)
        case leaderboard
    }
    
    @Published var navigationState: NavigationState = .onboarding
    
    private func reduce(_ state: NavigationState, action: CoordinatorAction) -> NavigationState {
        
        var newState = state
        
        switch action {
        case .showOnboarding:
            newState = .onboarding
        case .selectGame:
            newState = .selectGame
        case .startGame:
            newState = .game
        case .showSettings:
            newState = .setting
        case .showRules:
            newState = .rules
        case .showResult(let winner, let playedAgainstAI):
            newState = .result(winner: winner, playedAgainstAI: playedAgainstAI)
        case .leaderboard:
            newState = .leaderboard
        }
        return newState
    }
    
    func updateNavigationState(action: CoordinatorAction) {
        Task {
            await MainActor.run {
                navigationState = reduce(navigationState, action: action)
            }
        }
    }
}
