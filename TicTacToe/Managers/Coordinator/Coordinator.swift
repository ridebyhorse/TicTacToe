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
        case result(winner: Player?, playedAgainstAI: Bool)
        case leaderboard
    }
    
    enum CoordinatorAction {
        case showOnboarding
        case selectGame
        case startGame
        case showSettings
        case showRules
        case showResult(winner: Player?, playedAgainstAI: Bool)
        case leaderboard
        case backFromSettings
    }
    
    @Published var navigationState: NavigationState = .onboarding
    private var previousState: NavigationState = .onboarding
    
    private func reduce(_ state: NavigationState, action: CoordinatorAction) -> NavigationState {
        
        var newState = state
        
        switch action {
        case .showOnboarding:
            previousState = state 
            newState = .onboarding
        case .selectGame:
            previousState = state
            newState = .selectGame
        case .startGame:
            previousState = state
            newState = .game
        case .showSettings:
            previousState = state
            newState = .setting
        case .showRules:
            previousState = state
            newState = .rules
        case .showResult(let winner, let playedAgainstAI):
            previousState = state
            newState = .result(winner: winner, playedAgainstAI: playedAgainstAI)
        case .leaderboard:
            previousState = state
            newState = .leaderboard
        case .backFromSettings:
            newState = previousState
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
