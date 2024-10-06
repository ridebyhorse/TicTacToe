//
//  ResultViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class ResultViewModel: ObservableObject {
    // MARK: Properties
    @Published var gameResult: GameResult
    private let coordinator: Coordinator
    
    // MARK: Initialization
    init(
        coordinator: Coordinator,
        winner: Player?,
        playedAgainstAI: Bool
    ) {
        self.coordinator = coordinator
        
        if let winner {
            let aiWin = playedAgainstAI && winner.name == Resources.Text.ai
            gameResult = aiWin ? .lose : .win(name: winner.name)
        } else {
            gameResult = .draw
        }
    }
    
    //MARK: - NavigationState
    func openLaunch() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
    
    func restartGame() {
        coordinator.updateNavigationState(action: .startGame)
    }
}
