//
//  LeaderboardViewModel.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 01.10.2024.
//

import Foundation

final class LeaderboardViewModel: ObservableObject {
    // MARK: Properties
    
    @Published var bestRound: LeaderboardRound?
    @Published var bestGames = [LeaderboardGame]()
    
    private let coordinator: Coordinator
    private let storageManager: StorageManager
    
    
    
    // MARK: Initialization
    init(coordinator: Coordinator, storageManager: StorageManager = .shared) {
        self.coordinator = coordinator
        self.storageManager = storageManager
        getBestRound()
        getBestGames()
    }
    
    func getBestRound() {
        var rounds = storageManager.getLeaderboardRounds()
        rounds.sort { $0.durationRound < $1.durationRound }
        bestRound = rounds.first
    }
    
    
    private func getBestGames() {
        bestGames = storageManager.getLeaderboardGames()
        bestGames.sort {$0.player.score > $1.player.score}
    }
    
    //MARK: - NavigationState
    func dismissLeaderboard() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
}

