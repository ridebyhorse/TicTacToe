//
//  RulesViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class RulesViewModel: ObservableObject {
    // MARK: Properties
    private let coordinator: Coordinator
    
    // MARK: Initialization
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    //MARK: - NavigationState
    func dismissRules() {
        
    }
}
