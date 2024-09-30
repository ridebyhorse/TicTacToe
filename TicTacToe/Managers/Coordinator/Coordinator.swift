//
//  Coordinator.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class Coordinator: ObservableObject {
    
    enum NavigationState {
        case onboarding
        case game
        case setting
        case rules
        case result
    }
    
    enum CoordinatorAction {
        case showOnboarding
        case startGame
        case showSettings
        case showRules
        case showResult
    }
    
    @Published var navigationState: NavigationState = .onboarding
    
    private func reduce(_ state: NavigationState, action: CoordinatorAction) -> NavigationState {
        
        var newState = state
        
        switch action {
        case .showOnboarding:
            newState = .onboarding
        case .startGame:
            newState = .game
        case .showSettings:
            newState = .setting
        case .showRules:
            newState = .rules
        case .showResult:
            newState = .result
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
