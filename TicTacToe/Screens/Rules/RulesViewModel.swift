//
//  RulesViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class RulesViewModel: ObservableObject {
    // MARK: Properties
    @Published var rules = [Resources.Text.rule1, Resources.Text.rule2, Resources.Text.rule3, Resources.Text.rule4]
    private let coordinator: Coordinator
    
    // MARK: Initialization
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    //MARK: - NavigationState
    func dismissRules() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
}
