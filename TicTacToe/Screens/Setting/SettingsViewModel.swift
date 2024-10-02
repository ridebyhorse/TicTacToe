//
//  SettingsViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    // MARK: Properties
    private let coordinator: Coordinator
    
    // MARK: Initialization
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    //MARK: - NavigationState
    func dissmisSettings() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
}
