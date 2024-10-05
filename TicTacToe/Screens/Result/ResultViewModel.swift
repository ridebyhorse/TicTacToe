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
    private let musicManager: MusicManager
    
    // MARK: Initialization
    init(
        coordinator: Coordinator,
        winner: Player?,
        playedAgainstAI: Bool,
        musicManager: MusicManager = .shared
    ) {
        self.coordinator = coordinator
        self.musicManager = musicManager
        
        if let winner {
            let aiWin = playedAgainstAI && winner.name == Resources.Text.ai
            gameResult = aiWin ? .lose : .win(name: winner.name)
        } else {
            gameResult = .draw
        }
        
        musicManager.playSoundFor(.final)
    }
    
    //MARK: - NavigationState
    func openLaunch() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
    
    func restartGame() {
        coordinator.updateNavigationState(action: .startGame)
    }
}
