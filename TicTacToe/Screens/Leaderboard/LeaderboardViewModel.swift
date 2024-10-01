//
//  LeaderboardViewModel.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 01.10.2024.
//

import Foundation

final class LeaderboardViewModel: ObservableObject {
    // MARK: Properties
    @Published var gameResults: [LeaderboardViewItem] = [
        .init(username: "Ana", winNumber: 13),
        .init(username: "Alex", winNumber: 95),
        .init(username: "Anatoly", winNumber: 16),
        .init(username: "Oksana", winNumber: 45),
        .init(username: "Olga", winNumber: 193),
        .init(username: "Oleg", winNumber: 274),
        .init(username: "Ana", winNumber: 242),
        .init(username: "Alex", winNumber: 55),
        .init(username: "Anatoly", winNumber: 75),
        .init(username: "Oksana", winNumber: 67),
        .init(username: "Olga", winNumber: 103),
        .init(username: "Oleg", winNumber: 27),
        .init(username: "Ana", winNumber: 34),
        .init(username: "Alex", winNumber: 19),
        .init(username: "Anatoly", winNumber: 38),
        .init(username: "Oksana", winNumber: 24),
        .init(username: "Olga", winNumber: 174),
        .init(username: "Oleg", winNumber: 0),
    ]
    private let coordinator: Coordinator
    
    // MARK: Initialization
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        gameResults.sort(by: {$0.winNumber > $1.winNumber})
    }
    
    //MARK: - NavigationState
    func dismissLeaderboard() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
}
