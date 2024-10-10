//
//  Untitled.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/1/24.
//
import Foundation

@MainActor
final class GameSelectViewModel: ObservableObject {
    // MARK: Properties
    @Published var player: String = ""
    @Published var opponent: String = ""
    @Published var selectedGameMode: GameMode = .singlePlayer
    @Published var showingAlert: Bool = false
    
    private let userManager: UserManager
    private let coordinator: Coordinator
    
    // MARK: Initialization
    init(userManager: UserManager = .shared, coordinator: Coordinator) {
        self.userManager = userManager
        self.coordinator = coordinator
    }
    
    // MARK: - Game Logic
    func setGameMode(_ mode: GameMode) {
        selectedGameMode = mode
        userManager.setGameMode(mode)
    }
    
    func startGame() {
        if validatePlayerInput() {
            setPlayers()
            coordinator.updateNavigationState(action: .startGame)
        } else {
            showingAlert = true
        }
    }
    
    //MARK: - NavigationState
    func showSettings() {
        coordinator.updateNavigationState(action: .showSettings)
    }
    
    func openLeaderboard() {
        coordinator.updateNavigationState(action: .leaderboard)
    }
    
    // MARK: - Private Methods
    private func validatePlayerInput() -> Bool {
        switch selectedGameMode {
        case .singlePlayer:
            return !player.isEmpty
        case .twoPlayers:
            return !player.isEmpty && !opponent.isEmpty
        }
    }
    
    private func setPlayers() {
        switch selectedGameMode {
        case .singlePlayer:
            userManager.setPlayers(player1Name: player, player2Name: nil)
        case .twoPlayers:
            userManager.setPlayers(player1Name: player, player2Name: opponent)
        }
    }
}
