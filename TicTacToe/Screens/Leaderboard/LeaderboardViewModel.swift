//
//  LeaderboardViewModel.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 01.10.2024.
//

import Foundation

final class LeaderboardViewModel: ObservableObject {
    // MARK: Properties
    @Published var gameResults: [LeaderboardGameRound] = []
    private let coordinator: Coordinator
    
    // MARK: Initialization
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        gameResults = StorageManager.shared.getLeaderboards()
        gameResults.sort(by: {$0.player.score > $1.player.score})
    }
    
    //MARK: - NavigationState
    func dismissLeaderboard() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
}
