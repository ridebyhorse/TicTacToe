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
    @Published var singlePlayerName: String = ""
    @Published var playerOneName: String = ""
    @Published var playerTwoName: String = ""
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
        if selectedGameMode == .singlePlayer {
            if singlePlayerName.isEmpty {
                showingAlert = true
                return
            }
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
