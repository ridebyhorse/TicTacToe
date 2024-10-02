//
//  StartViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class StartViewModel: ObservableObject {
    // MARK: Properties
    private let coordinator: Coordinator
    
    // MARK: Initialization
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - NavigationState
    func startGame() {
        coordinator.updateNavigationState(action: .selectGame)
    }
    
    func openSettings() {
        coordinator.updateNavigationState(action: .showSettings)
    }
    
    func openRules() {
        coordinator.updateNavigationState(action: .showRules)
    }
    
    func openLeaderboard() {
        coordinator.updateNavigationState(action: .leaderboard)
    }
}
