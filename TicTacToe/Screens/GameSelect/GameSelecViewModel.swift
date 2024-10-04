//
//  Untitled.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/1/24.
//

import Foundation
import SwiftUI

@MainActor
final class GameSelectViewModel: ObservableObject {
    // MARK: Properties
    @Published var singlePlayerName: String = ""
    @Published var playerOneName: String = ""
    @Published var playerTwoName: String = ""
    
    private let userManager: UserManager
    private let coordinator: Coordinator
    
    
    // MARK: Initialization
    init(
        userManager: UserManager = .shared,
        coordinator: Coordinator) {
            self.userManager = userManager
            self.coordinator = coordinator
        }
    
    func setGameMode(_ mode: GameMode) {
        userManager.setGameMode(mode)
    }
    
    // MARK: - NavigationState
    func startGame() {
        if userManager.gameMode == .singlePlayer {
            userManager.setPlayers(player1Name: singlePlayerName, player2Name: "AI")
        } else {
            userManager.setPlayers(player1Name: playerOneName, player2Name: playerTwoName)
        }
        
        coordinator.updateNavigationState(action: .startGame)
    }
    
    func showSettings() {
        coordinator.updateNavigationState(action: .showSettings)
    }
    
}

