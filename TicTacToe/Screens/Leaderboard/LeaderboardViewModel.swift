//
//  LeaderboardViewModel.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 01.10.2024.
//

import Foundation

final class LeaderboardViewModel: ObservableObject {
    // MARK: Properties
    @Published var gameResults: [LeaderboardPlayer] = []
    private let coordinator: Coordinator
    
    // MARK: Initialization
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        gameResults = StorageManager.shared.getLeaderboard()
        gameResults.sort(by: {$0.score > $1.score})
    }
    
    //MARK: - NavigationState
    func dismissLeaderboard() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
}
